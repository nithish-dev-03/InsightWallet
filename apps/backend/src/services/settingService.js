import settingRepository from '../repositories/settingRepository.js';

class SettingService {
  async getSettings(userId) {
    let settings = await settingRepository.findByUser(userId);
    if (!settings) {
      settings = await settingRepository.upsert(userId, {});
    }
    return settings;
  }

  async updateSettings(userId, data) {
    const allowedFields = [
      'theme',
      'language',
      'currency',
      'notifications',
      'privacy',
      'exportFormat',
    ];

    const updates = {};
    for (const field of allowedFields) {
      if (data[field] !== undefined) {
        updates[field] = data[field];
      }
    }

    const settings = await settingRepository.upsert(userId, updates);
    return settings;
  }
}

export default new SettingService();
