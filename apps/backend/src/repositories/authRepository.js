import BaseRepository from './BaseRepository.js';
import Auth from '../models/Auth.js';

class AuthRepository extends BaseRepository {
  constructor() {
    super(Auth);
  }

  async findByEmail(email) {
    return this.model.findOne({ email });
  }

  async findByEmailWithPassword(email) {
    return await this.model.findOne({ email }).select('+password');
  }

  async findByIdWithPassword(id) {
    return this.model.findById(id).select('+password +refreshToken');
  }

  async updatePassword(id, hashedPassword) {
    return this.model.findByIdAndUpdate(
      id,
      { password: hashedPassword, resetPasswordToken: undefined, resetPasswordExpires: undefined },
      { new: true }
    );
  }

  async updateRefreshToken(id, refreshToken) {
    return this.model.findByIdAndUpdate(id, { refreshToken }, { new: true });
  }
}

export default new AuthRepository();
