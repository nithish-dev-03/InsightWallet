import transactionRepository from '../repositories/transactionRepository.js';
import budgetService from './budgetService.js';

class TransactionService {
  async getTransactions(userId, queryParams) {
    const {
      page = 1,
      limit = 20,
      type,
      category,
      startDate,
      endDate,
      search,
      sort = '-date',
    } = queryParams;

    const filter = {};

    if (type) filter.type = type;
    if (category) filter.category = category;
    if (startDate || endDate) {
      filter.date = {};
      if (startDate) filter.date.$gte = new Date(startDate);
      if (endDate) filter.date.$lte = new Date(endDate);
    }
    if (search) {
      filter.description = { $regex: search, $options: 'i' };
    }

    const sortOption = {};
    if (sort.startsWith('-')) {
      sortOption[sort.slice(1)] = -1;
    } else {
      sortOption[sort] = 1;
    }

    return transactionRepository.findByUser(
      userId,
      filter,
      { page: parseInt(page, 10), limit: parseInt(limit, 10), sort: sortOption }
    );
  }

  async getTransaction(transactionId, userId) {
    const transaction = await transactionRepository.findOne({
      _id: transactionId,
      user: userId,
    });
    if (!transaction) {
      const error = new Error('Transaction not found.');
      error.statusCode = 404;
      throw error;
    }
    return transaction;
  }

  async createTransaction(userId, data) {
    const transaction = await transactionRepository.create({
      ...data,
      user: userId,
    });
    await budgetService.recalculateSpent(userId, transaction.date);
    return transaction;
  }

  async updateTransaction(transactionId, userId, data) {
    const transaction = await transactionRepository.findOne({
      _id: transactionId,
      user: userId,
    });
    if (!transaction) {
      const error = new Error('Transaction not found.');
      error.statusCode = 404;
      throw error;
    }

    const updated = await transactionRepository.update(transactionId, data);
    await budgetService.recalculateSpent(userId, updated.date);
    return updated;
  }

  async deleteTransaction(transactionId, userId) {
    const transaction = await transactionRepository.findOne({
      _id: transactionId,
      user: userId,
    });
    if (!transaction) {
      const error = new Error('Transaction not found.');
      error.statusCode = 404;
      throw error;
    }

    await transactionRepository.delete(transactionId);
    await budgetService.recalculateSpent(userId, transaction.date);
    return transaction;
  }

  async getSummary(userId, startDate, endDate) {
    const summary = await transactionRepository.getSummary(
      userId,
      new Date(startDate),
      new Date(endDate)
    );

    const result = {
      income: { total: 0, count: 0, categories: [] },
      expense: { total: 0, count: 0, categories: [] },
    };

    for (const item of summary) {
      if (item._id === 'income') {
        result.income.total = item.grandTotal;
        result.income.count = item.categories.reduce((acc, c) => acc + c.count, 0);
        result.income.categories = item.categories;
      } else if (item._id === 'expense') {
        result.expense.total = item.grandTotal;
        result.expense.count = item.categories.reduce((acc, c) => acc + c.count, 0);
        result.expense.categories = item.categories;
      }
    }

    result.net = result.income.total - result.expense.total;
    return result;
  }

  async getMonthlyTotals(userId, year, month) {
    return transactionRepository.getMonthlyTotals(userId, year, month);
  }

  async getCategoryTotals(userId, startDate, endDate) {
    return transactionRepository.getCategoryTotals(
      userId,
      new Date(startDate),
      new Date(endDate)
    );
  }

  async getTrends(userId, monthsBack = 6) {
    return transactionRepository.getTrends(userId, monthsBack);
  }
}

export default new TransactionService();
