import budgetRepository from '../repositories/budgetRepository.js';
import transactionRepository from '../repositories/transactionRepository.js';
import notificationService from './notificationService.js';

class BudgetService {
  async getBudgets(userId, queryParams) {
    const { page = 1, limit = 20, period } = queryParams;
    const filter = {};
    if (period) filter.period = period;

    return budgetRepository.findByUser(userId, filter, {
      page: parseInt(page, 10),
      limit: parseInt(limit, 10),
    });
  }

  async getBudget(budgetId, userId) {
    const budget = await budgetRepository.findOne({ _id: budgetId, user: userId });
    if (!budget) {
      const error = new Error('Budget not found.');
      error.statusCode = 404;
      throw error;
    }
    return budget;
  }

  async createBudget(userId, data) {
    const budget = await budgetRepository.create({ ...data, user: userId });
    await this.recalculateSpent(userId, budget.startDate, budget);
    return budget;
  }

  async updateBudget(budgetId, userId, data) {
    const budget = await budgetRepository.findOne({ _id: budgetId, user: userId });
    if (!budget) {
      const error = new Error('Budget not found.');
      error.statusCode = 404;
      throw error;
    }
    const updated = await budgetRepository.update(budgetId, data);
    await this.recalculateSpent(userId, updated.startDate, updated);
    return updated;
  }

  async deleteBudget(budgetId, userId) {
    const budget = await budgetRepository.findOne({ _id: budgetId, user: userId });
    if (!budget) {
      const error = new Error('Budget not found.');
      error.statusCode = 404;
      throw error;
    }
    await budgetRepository.delete(budgetId);
  }

  async recalculateSpent(userId, date, budgetOverride = null) {
    if (budgetOverride) {
      await this._recalcSingleBudget(userId, budgetOverride);
      return;
    }

    const budgets = await budgetRepository.findActiveBudgets(userId, date);
    for (const budget of budgets) {
      await this._recalcSingleBudget(userId, budget);
    }
  }

  async _recalcSingleBudget(userId, budget) {
    const matchFilter = {
      user: userId,
      type: 'expense',
      date: { $gte: budget.startDate, $lte: budget.endDate },
    };

    if (budget.category) {
      matchFilter.category = budget.category;
    }

    const results = await transactionRepository.aggregate([
      { $match: matchFilter },
      { $group: { _id: null, total: { $sum: '$amount' } } },
    ]);

    const spent = results.length > 0 ? results[0].total : 0;
    await budgetRepository.update(budget._id, { spent });
  }

  async getAlerts(userId) {
    const overBudget = await budgetRepository.findOverBudget(userId);

    const alerts = [];
    for (const budget of overBudget) {
      const percentage = ((budget.spent / budget.amount) * 100).toFixed(0);
      alerts.push({
        budget,
        percentage: parseInt(percentage, 10),
        overspent: budget.spent - budget.amount,
      });

      await notificationService.createBudgetAlert(userId, budget, percentage);
    }

    return alerts;
  }
}

export default new BudgetService();
