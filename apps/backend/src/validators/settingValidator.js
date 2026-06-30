import { body } from 'express-validator';

export const updateSettingValidator = [
  body('theme')
    .optional()
    .isIn(['light', 'dark', 'system']).withMessage('Theme must be light, dark, or system.'),
  body('language')
    .optional()
    .trim()
    .isLength({ min: 2, max: 5 }).withMessage('Invalid language code.'),
  body('currency')
    .optional()
    .trim()
    .isLength({ min: 3, max: 3 }).withMessage('Currency must be a 3-letter code.'),
  body('notifications')
    .optional()
    .isObject().withMessage('Notifications must be an object.'),
  body('notifications.budgetAlerts')
    .optional()
    .isBoolean().withMessage('budgetAlerts must be a boolean.'),
  body('notifications.goalReminders')
    .optional()
    .isBoolean().withMessage('goalReminders must be a boolean.'),
  body('notifications.monthlySummary')
    .optional()
    .isBoolean().withMessage('monthlySummary must be a boolean.'),
  body('notifications.insights')
    .optional()
    .isBoolean().withMessage('insights must be a boolean.'),
  body('privacy')
    .optional()
    .isObject().withMessage('Privacy must be an object.'),
  body('privacy.showBalance')
    .optional()
    .isBoolean().withMessage('showBalance must be a boolean.'),
  body('privacy.showTransactions')
    .optional()
    .isBoolean().withMessage('showTransactions must be a boolean.'),
  body('exportFormat')
    .optional()
    .isIn(['csv', 'pdf']).withMessage('Export format must be csv or pdf.'),
];
