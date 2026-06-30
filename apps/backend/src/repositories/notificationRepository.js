import BaseRepository from './BaseRepository.js';
import Notification from '../models/Notification.js';

class NotificationRepository extends BaseRepository {
  constructor() {
    super(Notification);
  }

  async findByUser(userId, filter = {}, pagination = {}) {
    return this.findAll({ user: userId, ...filter }, pagination);
  }

  async markAsRead(notificationId, userId) {
    return this.model.findOneAndUpdate(
      { _id: notificationId, user: userId },
      { read: true },
      { new: true }
    );
  }

  async markAllAsRead(userId) {
    return this.model.updateMany(
      { user: userId, read: false },
      { read: true }
    );
  }

  async countUnread(userId) {
    return this.model.countDocuments({ user: userId, read: false });
  }
}

export default new NotificationRepository();
