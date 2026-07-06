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

// 2. Dynamically import other modules to ensure the mock is resolved first
const request = (await import('supertest')).default;
const app = (await import('../src/app.js')).default;
const { parseAmount, normalizeDate, determineTransactionType, extractStatementYear } = await import('../src/utils/regexParser.js');
const { ChaseStrategy } = await import('../src/services/parserStrategies/chaseStrategy.js');
const { WellsFargoStrategy } = await import('../src/services/parserStrategies/wellsFargoStrategy.js');
const { GenericStrategy } = await import('../src/services/parserStrategies/genericStrategy.js');
const { TMBStrategy } = await import('../src/services/parserStrategies/tmbStrategy.js');
const pdfDecryptService = (await import('../src/services/pdfDecryptService.js')).default;
const { StatementImport } = await import('../src/models/Transaction.js');

describe('Bank Statement Import - Regex Parser Utility', () => {
  test('parseAmount parses different currency and sign formats', () => {
    expect(parseAmount('$123.45')).toBe(123.45);
    expect(parseAmount('-$123.45')).toBe(-123.45);
    expect(parseAmount('1,234.56')).toBe(1234.56);
    expect(parseAmount('-1,234.56')).toBe(-1234.56);
    expect(parseAmount('45.00-')).toBe(-45.00);
    expect(parseAmount('100.00 DR')).toBe(-100.00);
    expect(parseAmount('200.00 CR')).toBe(200.00);
  });

  test('extractStatementYear extracts correct 4-digit years', () => {
    const text = 'Statement period: Jan 01, 2025 to Dec 31, 2025. Printed in 2026.';
    expect(extractStatementYear(text)).toBe(2025);
    expect(extractStatementYear('No years here')).toBe(new Date().getFullYear());
  });

  test('normalizeDate normalizes various date formats to YYYY-MM-DD', () => {
    expect(normalizeDate('10/24', 2026)).toBe('2026-10-24');
    expect(normalizeDate('10/24/2025', 2026)).toBe('2025-10-24');
    expect(normalizeDate('10/24/25', 2026)).toBe('2025-10-24');
    expect(normalizeDate('Oct 24', 2026)).toBe('2026-10-24');
    expect(normalizeDate('October 24, 2025', 2026)).toBe('2025-10-24');
    expect(normalizeDate('2026-10-24', 2026)).toBe('2026-10-24');
  });

  test('determineTransactionType classifies income and expenses correctly', () => {
    expect(determineTransactionType(100, 'Direct Deposit Payroll')).toBe('income');
    expect(determineTransactionType(-50, 'Direct Deposit Payroll')).toBe('income');
    expect(determineTransactionType(50, 'ATM Withdrawal Fee')).toBe('expense');
    expect(determineTransactionType(25.50, 'STARBUCKS')).toBe('income');
    expect(determineTransactionType(-25.50, 'STARBUCKS')).toBe('expense');
  });
});

