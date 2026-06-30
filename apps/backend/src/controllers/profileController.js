import profileService from '../services/profileService.js';
import { successResponse } from '../utils/apiResponse.js';

export const getProfile = async (req, res, next) => {
  try {
    const profile = await profileService.getProfile(req.userId);
    return successResponse(res, profile);
  } catch (error) {
    next(error);
  }
};

export const updateProfile = async (req, res, next) => {
  try {
    const profile = await profileService.updateProfile(req.userId, req.body);
    return successResponse(res, profile, 'Profile updated.');
  } catch (error) {
    next(error);
  }
};

export const updateAvatar = async (req, res, next) => {
  try {
    const user = await profileService.updateAvatar(req.userId, req.file);
    return successResponse(res, user, 'Avatar updated.');
  } catch (error) {
    next(error);
  }
};

export const getStatistics = async (req, res, next) => {
  try {
    const stats = await profileService.getStatistics(req.userId);
    return successResponse(res, stats);
  } catch (error) {
    next(error);
  }
};
