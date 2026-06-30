import BaseRepository from './BaseRepository.js';
import RefreshToken from '../models/RefreshToken.js';

class RefreshTokenRepository extends BaseRepository {
  constructor() {
    super(RefreshToken);
  }

  async findByToken(token) {
    return this.model.findOne({ token });
  }

  async deleteByToken(token) {
    return this.model.deleteOne({ token });
  }

  async deleteAllForUser(userId) {
    return this.model.deleteMany({ user: userId });
  }
}

export default new RefreshTokenRepository();
