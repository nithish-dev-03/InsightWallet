import { body } from 'express-validator';

export const createTransactionValidator = [
  body('type')
    .trim()
    .notEmpty().withMessage('Transaction type is required.')
    .isIn(['income', 'expense']).withMessage('Type must be income or expense.'),
  body('amount')
    .notEmpty().withMessage('Amount is required.')
    .isFloat({ min: 0.01 }).withMessage('Amount must be a positive number.'),
  body('category')
    .optional()
    .custom((value) => {
      if (typeof value !== 'string' || value.trim() === '') {
        throw new Error('Category must be a non-empty string.');
      }
      return true;
    }),
  body('description')
    .optional()
    .trim()
    .isLength({ max: 200 }).withMessage('Description must be under 200 characters.'),
  body('date')
    .optional()
    .isISO8601().withMessage('Invalid date format.'),
  body('tags')
    .optional()
    .isArray().withMessage('Tags must be an array.'),
  body('isRecurring')
    .optional()
    .isBoolean().withMessage('isRecurring must be a boolean.'),
  body('recurringInterval')
    .optional()
    .isIn(['daily', 'weekly', 'monthly', 'yearly']).withMessage('Invalid recurring interval.'),
  body('note')
    .optional()
    .trim()
    .isLength({ max: 500 }).withMessage('Note must be under 500 characters.'),
];

export const updateTransactionValidator = [
  body('type')
    .optional()
    .trim()
    .isIn(['income', 'expense']).withMessage('Type must be income or expense.'),
  body('amount')
    .optional()
    .isFloat({ min: 0.01 }).withMessage('Amount must be a positive number.'),
  body('category')
    .optional()
    .custom((value) => {
      if (typeof value !== 'string' || value.trim() === '') {
        throw new Error('Category must be a non-empty string.');
      }
      return true;
    }),
  body('description')
    .optional()
    .trim()
    .isLength({ max: 200 }).withMessage('Description must be under 200 characters.'),
  body('date')
    .optional()
    .isISO8601().withMessage('Invalid date format.'),
  body('tags')
    .optional()
    .isArray().withMessage('Tags must be an array.'),
  body('isRecurring')
    .optional()
    .isBoolean().withMessage('isRecurring must be a boolean.'),
  body('recurringInterval')
    .optional()
    .isIn(['daily', 'weekly', 'monthly', 'yearly']).withMessage('Invalid recurring interval.'),
  body('note')
    .optional()
    .trim()
    .isLength({ max: 500 }).withMessage('Note must be under 500 characters.'),
];
