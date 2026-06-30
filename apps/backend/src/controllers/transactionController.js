import transactionService from '../services/transactionService.js';
import { successResponse, paginatedResponse } from '../utils/apiResponse.js';

export const getTransactions = async (req, res, next) => {
  try {
    const result = await transactionService.getTransactions(req.userId, req.query);
    return paginatedResponse(res, result.data, result.total, result.page, result.limit);
  } catch (error) {
    next(error);
  }
};

export const getTransaction = async (req, res, next) => {
  try {
    const transaction = await transactionService.getTransaction(req.params.id, req.userId);
    return successResponse(res, transaction);
  } catch (error) {
    next(error);
  }
};

export const createTransaction = async (req, res, next) => {
  try {
    const transaction = await transactionService.createTransaction(req.userId, req.body);
    return successResponse(res, transaction, 'Transaction created.', 201);
  } catch (error) {
    next(error);
  }
};

export const updateTransaction = async (req, res, next) => {
  try {
    const transaction = await transactionService.updateTransaction(
      req.params.id,
      req.userId,
      req.body
    );
    return successResponse(res, transaction, 'Transaction updated.');
  } catch (error) {
    next(error);
  }
};

export const deleteTransaction = async (req, res, next) => {
  try {
    await transactionService.deleteTransaction(req.params.id, req.userId);
    return successResponse(res, null, 'Transaction deleted.');
  } catch (error) {
    next(error);
  }
};

export const getSummary = async (req, res, next) => {
  try {
    const { startDate, endDate } = req.query;
    if (!startDate || !endDate) {
      const error = new Error('startDate and endDate are required.');
      error.statusCode = 400;
      throw error;
    }
    const summary = await transactionService.getSummary(req.userId, startDate, endDate);
    return successResponse(res, summary);
  } catch (error) {
    next(error);
  }
};
