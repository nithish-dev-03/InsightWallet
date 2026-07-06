import mongoose from 'mongoose';
import Transaction from '../models/Transaction.js';
import Category from '../models/Category.js';

// ─── helpers ────────────────────────────────────────────────────────────────

/**
 * Returns the top-level document for a user (creates it if absent).
 * @param {string} userEmail
 */
async function getUserDoc(userEmail) {
  return Transaction.findOneAndUpdate(
    { user_id: userEmail },
    { $setOnInsert: { user_id: userEmail, transactions: [] } },
    { upsert: true, new: true }
  );
}

/**
 * Populate the `category` field of an array of transaction subdocuments.
 * Returns the same array, mutated in-place with category objects.
 */
async function populateCategories(items) {
  const categoryIds = [...new Set(
    items
      .map((t) => t.category?.toString())
      .filter(Boolean)
  )];

  if (categoryIds.length === 0) return items;

  const categories = await Category.find({ _id: { $in: categoryIds } }).lean();
  const catMap = Object.fromEntries(categories.map((c) => [c._id.toString(), c]));

  return items.map((t) => {
    const cat = catMap[t.category?.toString()];
    return {
      ...t.toObject ? t.toObject() : t,
      id: t._id?.toString(),
      category: cat?.name || 'Uncategorized',
      category_icon: cat?.icon || 'help-circle',
      category_color: cat?.color || '#6366f1',
    };
  });
}

// ─── repository ──────────────────────────────────────────────────────────────

class TransactionRepository {
  /**
   * Fetch paginated transactions for a user, with optional filters.
   *
   * @param {string} userEmail
   * @param {object} filter     – mongo-style filter for subdoc fields
   * @param {object} pagination – { page, limit, sort }
   */
  async findByUser(userEmail, filter = {}, { page = 1, limit = 20, sort = { date: -1 } } = {}) {
    // Build $match conditions for subdocuments
    const matchConds = {};
    if (filter.type) matchConds['transactions.type'] = filter.type;
    if (filter.category) matchConds['transactions.category'] = new mongoose.Types.ObjectId(filter.category);
    if (filter.date) {
      matchConds['transactions.date'] = {};
      if (filter.date.$gte) matchConds['transactions.date'].$gte = filter.date.$gte;
      if (filter.date.$lte) matchConds['transactions.date'].$lte = filter.date.$lte;
    }
    if (filter.description) {
      matchConds['transactions.description'] = filter.description;
    }

    // Build $sort stage key (e.g. { date: -1 } → { 'transactions.date': -1 })
    const sortStage = {};
    for (const [k, v] of Object.entries(sort)) {
      sortStage[`transactions.${k}`] = v;
    }

    const skip = (page - 1) * limit;

    const pipeline = [
      { $match: { user_id: userEmail } },
      { $unwind: '$transactions' },
      ...(Object.keys(matchConds).length ? [{ $match: matchConds }] : []),
      {
        $facet: {
          data: [
            { $sort: sortStage },
            { $skip: skip },
            { $limit: limit },
            { $replaceRoot: { newRoot: '$transactions' } },
          ],
          total: [{ $count: 'count' }],
        },
      },
    ];

    const [result] = await Transaction.aggregate(pipeline);
    const rawItems = result?.data || [];
    const total = result?.total?.[0]?.count || 0;

    const data = await populateCategories(rawItems);
    return { data, total, page, limit };
  }

  /**
   * Find a single transaction subdocument by its _id.
   *
   * @param {string} userEmail
   * @param {string} transactionId
   */
  async findOne(userEmail, transactionId) {
    const doc = await Transaction.findOne(
      { user_id: userEmail, 'transactions._id': new mongoose.Types.ObjectId(transactionId) },
      { 'transactions.$': 1 }
    );
    if (!doc || !doc.transactions.length) return null;
    const [item] = await populateCategories(doc.transactions);
    return item;
  }

  /**
   * Push a new transaction subdocument to the user's array.
   *
   * @param {string} userEmail
   * @param {object} data        – fields for the new transaction
   * @returns {object}           – the newly created subdocument (with id)
   */
  async create(userEmail, data) {
    const subdoc = {
      _id: new mongoose.Types.ObjectId(),
      ...data,
    };

    await Transaction.findOneAndUpdate(
      { user_id: userEmail },
      { $push: { transactions: subdoc } },
      { upsert: true }
    );

    const doc = await Transaction.findOne(
      { user_id: userEmail, 'transactions._id': subdoc._id },
      { 'transactions.$': 1 }
    );

    const [item] = await populateCategories(doc.transactions);
    return item;
  }

  /**
   * Bulk-insert multiple transaction subdocuments for a user.
   *
   * @param {string}   userEmail
   * @param {object[]} docsArray
   * @returns {object[]} the inserted subdocuments
   */
  async insertMany(userEmail, docsArray) {
    const subdocs = docsArray.map((d) => ({
      _id: new mongoose.Types.ObjectId(),
      ...d,
    }));

    await Transaction.findOneAndUpdate(
      { user_id: userEmail },
      { $push: { transactions: { $each: subdocs } } },
      { upsert: true }
    );

    return populateCategories(subdocs);
  }

