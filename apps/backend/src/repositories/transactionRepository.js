import BaseRepository from './BaseRepository.js';
import Transaction from '../models/Transaction.js';

class TransactionRepository extends BaseRepository {
  constructor() {
    super(Transaction);
  }

  async findByUser(userId, filter = {}, pagination = {}) {
    return this.findAll({ user: userId, ...filter }, pagination);
  }

  async getSummary(userId, startDate, endDate) {
    return this.aggregate([
      {
        $match: {
          user: userId,
          date: { $gte: startDate, $lte: endDate },
        },
      },
      {
        $group: {
          _id: { type: '$type', category: '$category' },
          totalAmount: { $sum: '$amount' },
          count: { $sum: 1 },
        },
      },
      {
        $group: {
          _id: '$_id.type',
          categories: {
            $push: {
              category: '$_id.category',
              totalAmount: '$totalAmount',
              count: '$count',
            },
          },
          grandTotal: { $sum: '$totalAmount' },
        },
      },
    ]);
  }

  async getMonthlyTotals(userId, year, month) {
    const startOfMonth = new Date(year, month - 1, 1);
    const endOfMonth = new Date(year, month, 0, 23, 59, 59, 999);

    return this.aggregate([
      {
        $match: {
          user: userId,
          date: { $gte: startOfMonth, $lte: endOfMonth },
        },
      },
      {
        $group: {
          _id: '$type',
          total: { $sum: '$amount' },
          count: { $sum: 1 },
        },
      },
    ]);
  }

  async getCategoryTotals(userId, startDate, endDate) {
    return this.aggregate([
      {
        $match: {
          user: userId,
          date: { $gte: startDate, $lte: endDate },
        },
      },
      {
        $group: {
          _id: { category: '$category', type: '$type' },
          total: { $sum: '$amount' },
          count: { $sum: 1 },
        },
      },
      {
        $lookup: {
          from: 'categories',
          localField: '_id.category',
          foreignField: '_id',
          as: 'categoryInfo',
        },
      },
      { $unwind: { path: '$categoryInfo', preserveNullAndEmptyArrays: true } },
      {
        $sort: { total: -1 },
      },
    ]);
  }

  async getTrends(userId, monthsBack = 6) {
    const startDate = new Date();
    startDate.setMonth(startDate.getMonth() - monthsBack);

    return this.aggregate([
      {
        $match: {
          user: userId,
          date: { $gte: startDate },
        },
      },
      {
        $group: {
          _id: {
            year: { $year: '$date' },
            month: { $month: '$date' },
            type: '$type',
          },
          total: { $sum: '$amount' },
          count: { $sum: 1 },
        },
      },
      {
        $sort: { '_id.year': 1, '_id.month': 1 },
      },
    ]);
  }
}

export default new TransactionRepository();