describe('Bank Statement Import - Parser Strategies', () => {
  test('ChaseStrategy parses double-date and single-date Chase formats', () => {
    const strategy = new ChaseStrategy();
    const mockText = `
      10/24 10/25 STARBUCKS COFFEE -15.45
      10/25 10/26 DIRECT DEPOSIT PAYROLL +1500.00
      10/26 TARGET STORES -84.50
    `;
    const txns = strategy.parse(mockText, 2026);
    expect(txns).toHaveLength(3);
    
    expect(txns[0]).toEqual({
      date: '2026-10-24',
      description: 'STARBUCKS COFFEE',
      amount: 15.45,
      type: 'expense',
      reference: 'Chase CC Post:10/25'
    });
    
    expect(txns[1]).toEqual({
      date: '2026-10-25',
      description: 'DIRECT DEPOSIT PAYROLL',
      amount: 1500.00,
      type: 'income',
      reference: 'Chase CC Post:10/26'
    });

    expect(txns[2]).toEqual({
      date: '2026-10-26',
      description: 'TARGET STORES',
      amount: 84.50,
      type: 'expense',
      reference: 'Chase Statement'
    });
  });

  test('WellsFargoStrategy parses Wells Fargo slash and word formats', () => {
    const strategy = new WellsFargoStrategy();
    const mockText = `
      10/24 Wells Fargo Online Transfer -50.00
      Oct 25 TARGET SUPERSTORE -120.50
      October 26 ATM CASH DEPOSIT 300.00
    `;
    const txns = strategy.parse(mockText, 2026);
    expect(txns).toHaveLength(3);
    
    expect(txns[0].date).toBe('2026-10-24');
    expect(txns[0].description).toBe('Wells Fargo Online Transfer');
    expect(txns[0].amount).toBe(50.00);
    
    expect(txns[1].date).toBe('2026-10-25');
    expect(txns[1].description).toBe('TARGET SUPERSTORE');
    expect(txns[1].amount).toBe(120.50);
    
    expect(txns[2].date).toBe('2026-10-26');
    expect(txns[2].description).toBe('ATM CASH DEPOSIT');
    expect(txns[2].amount).toBe(300.00);
    expect(txns[2].type).toBe('income');
  });

  test('GenericStrategy parses other formats as fallback', () => {
    const strategy = new GenericStrategy();
    const mockText = `
      2026-10-24 AMZN Digital Purchase -14.99
      10/25/2026 GYM MEMBERSHIP DUES -45.00
      Oct 26 REFUND RECEIVED 25.00
    `;
    const txns = strategy.parse(mockText, 2026);
    expect(txns).toHaveLength(3);
    
    expect(txns[0].date).toBe('2026-10-24');
    expect(txns[0].amount).toBe(14.99);
    
    expect(txns[1].date).toBe('2026-10-25');
    expect(txns[1].amount).toBe(45.00);
    
    expect(txns[2].date).toBe('2026-10-26');
    expect(txns[2].amount).toBe(25.00);
    expect(txns[2].type).toBe('income');
  });

  test('TMBStrategy parses TMB space-separated flat formats correctly', () => {
    const strategy = new TMBStrategy();
    const mockText = `
      Name Address Mobile No. R00030295 NIRMAL SING NITHISH N DOOR NO 4/166 KIRUBAPURAM
      TMBL0000243
      Opening Balance   49,709.87
      01-01-2026 UPI/236422130016/Google/UTIB/AUTO PAY 119   49590.87
      02-01-2026 UPI/955815761652/PREMKUMAR RAVIC/TMBL/Payment from 50   49540.87
      03-01-2026 Jan2026salary   19035   68575.87
    `;
    const result = strategy.parse(mockText, 2026);
    const txns = result.transactions;
    expect(txns).toHaveLength(3);

    expect(txns[0]).toEqual({
      date: '2026-01-01',
      description: 'UPI/236422130016/Google/UTIB/AUTO PAY',
      amount: 119,
      type: 'expense',
      reference: 'UPI Ref: 236422130016',
      sender: 'NIRMAL SING NITHISH N',
      receiver: 'Google',
      available_balance: 49590.87
    });

    expect(txns[1]).toEqual({
      date: '2026-01-02',
      description: 'UPI/955815761652/PREMKUMAR RAVIC/TMBL/Payment from',
      amount: 50,
      type: 'expense',
      reference: 'UPI Ref: 955815761652',
      sender: 'NIRMAL SING NITHISH N',
      receiver: 'PREMKUMAR RAVIC',
      available_balance: 49540.87
    });

    expect(txns[2]).toEqual({
      date: '2026-01-03',
      description: 'Jan2026salary',
      amount: 19035,
      type: 'income',
      reference: 'TMB Statement',
      sender: 'Employer / Salary',
      receiver: 'NIRMAL SING NITHISH N',
      available_balance: 68575.87
    });
  });
});

