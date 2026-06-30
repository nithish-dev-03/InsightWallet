import BaseRepository from './BaseRepository.js';
import Goal from '../models/Goal.js';

class GoalRepository extends BaseRepository {
  constructor() {
    super(Goal);
  }

  async findByUser(userId, filter = {}, pagination = {}) {
    return this.findAll({ user: userId, ...filter }, pagination);
  }

  async addMilestone(goalId, milestone) {
    return this.model.findByIdAndUpdate(
      goalId,
      { $push: { milestones: milestone } },
      { new: true, runValidators: true }
    );
  }
}

export default new GoalRepository();
