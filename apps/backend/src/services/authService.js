import crypto from 'crypto';
import authRepository from '../repositories/authRepository.js';
import refreshTokenRepository from '../repositories/refreshTokenRepository.js';
import settingRepository from '../repositories/settingRepository.js';
import { generateAccessToken, generateRefreshToken, verifyToken } from '../utils/generateToken.js';
import sendEmail from '../utils/sendEmail.js';
import env from '../config/env.js';

class AuthService {
  async register({ email, password }) {
    const existingAuth = await authRepository.findByEmail(email);
    if (existingAuth) {
      const error = new Error('Email already registered.');
      error.statusCode = 409;
      throw error;
    }

    const auth = await authRepository.create({ email, password });
    await settingRepository.upsert(auth._id, {});

    const tokens = await this._generateTokens(auth._id);
    return { user: auth, ...tokens };
  }

  async login({ email, password }) {
    const auth = await authRepository.findByEmailWithPassword(email);
    if (!auth) {
      const error = new Error('No User found.');
      error.statusCode = 401;
      throw error;
    }

    const isMatch = await auth.comparePassword(password);
    if (!isMatch) {
      const error = new Error('Invalid email or password.');
      error.statusCode = 401;
      throw error;
    }

    const tokens = await this._generateTokens(auth._id);
    return { user: auth, ...tokens };
  }

  async refreshToken(token) {
    const payload = verifyToken(token, env.jwtRefreshSecret);
    const storedToken = await refreshTokenRepository.findByToken(token);

    if (!storedToken) {
      await refreshTokenRepository.deleteAllForUser(payload.userId);
      const error = new Error('Invalid refresh token.');
      error.statusCode = 401;
      throw error;
    }

    await refreshTokenRepository.deleteByToken(token);
    const tokens = await this._generateTokens(payload.userId);
    return tokens;
  }

  async logout(token) {
    await refreshTokenRepository.deleteByToken(token);
  }

  async forgotPassword(email) {
    const auth = await authRepository.findByEmail(email);
    if (!auth) {
      return;
    }

    const resetToken = crypto.randomBytes(32).toString('hex');
    const hashedToken = crypto.createHash('sha256').update(resetToken).digest('hex');

    auth.resetPasswordToken = hashedToken;
    auth.resetPasswordExpires = Date.now() + 3600000;
    await auth.save();

    const resetUrl = `${env.frontendUrl}/reset-password/${resetToken}`;

    try {
      await sendEmail({
        to: auth.email,
        subject: 'Password Reset Request - InsightWallet',
        html: `
          <h1>Password Reset</h1>
          <p>You requested a password reset. Click the link below to reset your password.</p>
          <a href="${resetUrl}" style="display:inline-block;padding:12px 24px;background:#6366f1;color:#fff;text-decoration:none;border-radius:6px;">Reset Password</a>
          <p>This link expires in 1 hour.</p>
          <p>If you did not request this, please ignore this email.</p>
        `,
      });
    } catch (error) {
      auth.resetPasswordToken = undefined;
      auth.resetPasswordExpires = undefined;
      await auth.save();
      throw error;
    }
  }

  async resetPassword(token, newPassword) {
    const hashedToken = crypto.createHash('sha256').update(token).digest('hex');
    const auth = await authRepository.findOne({
      resetPasswordToken: hashedToken,
      resetPasswordExpires: { $gt: Date.now() },
    });

    if (!auth) {
      const error = new Error('Invalid or expired reset token.');
      error.statusCode = 400;
      throw error;
    }

    auth.password = newPassword;
    auth.resetPasswordToken = undefined;
    auth.resetPasswordExpires = undefined;
    await auth.save();

    await refreshTokenRepository.deleteAllForUser(auth._id);
  }

  async _generateTokens(userId) {
    const accessToken = generateAccessToken(userId);
    const refreshToken = generateRefreshToken(userId);

    const decoded = verifyToken(refreshToken, env.jwtRefreshSecret);
    const expiresAt = new Date(decoded.exp * 1000);

    await refreshTokenRepository.create({
      user: userId,
      token: refreshToken,
      expiresAt,
    });

    return { accessToken, refreshToken };
  }
}

export default new AuthService();
