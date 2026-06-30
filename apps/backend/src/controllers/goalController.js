import goalService from '../services/goalService.js';
import { successResponse, paginatedResponse } from '../utils/apiResponse.js';

export const getGoals = async (req, res, next) => {
  try {
    const result = await goalService.getGoals(req.userId, req.query);
    return paginatedResponse(res, result.data, result.total, result.page, result.limit);
  } catch (error) {
    next(error);
  }
};

export const getGoal = async (req, res, next) => {
  try {
    const goal = await goalService.getGoal(req.params.id, req.userId);
    return successResponse(res, goal);
  } catch (error) {
    next(error);
  }
};

export const createGoal = async (req, res, next) => {
  try {
    const goal = await goalService.createGoal(req.userId, req.body);
    return successResponse(res, goal, 'Goal created.', 201);
  } catch (error) {
    next(error);
  }
};

export const updateGoal = async (req, res, next) => {
  try {
    const goal = await goalService.updateGoal(req.params.id, req.userId, req.body);
    return successResponse(res, goal, 'Goal updated.');
  } catch (error) {
    next(error);
  }
};

export const deleteGoal = async (req, res, next) => {
  try {
    await goalService.deleteGoal(req.params.id, req.userId);
    return successResponse(res, null, 'Goal deleted.');
  } catch (error) {
    next(error);
  }
};

export const addMilestone = async (req, res, next) => {
  try {
    const goal = await goalService.addMilestone(req.params.id, req.userId, req.body);
    return successResponse(res, goal, 'Milestone added.', 201);
  } catch (error) {
    next(error);
  }
};
