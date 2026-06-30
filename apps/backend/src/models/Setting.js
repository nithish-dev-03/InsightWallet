import mongoose from 'mongoose';

const settingSchema = new mongoose.Schema(
  {
    user: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
      required: true,
      unique: true,
      index: true,
    },
    theme: {
      type: String,
      enum: ['light', 'dark', 'system'],
      default: 'system',
    },
    language: {
      type: String,
      default: 'en',
    },
    currency: {
      type: String,
      default: 'USD',
    },
    notifications: {
      budgetAlerts: { type: Boolean, default: true },
      goalReminders: { type: Boolean, default: true },
      monthlySummary: { type: Boolean, default: true },
      insights: { type: Boolean, default: true },
    },
    privacy: {
      showBalance: { type: Boolean, default: true },
      showTransactions: { type: Boolean, default: true },
    },
    exportFormat: {
      type: String,
      enum: ['csv', 'pdf'],
      default: 'csv',
    },
  },
  {
    timestamps: true,
  }
);

const Setting = mongoose.model('Setting', settingSchema);
export default Setting;
