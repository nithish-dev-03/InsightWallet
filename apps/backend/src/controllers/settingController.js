import settingService from '../services/settingService.js';
import { successResponse } from '../utils/apiResponse.js';

export const getSettings = async (req, res, next) => {
  try {
    const settings = await settingService.getSettings(req.userId);
    return successResponse(res, settings);
  } catch (error) {
    next(error);
  }
};

export const updateSettings = async (req, res, next) => {
  try {
    const settings = await settingService.updateSettings(req.userId, req.body);
    return successResponse(res, settings, 'Settings updated.');
  } catch (error) {
    next(error);
  }
};
