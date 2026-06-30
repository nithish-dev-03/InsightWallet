import mongoose from 'mongoose';

const insightSchema = new mongoose.Schema(
  {
    user: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
      required: true,
      index: true,
    },
    type: {
      type: String,
      enum: [
        'monthly_summary',
        'spending_prediction',
        'budget_suggestion',
        'expense_trend',
      ],
      required: [true, 'Insight type is required'],
    },
    title: {
      type: String,
      required: [true, 'Title is required'],
      trim: true,
    },
    description: {
      type: String,
      required: [true, 'Description is required'],
      trim: true,
    },
    data: {
      type: mongoose.Schema.Types.Mixed,
    },
    month: {
      type: Number,
      min: 1,
      max: 12,
    },
    year: {
      type: Number,
    },
    generatedAt: {
      type: Date,
      default: Date.now,
    },
  },
  {
    timestamps: true,
  }
);

const Insight = mongoose.model('Insight', insightSchema);
export default Insight;
