import mongoose from 'mongoose';
import env from './env.js';
import Category from '../models/Category.js';

// Global plugin to ensure all schemas include virtual 'id' mapping when serialized to JSON
mongoose.plugin((schema) => {
  schema.set('toJSON', {
    virtuals: true,
    versionKey: false,
    transform: (doc, ret) => {
      if (ret._id) {
        ret.id = ret._id.toString();
      }
      return ret;
    },
  });
});

const defaultCategories = [
  { name: 'Food', type: 'expense', icon: 'restaurant', color: '#ef4444', isDefault: true, sortOrder: 1 },
  { name: 'Transport', type: 'expense', icon: 'directions_car', color: '#3b82f6', isDefault: true, sortOrder: 2 },
  { name: 'Shopping', type: 'expense', icon: 'shopping_bag', color: '#ec4899', isDefault: true, sortOrder: 3 },
  { name: 'Entertainment', type: 'expense', icon: 'movie', color: '#f59e0b', isDefault: true, sortOrder: 4 },
  { name: 'Bills', type: 'expense', icon: 'receipt_long', color: '#8b5cf6', isDefault: true, sortOrder: 5 },
  { name: 'Salary', type: 'income', icon: 'work', color: '#10b981', isDefault: true, sortOrder: 6 },
  { name: 'Freelance', type: 'income', icon: 'code', color: '#14b8a6', isDefault: true, sortOrder: 7 },
  { name: 'Investment', type: 'income', icon: 'trending_up', color: '#f59e0b', isDefault: true, sortOrder: 8 },
  { name: 'Health', type: 'expense', icon: 'favorite', color: '#ec4899', isDefault: true, sortOrder: 9 },
  { name: 'Education', type: 'expense', icon: 'school', color: '#3b82f6', isDefault: true, sortOrder: 10 },
  { name: 'Credit', type: 'income', icon: 'credit_card', color: '#10b981', isDefault: true, sortOrder: 11 },
];

const seedDefaultCategories = async () => {
  try {
    const count = await Category.countDocuments({ isDefault: true });
    if (count === 0) {
      console.log('Seeding default categories...');
      await Category.insertMany(defaultCategories);
      console.log('Default categories seeded successfully.');
    }
  } catch (error) {
    console.error('Error seeding default categories:', error.message);
  }
};

const connectDatabase = async () => {
  const maxRetries = 5;
  let retries = 0;

  while (retries < maxRetries) {
    try {
      await mongoose.connect(env.mongodbUri, {
        dbName: env.dbName,
        maxPoolSize: 10,
        serverSelectionTimeoutMS: 5000,
        socketTimeoutMS: 45000,
      });
      console.log(`MongoDB connected: ${mongoose.connection.host}`);
      await seedDefaultCategories();
      return;
    } catch (error) {
      retries += 1;
      console.error(`MongoDB connection attempt ${retries}/${maxRetries} failed: ${error.message}`);
      if (retries >= maxRetries) {
        console.error('Max retries reached. Exiting.');
        process.exit(1);
      }
      await new Promise((resolve) => setTimeout(resolve, 3000));
    }
  }
};

mongoose.connection.on('disconnected', () => {
  console.warn('MongoDB disconnected. Attempting to reconnect...');
});

mongoose.connection.on('error', (err) => {
  console.error('MongoDB connection error:', err.message);
});

export default connectDatabase;
