import notificationService from '../services/notificationService.js';
import { successResponse, paginatedResponse } from '../utils/apiResponse.js';

export const getNotifications = async (req, res, next) => {
  try {
    const result = await notificationService.getNotifications(req.userId, req.query);
    return paginatedResponse(
      res,
      {
        notifications: result.data,
        unreadCount: result.unreadCount,
      },
      result.total,
      result.page,
      result.limit
    );
  } catch (error) {
    next(error);
  }
};

export const markAsRead = async (req, res, next) => {
  try {
    const notification = await notificationService.markAsRead(req.params.id, req.userId);
    return successResponse(res, notification, 'Notification marked as read.');
  } catch (error) {
    next(error);
  }
};

export const markAllAsRead = async (req, res, next) => {
  try {
    await notificationService.markAllAsRead(req.userId);
    return successResponse(res, null, 'All notifications marked as read.');
  } catch (error) {
    next(error);
  }
};

export const deleteNotification = async (req, res, next) => {
  try {
    await notificationService.deleteNotification(req.params.id, req.userId);
    return successResponse(res, null, 'Notification deleted.');
  } catch (error) {
    next(error);
  }
};
