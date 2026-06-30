import BaseRepository from './BaseRepository.js';
import Insight from '../models/Insight.js';

class InsightRepository extends BaseRepository {
  constructor() {
    super(Insight);
  }

  async findByUser(userId, filter = {}, pagination = {}) {
    return this.findAll({ user: userId, ...filter }, pagination);
  }

  async findByUserAndType(userId, type) {
    return this.model
      .find({ user: userId, type })
      .sort({ generatedAt: -1 })
      .limit(10);
  }

  async findMonthlySummary(userId, month, year) {
    return this.model.findOne({
      user: userId,
      type: 'monthly_summary',
      month,
      year,
    });
  }
}

export default new InsightRepository();
