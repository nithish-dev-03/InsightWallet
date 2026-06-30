import notificationRepository from '../repositories/notificationRepository.js';

class NotificationService {
  async getNotifications(userId, queryParams) {
    const { page = 1, limit = 20, read, type } = queryParams;
    const filter = {};
    if (read !== undefined) filter.read = read === 'true';
    if (type) filter.type = type;

    const result = await notificationRepository.findByUser(userId, filter, {
      page: parseInt(page, 10),
      limit: parseInt(limit, 10),
      sort: { createdAt: -1 },
    });

    const unreadCount = await notificationRepository.countUnread(userId);

    return { ...result, unreadCount };
  }

  async createBudgetAlert(userId, budget, percentage) {
    return notificationRepository.create({
      user: userId,
      type: 'budget_alert',
      title: 'Budget Alert',
      body: `You have used ${percentage}% of your budget${budget.category ? '' : ' (overall)'}.`,
      data: {
        budgetId: budget._id,
        spent: budget.spent,
        amount: budget.amount,
        percentage,
      },
    });
  }

  async markAsRead(notificationId, userId) {
    const notification = await notificationRepository.markAsRead(notificationId, userId);
    if (!notification) {
      const error = new Error('Notification not found.');
      error.statusCode = 404;
      throw error;
    }
    return notification;
  }

  async markAllAsRead(userId) {
    const result = await notificationRepository.markAllAsRead(userId);
    return result;
  }

  async deleteNotification(notificationId, userId) {
    const notification = await notificationRepository.findOne({
      _id: notificationId,
      user: userId,
    });
    if (!notification) {
      const error = new Error('Notification not found.');
      error.statusCode = 404;
      throw error;
    }
    await notificationRepository.delete(notificationId);
  }
}

export default new NotificationService();
