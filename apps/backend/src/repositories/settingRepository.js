import BaseRepository from './BaseRepository.js';
import Setting from '../models/Setting.js';

class SettingRepository extends BaseRepository {
  constructor() {
    super(Setting);
  }

  async findByUser(userId) {
    return this.model.findOne({ user: userId });
  }

  async upsert(userId, data) {
    return this.model.findOneAndUpdate(
      { user: userId },
      { ...data, user: userId },
      { new: true, upsert: true, runValidators: true }
    );
  }
}

export default new SettingRepository();
