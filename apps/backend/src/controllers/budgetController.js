import budgetService from '../services/budgetService.js';
import { successResponse, paginatedResponse } from '../utils/apiResponse.js';

export const getBudgets = async (req, res, next) => {
  try {
    const result = await budgetService.getBudgets(req.userId, req.query);
    return paginatedResponse(res, result.data, result.total, result.page, result.limit);
  } catch (error) {
    next(error);
  }
};

export const getBudget = async (req, res, next) => {
  try {
    const budget = await budgetService.getBudget(req.params.id, req.userId);
    return successResponse(res, budget);
  } catch (error) {
    next(error);
  }
};

export const createBudget = async (req, res, next) => {
  try {
    const budget = await budgetService.createBudget(req.userId, req.body);
    return successResponse(res, budget, 'Budget created.', 201);
  } catch (error) {
    next(error);
  }
};

export const updateBudget = async (req, res, next) => {
  try {
    const budget = await budgetService.updateBudget(req.params.id, req.userId, req.body);
    return successResponse(res, budget, 'Budget updated.');
  } catch (error) {
    next(error);
  }
};

export const deleteBudget = async (req, res, next) => {
  try {
    await budgetService.deleteBudget(req.params.id, req.userId);
    return successResponse(res, null, 'Budget deleted.');
  } catch (error) {
    next(error);
  }
};

export const getAlerts = async (req, res, next) => {
  try {
    const alerts = await budgetService.getAlerts(req.userId);
    return successResponse(res, alerts);
  } catch (error) {
    next(error);
  }
};
