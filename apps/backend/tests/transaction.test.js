import { jest } from '@jest/globals';

// 1. Register mock for auth middleware in ESM mode
jest.unstable_mockModule('../src/middlewares/auth.js', () => {
  return {
    __esModule: true,
    default: (req, res, next) => {
      req.userId = '65b8e9a1b14f828a2cd53489';
      req.user = { _id: '65b8e9a1b14f828a2cd53489', email: 'test@example.com' };
      next();
    }
  };
});

// 2. Mock budgetService to avoid DB dependencies during test run
jest.unstable_mockModule('../src/services/budgetService.js', () => {
  return {
    __esModule: true,
    default: {
      recalculateSpent: jest.fn().mockResolvedValue(true)
    }
  };
});

// 3. Dynamically import other modules
const request = (await import('supertest')).default;
const app = (await import('../src/app.js')).default;
const Transaction = (await import('../src/models/Transaction.js')).default;
const budgetService = (await import('../src/services/budgetService.js')).default;

describe('Transaction Controller - Bulk Operations', () => {
  beforeEach(() => {
    jest.clearAllMocks();
  });

  test('POST /api/v1/transactions/bulk returns 400 if transactions array is not provided or empty', async () => {
    const res1 = await request(app)
      .post('/api/v1/transactions/bulk')
      .send({});
    
    expect(res1.statusCode).toBe(400);
    expect(res1.body.success).toBe(false);
    expect(res1.body.message).toContain('transactions array is required');

    const res2 = await request(app)
      .post('/api/v1/transactions/bulk')
      .send({ transactions: [] });

    expect(res2.statusCode).toBe(400);
    expect(res2.body.success).toBe(false);
  });

  test('POST /api/v1/transactions/bulk successfully inserts multiple transactions and recalculates budget spent', async () => {
    // Mock Transaction.insertMany
    const mockCreatedTransactions = [
      {
        _id: '65b8e9a1b14f828a2cd53491',
        amount: 100,
        type: 'income',
        description: 'Salary',
        date: new Date('2026-07-01T00:00:00.000Z'),
        user: '65b8e9a1b14f828a2cd53489'
      },
      {
        _id: '65b8e9a1b14f828a2cd53492',
        amount: 20,
        type: 'expense',
        description: 'Coffee',
        date: new Date('2026-07-02T00:00:00.000Z'),
        user: '65b8e9a1b14f828a2cd53489'
      }
    ];

    const insertSpy = jest.spyOn(Transaction, 'insertMany').mockResolvedValue(mockCreatedTransactions);

    const payload = {
      transactions: [
        {
          amount: 100,
          type: 'income',
          description: 'Salary',
          date: '2026-07-01T00:00:00.000Z'
        },
        {
          amount: 20,
          type: 'expense',
          description: 'Coffee',
          date: '2026-07-02T00:00:00.000Z'
        }
      ]
    };

    const res = await request(app)
      .post('/api/v1/transactions/bulk')
      .send(payload);

    expect(res.statusCode).toBe(201);
    expect(res.body.success).toBe(true);
    expect(res.body.message).toBe('Transactions bulk created.');
    expect(res.body.data).toHaveLength(2);

    expect(insertSpy).toHaveBeenCalledTimes(1);
    // Budget service should be called to recalculate spent for unique dates
    expect(budgetService.recalculateSpent).toHaveBeenCalledTimes(2);

    insertSpy.mockRestore();
  });
});
