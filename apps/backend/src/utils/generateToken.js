import jwt from 'jsonwebtoken';
import env from '../config/env.js';

export const generateAccessToken = (userId) => {
  return jwt.sign({ userId }, env.jwtSecret, {
    expiresIn: env.jwtExpiresIn,
  });
};

export const generateRefreshToken = (userId) => {
  return jwt.sign({ userId }, env.jwtRefreshSecret, {
    expiresIn: env.jwtRefreshExpiresIn,
  });
};

export const verifyToken = (token, secret) => {
  return jwt.verify(token, secret);
};
