import { Router } from 'express';
import { register, login, refresh, logout, forgotPassword, resetPassword } from '../controllers/authController.js';
import validate from '../middlewares/validate.js';
import { authLimiter } from '../middlewares/rateLimiter.js';
import {
  registerValidator,
  loginValidator,
  forgotPasswordValidator,
  resetPasswordValidator,
} from '../validators/authValidator.js';

const router = Router();

router.post('/register', authLimiter, validate(registerValidator), register);
router.post('/login', authLimiter, validate(loginValidator), login);
router.post('/refresh', authLimiter, refresh);
router.post('/logout', logout);
router.post('/forgot-password', authLimiter, validate(forgotPasswordValidator), forgotPassword);
router.post('/reset-password/:token', authLimiter, validate(resetPasswordValidator), resetPassword);

export default router;
