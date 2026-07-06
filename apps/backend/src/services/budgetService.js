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

  async createBudget(userId, userEmail, data) {
    const budget = await budgetRepository.create({ ...data, user: userId });
    await this.recalculateSpent(userEmail, userId, budget.startDate, budget);
    return budget;
  }

  async updateBudget(budgetId, userId, userEmail, data) {
    const budget = await budgetRepository.findOne({ _id: budgetId, user: userId });
    if (!budget) {
      const error = new Error('Budget not found.');
      error.statusCode = 404;
      throw error;
    }
    const updated = await budgetRepository.update(budgetId, data);
    await this.recalculateSpent(userEmail, userId, updated.startDate, updated);
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

  /**
   * @param {string} userEmail  – key for the transaction doc
   * @param {string} userId     – ObjectId, for querying budgets
   * @param {Date}   date
   * @param {object|null} budgetOverride
   */
  async recalculateSpent(userEmail, userId, date, budgetOverride = null) {
    if (budgetOverride) {
      await this._recalcSingleBudget(userEmail, budgetOverride);
      return;
    }

    const budgets = await budgetRepository.findActiveBudgets(userId, date);
    for (const budget of budgets) {
      await this._recalcSingleBudget(userEmail, budget);
    }
  }

  async _recalcSingleBudget(userEmail, budget) {
    const categoryId = budget.category ? budget.category.toString() : null;
    const spent = await transactionRepository.sumExpenses(
      userEmail,
      budget.startDate,
      budget.endDate,
      categoryId
    );
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
