import mongoose from 'mongoose';

const budgetSchema = new mongoose.Schema(
  {
    user: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
      required: true,
    },
    category: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Category',
      default: null,
    },
    amount: {
      type: Number,
      required: [true, 'Budget amount is required'],
      min: [0, 'Amount must be positive'],
    },
    spent: {
      type: Number,
      default: 0,
    },
    period: {
      type: String,
      enum: ['weekly', 'monthly', 'yearly'],
      required: [true, 'Budget period is required'],
    },
    startDate: {
      type: Date,
      required: [true, 'Start date is required'],
    },
    endDate: {
      type: Date,
      required: [true, 'End date is required'],
    },
    notifications: {
      type: Boolean,
      default: true,
    },
  },
  {
    timestamps: true,
  }
);

budgetSchema.index({ user: 1, category: 1, period: 1 });

const Budget = mongoose.model('Budget', budgetSchema);
export default Budget;
