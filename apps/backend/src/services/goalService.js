import goalRepository from '../repositories/goalRepository.js';

class GoalService {
  async getGoals(userId, queryParams) {
    const { page = 1, limit = 20, status } = queryParams;
    const filter = {};
    if (status) filter.status = status;

    return goalRepository.findByUser(userId, filter, {
      page: parseInt(page, 10),
      limit: parseInt(limit, 10),
    });
  }

  async getGoal(goalId, userId) {
    const goal = await goalRepository.findOne({ _id: goalId, user: userId });
    if (!goal) {
      const error = new Error('Goal not found.');
      error.statusCode = 404;
      throw error;
    }
    return goal;
  }

  async createGoal(userId, data) {
    return goalRepository.create({ ...data, user: userId });
  }

  async updateGoal(goalId, userId, data) {
    const goal = await goalRepository.findOne({ _id: goalId, user: userId });
    if (!goal) {
      const error = new Error('Goal not found.');
      error.statusCode = 404;
      throw error;
    }

    if (data.currentAmount !== undefined && data.currentAmount >= goal.targetAmount) {
      data.status = 'completed';
    }

    const updated = await goalRepository.update(goalId, data);
    return updated;
  }

  async deleteGoal(goalId, userId) {
    const goal = await goalRepository.findOne({ _id: goalId, user: userId });
    if (!goal) {
      const error = new Error('Goal not found.');
      error.statusCode = 404;
      throw error;
    }
    await goalRepository.delete(goalId);
  }

  async addMilestone(goalId, userId, milestoneData) {
    const goal = await goalRepository.findOne({ _id: goalId, user: userId });
    if (!goal) {
      const error = new Error('Goal not found.');
      error.statusCode = 404;
      throw error;
    }

    return goalRepository.addMilestone(goalId, milestoneData);
  }

  calculateProgress(currentAmount, targetAmount) {
    if (targetAmount === 0) return 0;
    return Math.min((currentAmount / targetAmount) * 100, 100);
  }
}

export default new GoalService();
