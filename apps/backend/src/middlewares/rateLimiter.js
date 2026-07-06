import rateLimit from 'express-rate-limit';

const isDev = process.env.NODE_ENV !== 'production';

export const generalLimiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: isDev ? 1000 : 100,
  message: {
    success: false,
    message: 'Too many requests, please try again later.',
    errors: [],
  },
  standardHeaders: true,
  legacyHeaders: false,
});

export const authLimiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: isDev ? 500 : 5,  // relaxed in development
  message: {
    success: false,
    message: 'Too many authentication attempts, please try again later.',
    errors: [],
  },
  standardHeaders: true,
  legacyHeaders: false,
});
