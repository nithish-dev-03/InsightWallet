import mongoose from 'mongoose';

// ── Sub-document schema for a single transaction entry ──────────────────────
const txItemSchema = new mongoose.Schema(
  {
    type: {
      type: String,
      enum: ['income', 'expense'],
      required: [true, 'Transaction type is required'],
    },
    amount: {
      type: Number,
      required: [true, 'Amount is required'],
      min: [0, 'Amount must be positive'],
    },
    category: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Category',
    },
    description: {
      type: String,
      trim: true,
      maxlength: 200,
    },
    date: {
      type: Date,
      default: Date.now,
    },
    tags: [{ type: String, trim: true }],
    receipt: {
      url: { type: String, default: '' },
      publicId: { type: String, default: '' },
    },
    isRecurring: {
      type: Boolean,
      default: false,
    },
    recurringInterval: {
      type: String,
      enum: ['daily', 'weekly', 'monthly', 'yearly'],
    },
    note: {
      type: String,
      trim: true,
      maxlength: 500,
    },
  },
  {
    timestamps: true,
    // Expose virtual `id` on sub-documents
    toJSON: {
      virtuals: true,
      transform: (doc, ret) => {
        ret.id = ret._id.toString();
        delete ret.__v;
        return ret;
      },
    },
  }
);

// ── Top-level schema: one document per user ──────────────────────────────────
const userTransactionSchema = new mongoose.Schema(
  {
    user_id: {
      type: String, // user email
      required: true,
      unique: true,
      index: true,
      lowercase: true,
      trim: true,
    },
    transactions: [txItemSchema],
  },
  {
    timestamps: true,
  }
);

const Transaction = mongoose.model('Transaction', userTransactionSchema);
export default Transaction;

// ── StatementImport (unchanged) ───────────────────────────────────────────────
const statementImportSchema = new mongoose.Schema(
  {
    _id: {
      type: String, // user email as id
      required: true,
    },
    date_start: {
      type: String,
      required: true,
    },
    date_end: {
      type: String,
      required: true,
    },
    name: {
      type: String,
      required: true,
    },
  },
  {
    timestamps: true,
  }
);

export const StatementImport = mongoose.model('StatementImport', statementImportSchema);
