import insightRepository from '../repositories/insightRepository.js';
import transactionRepository from '../repositories/transactionRepository.js';
import transactionService from './transactionService.js';

class InsightService {
  async generateMonthlySummary(userId, month, year) {
    const existing = await insightRepository.findMonthlySummary(userId, month, year);
    if (existing) return existing;

    const totals = await transactionService.getMonthlyTotals(userId, year, month);
    const incomeTotal = totals.find((t) => t._id === 'income')?.total || 0;
    const expenseTotal = totals.find((t) => t._id === 'expense')?.total || 0;

    const startOfMonth = new Date(year, month - 1, 1);
    const endOfMonth = new Date(year, month, 0, 23, 59, 59, 999);
    const categoryData = await transactionService.getCategoryTotals(
      userId,
      startOfMonth,
      endOfMonth
    );

    const previousMonth = month === 1 ? 12 : month - 1;
    const previousYear = month === 1 ? year - 1 : year;
    const prevTotals = await transactionService.getMonthlyTotals(
      userId,
      previousYear,
      previousMonth
    );
    const prevExpense = prevTotals.find((t) => t._id === 'expense')?.total || 0;
    const expenseChange = prevExpense > 0
      ? ((expenseTotal - prevExpense) / prevExpense) * 100
      : 0;

    const insight = await insightRepository.create({
      user: userId,
      type: 'monthly_summary',
      title: `Monthly Summary - ${month}/${year}`,
      description: `You spent ${expenseTotal.toFixed(2)} and earned ${incomeTotal.toFixed(2)} this month.`,
      data: {
        income: incomeTotal,
        expense: expenseTotal,
        net: incomeTotal - expenseTotal,
        expenseChange: Math.round(expenseChange * 100) / 100,
        topCategories: categoryData.slice(0, 5),
      },
      month,
      year,
      generatedAt: new Date(),
    });

    return insight;
  }

  async generateSpendingPrediction(userId) {
    const trends = await transactionService.getTrends(userId, 6);

    const expenseTrends = trends.filter((t) => t._id.type === 'expense');
    const avgExpense =
      expenseTrends.length > 0
        ? expenseTrends.reduce((sum, t) => sum + t.total, 0) / expenseTrends.length
        : 0;

    const insight = await insightRepository.create({
      user: userId,
      type: 'spending_prediction',
      title: 'Spending Prediction',
      description: `Based on your ${Math.min(expenseTrends.length, 6)}-month history, your predicted monthly spending is ${avgExpense.toFixed(2)}.`,
      data: {
        predictedMonthlySpending: Math.round(avgExpense * 100) / 100,
        monthsAnalyzed: expenseTrends.length,
        trend: expenseTrends,
      },
      generatedAt: new Date(),
    });

    return insight;
  }

  async generateBudgetSuggestions(userId) {
    const now = new Date();
    const startOfMonth = new Date(now.getFullYear(), now.getMonth(), 1);
    const endOfMonth = new Date(now.getFullYear(), now.getMonth() + 1, 0, 23, 59, 59, 999);

    const categoryData = await transactionService.getCategoryTotals(
      userId,
      startOfMonth,
      endOfMonth
    );

    const expenseCategories = categoryData.filter((c) => c._id.type === 'expense');
    const suggestions = expenseCategories.map((c) => ({
      category: c.categoryInfo?.name || 'Unknown',
      categoryId: c._id.category,
      currentSpending: c.total,
      suggestedBudget: Math.round(c.total * 1.1),
    }));

    const totalExpense = expenseCategories.reduce((sum, c) => sum + c.total, 0);

    const insight = await insightRepository.create({
      user: userId,
      type: 'budget_suggestion',
      title: 'Budget Suggestions',
      description: `Based on your ${now.toLocaleString('default', { month: 'long' })} spending, here are suggested budget limits.`,
      data: {
        suggestions,
        totalExpense,
        month: now.getMonth() + 1,
        year: now.getFullYear(),
      },
      generatedAt: new Date(),
    });

    return insight;
  }

  async generateExpenseTrends(userId) {
    const trends = await transactionService.getTrends(userId, 6);

    const formattedTrends = trends
      .filter((t) => t._id.type === 'expense')
      .map((t) => ({
        month: t._id.month,
        year: t._id.year,
        total: t.total,
        count: t.count,
        label: `${t._id.month}/${t._id.year}`,
      }))
      .sort((a, b) => a.year - b.year || a.month - b.month);

    const insight = await insightRepository.create({
      user: userId,
      type: 'expense_trend',
      title: 'Expense Trends (6 Months)',
      description: 'Your expense trends over the last 6 months.',
      data: {
        trends: formattedTrends,
        averageMonthlyExpense:
          formattedTrends.length > 0
            ? Math.round(
                formattedTrends.reduce((s, t) => s + t.total, 0) /
                  formattedTrends.length *
                  100
              ) / 100
            : 0,
      },
      generatedAt: new Date(),
    });

    return insight;
  }
}

export default new InsightService();