describe('Bank Statement Import - Controller & Endpoints', () => {
  let decryptSpy;
  let saveSpy;

  beforeEach(() => {
    decryptSpy = jest.spyOn(pdfDecryptService, 'decryptAndExtractText');
    saveSpy = jest.spyOn(StatementImport, 'findByIdAndUpdate').mockImplementation((email, update, options) => {
      return Promise.resolve({
        _id: email,
        ...update
      });
    });
  });

  afterEach(() => {
    decryptSpy.mockRestore();
    saveSpy.mockRestore();
  });

  test('POST /api/v1/statements/import returns 400 if validation fails', async () => {
    const res1 = await request(app)
      .post('/api/v1/statements/import')
      .send({ password: '123' });
    expect(res1.status).toBe(400);
    expect(res1.body.success).toBe(false);

    const res2 = await request(app)
      .post('/api/v1/statements/import')
      .attach('pdf', Buffer.from('%PDF-1.4...'), { filename: 'test.pdf', contentType: 'application/pdf' });
    expect(res2.status).toBe(400);
    expect(res2.body.success).toBe(false);

    const res3 = await request(app)
      .post('/api/v1/statements/import')
      .attach('pdf', Buffer.from('hello'), { filename: 'test.txt', contentType: 'text/plain' })
      .field('password', '123');
    expect(res3.status).toBe(400);
    expect(res3.body.success).toBe(false);
  });

  test('POST /api/v1/statements/import returns 400 on incorrect password', async () => {
    decryptSpy.mockRejectedValue(new Error('Invalid PDF password'));

    const res = await request(app)
      .post('/api/v1/statements/import')
      .attach('pdf', Buffer.from('%PDF-1.4...'), { filename: 'test.pdf', contentType: 'application/pdf' })
      .field('password', 'wrongpassword');

    expect(res.status).toBe(400);
    expect(res.body.success).toBe(false);
    expect(res.body.message).toBe('Invalid PDF password');
  });

  test('POST /api/v1/statements/import successfully parses statement', async () => {
    const mockText = 'CHASE BANK\n10/24 STARBUCKS COFFEE -15.45\n10/25 DIRECT DEPOSIT +1500.00';
    decryptSpy.mockResolvedValue(mockText);

    const res = await request(app)
      .post('/api/v1/statements/import')
      .attach('pdf', Buffer.from('%PDF-1.4...'), { filename: 'test.pdf', contentType: 'application/pdf' })
      .field('password', 'correctpassword');

    expect(res.status).toBe(200);
    expect(res.body.success).toBe(true);
    expect(res.body.message).toBe('Statement parsed successfully.');
    expect(res.body.data.bank).toBe('Chase');
    expect(res.body.data.transactions).toHaveLength(2);
    expect(res.body.data.transactions[0].description).toBe('STARBUCKS COFFEE');
    expect(res.body.data.transactions[0].amount).toBe(15.45);
    expect(res.body.data.transactions[1].description).toBe('DIRECT DEPOSIT');
    expect(res.body.data.transactions[1].amount).toBe(1500.00);
    expect(res.body.data.transactions[1].type).toBe('income');
  });

  test('POST /api/v1/statements/save-import returns 400 if validation fails', async () => {
    const res = await request(app)
      .post('/api/v1/statements/save-import')
      .send({ date_start: '2026-01-01' });
    expect(res.status).toBe(400);
    expect(res.body.success).toBe(false);
  });

  test('POST /api/v1/statements/save-import successfully saves statement import details', async () => {
    const res = await request(app)
      .post('/api/v1/statements/save-import')
      .send({
        date_start: '2026-01-01',
        date_end: '2026-04-12',
        name: 'NIRMAL SING NITHISH N'
      });
    expect(res.status).toBe(200);
    expect(res.body.success).toBe(true);
    expect(res.body.data._id).toBe('test@example.com');
    expect(res.body.data.date_start).toBe('2026-01-01');
    expect(res.body.data.date_end).toBe('2026-04-12');
    expect(res.body.data.name).toBe('NIRMAL SING NITHISH N');
  });
});
