import userRepository from '../repositories/userRepository.js';
import transactionRepository from '../repositories/transactionRepository.js';
import cloudinaryService from './cloudinaryService.js';
import env from '../config/env.js';

class ProfileService {
  async getProfile(userId) {
    const user = await userRepository.findById(userId);
    if (!user) {
      const error = new Error('User not found.');
      error.statusCode = 404;
      throw error;
    }
    return user;
  }

  async getProfileByEmail(email) {
    return await userRepository.findByEmail(email);
  }

  async createProfile(userId, email, data) {
    const existing = await userRepository.findById(userId);
    if (existing) {
      const error = new Error('Profile already exists.');
      error.statusCode = 400;
      throw error;
    }

    const user = await userRepository.create({
      _id: userId,
      email: email,
      name: data.name,
      title: data.title || '',
      bio: data.bio || '',
      location: data.location || '',
      currency: data.currency || 'USD',
      theme: data.theme || 'system',
      avatar: data.avatar || { url: '', publicId: '' },
    });

    return user;
  }

  async updateProfile(userId, data) {
    const allowedFields = ['name', 'currency', 'theme', 'biometricEnabled', 'title', 'bio', 'location'];
    const updates = {};
    for (const field of allowedFields) {
      if (data[field] !== undefined) {
        updates[field] = data[field];
      }
    }
    const user = await userRepository.update(userId, updates);
    if (!user) {
      const error = new Error('User not found.');
      error.statusCode = 404;
      throw error;
    }
    return user;
  }

  async updateAvatar(userId, file) {
    if (!file) {
      const error = new Error('No image file provided.');
      error.statusCode = 400;
      throw error;
    }

    const user = await userRepository.findById(userId);
    if (!user) {
      const error = new Error('User not found.');
      error.statusCode = 404;
      throw error;
    }

    if (user.avatar?.publicId) {
      await cloudinaryService.deleteImage(user.avatar.publicId);
    }

    const result = await cloudinaryService.uploadImage(file.buffer, {
      folder: 'insightwallet/avatars',
      width: 200,
      height: 200,
      crop: 'fill',
    });

    const updated = await userRepository.update(userId, {
      avatar: { url: result.secure_url, publicId: result.public_id },
    });

    return updated;
  }

  async getStatistics(userId) {
    const now = new Date();
    const startOfMonth = new Date(now.getFullYear(), now.getMonth(), 1);
    const endOfMonth = new Date(now.getFullYear(), now.getMonth() + 1, 0, 23, 59, 59, 999);
    const startOfYear = new Date(now.getFullYear(), 0, 1);
    const endOfYear = new Date(now.getFullYear(), 11, 31, 23, 59, 59, 999);

    const [monthlyTotals, yearlyTotals, totalTransactions, totalExpenses] =
      await Promise.all([
        transactionRepository.getMonthlyTotals(
          userId,
          now.getFullYear(),
          now.getMonth() + 1
        ),
        transactionRepository.aggregate([
          {
            $match: {
              user: userId,
              date: { $gte: startOfYear, $lte: endOfYear },
            },
          },
          {
            $group: {
              _id: '$type',
              total: { $sum: '$amount' },
            },
          },
        ]),
        transactionRepository.count({ user: userId }),
        transactionRepository.aggregate([
          {
            $match: {
              user: userId,
              type: 'expense',
            },
          },
          {
            $group: {
              _id: null,
              total: { $sum: '$amount' },
            },
          },
        ]),
      ]);

    const monthlyIncome = monthlyTotals.find((t) => t._id === 'income')?.total || 0;
    const monthlyExpense = monthlyTotals.find((t) => t._id === 'expense')?.total || 0;
    const yearlyIncome = yearlyTotals.find((t) => t._id === 'income')?.total || 0;
    const yearlyExpense = yearlyTotals.find((t) => t._id === 'expense')?.total || 0;

    return {
      currentMonth: {
        income: monthlyIncome,
        expense: monthlyExpense,
        net: monthlyIncome - monthlyExpense,
      },
      currentYear: {
        income: yearlyIncome,
        expense: yearlyExpense,
        net: yearlyIncome - yearlyExpense,
      },
      lifetime: {
        totalTransactions,
        totalExpenses: totalExpenses.length > 0 ? totalExpenses[0].total : 0,
      },
    };
  }
}

export default new ProfileService();
