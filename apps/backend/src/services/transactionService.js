import mongoose from 'mongoose';
import Category from '../models/Category.js';
import transactionRepository from '../repositories/transactionRepository.js';
import budgetService from './budgetService.js';

// Helper to resolve category ID from name or ObjectId string
async function resolveCategory(userId, categoryNameOrId, type = 'expense') {
  if (!categoryNameOrId) return null;

  if (mongoose.Types.ObjectId.isValid(categoryNameOrId)) {
    return categoryNameOrId;
  }

  // Try to find by name case-insensitively
  let category = await Category.findOne({
    name: { $regex: new RegExp(`^${categoryNameOrId}$`, 'i') },
    $or: [{ user: userId }, { user: null, isDefault: true }],
  });

  // Create if not found
  if (!category) {
    const name = categoryNameOrId.charAt(0).toUpperCase() + categoryNameOrId.slice(1).toLowerCase();
    const defaults = {
      food: { icon: 'restaurant', color: '#ef4444' },
      transport: { icon: 'directions_car', color: '#3b82f6' },
      shopping: { icon: 'shopping_bag', color: '#ec4899' },
      entertainment: { icon: 'movie', color: '#f59e0b' },
      bills: { icon: 'receipt_long', color: '#8b5cf6' },
      salary: { icon: 'work', color: '#10b981' },
      freelance: { icon: 'code', color: '#14b8a6' },
      investment: { icon: 'trending_up', color: '#f59e0b' },
      health: { icon: 'favorite', color: '#ec4899' },
      education: { icon: 'school', color: '#3b82f6' },
      credit: { icon: 'credit_card', color: '#10b981' },
    };
    const key = categoryNameOrId.toLowerCase();
    const config = defaults[key] || { icon: 'help-circle', color: '#6366f1' };

    category = await Category.create({
      user: userId,
      name,
      type: type || 'expense',
      icon: config.icon,
      color: config.color,
      isDefault: false,
    });
  }

  return category._id;
}

class TransactionService {
  /**
   * @param {string} userEmail  – used as the transaction doc key
   * @param {string} userId     – ObjectId, used for category ownership
   * @param {object} queryParams
   */
  async getTransactions(userEmail, userId, queryParams) {
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

    return transactionRepository.findByUser(userEmail, filter, {
      page: parseInt(page, 10),
      limit: parseInt(limit, 10),
      sort: sortOption,
    });
  }

  async getTransaction(transactionId, userEmail) {
    const transaction = await transactionRepository.findOne(userEmail, transactionId);
    if (!transaction) {
      const error = new Error('Transaction not found.');
      error.statusCode = 404;
      throw error;
    }
    return transaction;
  }

  async createTransaction(userEmail, userId, data) {
    if (data.category) {
      data.category = await resolveCategory(userId, data.category, data.type);
    }
    const transaction = await transactionRepository.create(userEmail, data);
    await budgetService.recalculateSpent(userEmail, userId, transaction.date);
    return transaction;
  }

  async createBulkTransactions(userEmail, userId, transactionsData) {
    const docs = [];
    for (const data of transactionsData) {
      let resolvedCategory = null;
      if (data.category) {
        resolvedCategory = await resolveCategory(userId, data.category, data.type);
      }
      docs.push({ ...data, category: resolvedCategory });
    }

    const created = await transactionRepository.insertMany(userEmail, docs);

    const uniqueDates = [...new Set(
      created.map((t) => {
        const d = new Date(t.date);
        return d.toISOString().split('T')[0];
      })
    )];

    for (const date of uniqueDates) {
      await budgetService.recalculateSpent(userEmail, userId, new Date(date));
    }

    return created;
  }

  async updateTransaction(transactionId, userEmail, userId, data) {
    const existing = await transactionRepository.findOne(userEmail, transactionId);
    if (!existing) {
      const error = new Error('Transaction not found.');
      error.statusCode = 404;
      throw error;
    }

    if (data.category) {
      data.category = await resolveCategory(userId, data.category, data.type || existing.type);
    }

    const updated = await transactionRepository.update(userEmail, transactionId, data);
    await budgetService.recalculateSpent(userEmail, userId, updated.date);
    return updated;
  }

  async deleteTransaction(transactionId, userEmail, userId) {
    const transaction = await transactionRepository.findOne(userEmail, transactionId);
    if (!transaction) {
      const error = new Error('Transaction not found.');
      error.statusCode = 404;
      throw error;
    }

    await transactionRepository.delete(userEmail, transactionId);
    await budgetService.recalculateSpent(userEmail, userId, transaction.date);
    return transaction;
  }

  async getSummary(userEmail, startDate, endDate) {
    const summary = await transactionRepository.getSummary(
      userEmail,
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

  async getMonthlyTotals(userEmail, year, month) {
    return transactionRepository.getMonthlyTotals(userEmail, year, month);
  }

  async getCategoryTotals(userEmail, startDate, endDate) {
    return transactionRepository.getCategoryTotals(
      userEmail,
      new Date(startDate),
      new Date(endDate)
    );
  }

  async getTrends(userEmail, monthsBack = 6) {
    return transactionRepository.getTrends(userEmail, monthsBack);
  }
}

export default new TransactionService();
