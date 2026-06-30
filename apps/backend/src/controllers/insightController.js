import insightService from '../services/insightService.js';
import { successResponse } from '../utils/apiResponse.js';

export const getMonthlySummary = async (req, res, next) => {
  try {
    const now = new Date();
    const month = parseInt(req.query.month, 10) || now.getMonth() + 1;
    const year = parseInt(req.query.year, 10) || now.getFullYear();
    const insight = await insightService.generateMonthlySummary(req.userId, month, year);
    return successResponse(res, insight);
  } catch (error) {
    next(error);
  }
};

export const getSpendingPrediction = async (req, res, next) => {
  try {
    const insight = await insightService.generateSpendingPrediction(req.userId);
    return successResponse(res, insight);
  } catch (error) {
    next(error);
  }
};

export const getBudgetSuggestions = async (req, res, next) => {
  try {
    const insight = await insightService.generateBudgetSuggestions(req.userId);
    return successResponse(res, insight);
  } catch (error) {
    next(error);
  }
};

export const getExpenseTrends = async (req, res, next) => {
  try {
    const insight = await insightService.generateExpenseTrends(req.userId);
    return successResponse(res, insight);
  } catch (error) {
    next(error);
  }
};
