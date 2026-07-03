import mongoose from 'mongoose';
import env from './env.js';

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
