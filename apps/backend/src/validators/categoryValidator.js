import { body } from 'express-validator';

export const createCategoryValidator = [
  body('name')
    .trim()
    .notEmpty().withMessage('Category name is required.')
    .isLength({ max: 50 }).withMessage('Name must be under 50 characters.'),
  body('type')
    .trim()
    .notEmpty().withMessage('Category type is required.')
    .isIn(['income', 'expense']).withMessage('Type must be income or expense.'),
  body('icon')
    .optional()
    .trim(),
  body('color')
    .optional()
    .trim()
    .matches(/^#[0-9A-Fa-f]{6}$/).withMessage('Color must be a valid hex color.'),
  body('sortOrder')
    .optional()
    .isInt({ min: 0 }).withMessage('Sort order must be a non-negative integer.'),
];

export const updateCategoryValidator = [
  body('name')
    .optional()
    .trim()
    .isLength({ max: 50 }).withMessage('Name must be under 50 characters.'),
  body('type')
    .optional()
    .trim()
    .isIn(['income', 'expense']).withMessage('Type must be income or expense.'),
  body('icon')
    .optional()
    .trim(),
  body('color')
    .optional()
    .trim()
    .matches(/^#[0-9A-Fa-f]{6}$/).withMessage('Color must be a valid hex color.'),
  body('sortOrder')
    .optional()
    .isInt({ min: 0 }).withMessage('Sort order must be a non-negative integer.'),
];
