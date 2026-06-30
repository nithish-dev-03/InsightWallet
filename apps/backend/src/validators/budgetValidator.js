import { body } from 'express-validator';

export const createBudgetValidator = [
  body('category')
    .optional()
    .isMongoId().withMessage('Invalid category ID.'),
  body('amount')
    .notEmpty().withMessage('Budget amount is required.')
    .isFloat({ min: 0.01 }).withMessage('Amount must be a positive number.'),
  body('period')
    .trim()
    .notEmpty().withMessage('Period is required.')
    .isIn(['weekly', 'monthly', 'yearly']).withMessage('Period must be weekly, monthly, or yearly.'),
  body('startDate')
    .notEmpty().withMessage('Start date is required.')
    .isISO8601().withMessage('Invalid start date format.'),
  body('endDate')
    .notEmpty().withMessage('End date is required.')
    .isISO8601().withMessage('Invalid end date format.'),
  body('notifications')
    .optional()
    .isBoolean().withMessage('Notifications must be a boolean.'),
];

export const updateBudgetValidator = [
  body('category')
    .optional()
    .isMongoId().withMessage('Invalid category ID.'),
  body('amount')
    .optional()
    .isFloat({ min: 0.01 }).withMessage('Amount must be a positive number.'),
  body('period')
    .optional()
    .trim()
    .isIn(['weekly', 'monthly', 'yearly']).withMessage('Period must be weekly, monthly, or yearly.'),
  body('startDate')
    .optional()
    .isISO8601().withMessage('Invalid start date format.'),
  body('endDate')
    .optional()
    .isISO8601().withMessage('Invalid end date format.'),
  body('notifications')
    .optional()
    .isBoolean().withMessage('Notifications must be a boolean.'),
];
