import BaseRepository from './BaseRepository.js';
import Budget from '../models/Budget.js';

class BudgetRepository extends BaseRepository {
  constructor() {
    super(Budget);
  }

  async findByUser(userId, filter = {}, pagination = {}) {
    return this.findAll({ user: userId, ...filter }, pagination);
  }

  async findActiveBudgets(userId, date = new Date()) {
    return this.model.find({
      user: userId,
      startDate: { $lte: date },
      endDate: { $gte: date },
    });
  }

  async findOverBudget(userId) {
    return this.model.find({
      user: userId,
      $expr: { $gte: ['$spent', '$amount'] },
      notifications: true,
    });
  }
}

export default new BudgetRepository();