  /**
   * Update fields on an existing transaction subdocument.
   *
   * @param {string} userEmail
   * @param {string} transactionId
   * @param {object} data
   * @returns {object|null}
   */
  async update(userEmail, transactionId, data) {
    const setFields = {};
    for (const [k, v] of Object.entries(data)) {
      setFields[`transactions.$.${k}`] = v;
    }

    const doc = await Transaction.findOneAndUpdate(
      { user_id: userEmail, 'transactions._id': new mongoose.Types.ObjectId(transactionId) },
      { $set: setFields },
      { new: true, arrayFilters: undefined, projection: { 'transactions.$': 1 } }
    );

    if (!doc || !doc.transactions.length) return null;
    const [item] = await populateCategories(doc.transactions);
    return item;
  }

  /**
   * Remove a transaction subdocument from the user's array.
   *
   * @param {string} userEmail
   * @param {string} transactionId
   * @returns {object|null} the removed subdocument (before deletion)
   */
  async delete(userEmail, transactionId) {
    const oid = new mongoose.Types.ObjectId(transactionId);

    // Fetch before deleting so callers can use the data (e.g. budget recalc)
    const before = await this.findOne(userEmail, transactionId);

    await Transaction.findOneAndUpdate(
      { user_id: userEmail },
      { $pull: { transactions: { _id: oid } } }
    );

    return before;
  }

  // ─── aggregation helpers ───────────────────────────────────────────────────

  /**
   * Generic aggregation against the Transaction collection.
   * All pipelines must start by matching user_id and unwinding transactions.
   */
  async aggregate(pipeline) {
    return Transaction.aggregate(pipeline);
  }

  async getSummary(userEmail, startDate, endDate) {
    return Transaction.aggregate([
      { $match: { user_id: userEmail } },
      { $unwind: '$transactions' },
      {
        $match: {
          'transactions.date': { $gte: startDate, $lte: endDate },
        },
      },
      {
        $group: {
          _id: { type: '$transactions.type', category: '$transactions.category' },
          totalAmount: { $sum: '$transactions.amount' },
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

  async getMonthlyTotals(userEmail, year, month) {
    const startOfMonth = new Date(year, month - 1, 1);
    const endOfMonth = new Date(year, month, 0, 23, 59, 59, 999);

    return Transaction.aggregate([
      { $match: { user_id: userEmail } },
      { $unwind: '$transactions' },
      {
        $match: {
          'transactions.date': { $gte: startOfMonth, $lte: endOfMonth },
        },
      },
      {
        $group: {
          _id: '$transactions.type',
          total: { $sum: '$transactions.amount' },
          count: { $sum: 1 },
        },
      },
    ]);
  }

  async getCategoryTotals(userEmail, startDate, endDate) {
    return Transaction.aggregate([
      { $match: { user_id: userEmail } },
      { $unwind: '$transactions' },
      {
        $match: {
          'transactions.date': { $gte: startDate, $lte: endDate },
        },
      },
      {
        $group: {
          _id: { category: '$transactions.category', type: '$transactions.type' },
          total: { $sum: '$transactions.amount' },
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
      { $sort: { total: -1 } },
    ]);
  }

  async getTrends(userEmail, monthsBack = 6) {
    const startDate = new Date();
    startDate.setMonth(startDate.getMonth() - monthsBack);

    return Transaction.aggregate([
      { $match: { user_id: userEmail } },
      { $unwind: '$transactions' },
      {
        $match: {
          'transactions.date': { $gte: startDate },
        },
      },
      {
        $group: {
          _id: {
            year: { $year: '$transactions.date' },
            month: { $month: '$transactions.date' },
            type: '$transactions.type',
          },
          total: { $sum: '$transactions.amount' },
          count: { $sum: 1 },
        },
      },
      { $sort: { '_id.year': 1, '_id.month': 1 } },
    ]);
  }

  /**
   * Aggregate expenses by user + filter for budget recalculation.
   * Used by budgetService._recalcSingleBudget.
   *
   * @param {string} userEmail
   * @param {Date}   startDate
   * @param {Date}   endDate
   * @param {string|null} categoryId   ObjectId string or null for all categories
   */
  async sumExpenses(userEmail, startDate, endDate, categoryId = null) {
    const matchConds = {
      'transactions.type': 'expense',
      'transactions.date': { $gte: startDate, $lte: endDate },
    };
    if (categoryId) {
      matchConds['transactions.category'] = new mongoose.Types.ObjectId(categoryId);
    }

    const results = await Transaction.aggregate([
      { $match: { user_id: userEmail } },
      { $unwind: '$transactions' },
      { $match: matchConds },
      { $group: { _id: null, total: { $sum: '$transactions.amount' } } },
    ]);

    return results.length > 0 ? results[0].total : 0;
  }
}

export default new TransactionRepository();
