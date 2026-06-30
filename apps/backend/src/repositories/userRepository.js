import BaseRepository from './BaseRepository.js';
import User from '../models/User.js';

class UserRepository extends BaseRepository {
  constructor() {
    super(User);
  }

  async findByEmail(email) {
    return this.model.findOne({ email });
  }

  async findByEmailWithPassword(email) {
    return this.model.findOne({ email }).select('+password');
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

export default new UserRepository();
