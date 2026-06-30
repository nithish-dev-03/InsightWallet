import { body } from 'express-validator';

export const updateProfileValidator = [
  body('name')
    .optional()
    .trim()
    .isLength({ min: 2, max: 100 }).withMessage('Name must be 2-100 characters.'),
  body('currency')
    .optional()
    .trim()
    .isLength({ min: 3, max: 3 }).withMessage('Currency must be a 3-letter code.'),
  body('theme')
    .optional()
    .isIn(['light', 'dark', 'system']).withMessage('Theme must be light, dark, or system.'),
  body('biometricEnabled')
    .optional()
    .isBoolean().withMessage('biometricEnabled must be a boolean.'),
];
