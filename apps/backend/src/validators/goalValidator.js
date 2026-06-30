import { body } from 'express-validator';

export const createGoalValidator = [
  body('name')
    .trim()
    .notEmpty().withMessage('Goal name is required.')
    .isLength({ max: 100 }).withMessage('Name must be under 100 characters.'),
  body('targetAmount')
    .notEmpty().withMessage('Target amount is required.')
    .isFloat({ min: 0.01 }).withMessage('Target amount must be a positive number.'),
  body('currentAmount')
    .optional()
    .isFloat({ min: 0 }).withMessage('Current amount must be non-negative.'),
  body('deadline')
    .optional()
    .isISO8601().withMessage('Invalid deadline format.'),
  body('icon')
    .optional()
    .trim(),
  body('color')
    .optional()
    .trim()
    .matches(/^#[0-9A-Fa-f]{6}$/).withMessage('Color must be a valid hex color.'),
  body('status')
    .optional()
    .isIn(['active', 'completed', 'cancelled']).withMessage('Invalid status.'),
];

export const updateGoalValidator = [
  body('name')
    .optional()
    .trim()
    .isLength({ max: 100 }).withMessage('Name must be under 100 characters.'),
  body('targetAmount')
    .optional()
    .isFloat({ min: 0.01 }).withMessage('Target amount must be a positive number.'),
  body('currentAmount')
    .optional()
    .isFloat({ min: 0 }).withMessage('Current amount must be non-negative.'),
  body('deadline')
    .optional()
    .isISO8601().withMessage('Invalid deadline format.'),
  body('icon')
    .optional()
    .trim(),
  body('color')
    .optional()
    .trim()
    .matches(/^#[0-9A-Fa-f]{6}$/).withMessage('Color must be a valid hex color.'),
  body('status')
    .optional()
    .isIn(['active', 'completed', 'cancelled']).withMessage('Invalid status.'),
];

export const addMilestoneValidator = [
  body('name')
    .trim()
    .notEmpty().withMessage('Milestone name is required.'),
  body('amount')
    .notEmpty().withMessage('Milestone amount is required.')
    .isFloat({ min: 0.01 }).withMessage('Amount must be a positive number.'),
];
