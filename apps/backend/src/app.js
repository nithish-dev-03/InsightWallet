import express from 'express';
import helmet from 'helmet';
import cors from 'cors';
import compression from 'compression';
import morgan from 'morgan';
import cookieParser from 'cookie-parser';
import swaggerUi from 'swagger-ui-express';
import env from './config/env.js';
import { generalLimiter } from './middlewares/rateLimiter.js';
import errorHandler from './middlewares/errorHandler.js';
import swaggerSpec from './utils/swagger.js';
import {
  authRoutes,
  transactionRoutes,
  categoryRoutes,
  budgetRoutes,
  goalRoutes,
  insightRoutes,
  notificationRoutes,
  profileRoutes,
  settingRoutes,
} from './routes/index.js';

const app = express();

app.use(helmet());
app.use(cors({
  origin: env.frontendUrl,
  credentials: true,
}));
app.use(compression());
app.use(morgan(env.nodeEnv === 'production' ? 'combined' : 'dev'));
app.use(cookieParser());
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true }));
app.use(generalLimiter);

app.use('/api/v1/docs', swaggerUi.serve, swaggerUi.setup(swaggerSpec));

app.use('/api/v1/auth', authRoutes);
app.use('/api/v1/transactions', transactionRoutes);
app.use('/api/v1/categories', categoryRoutes);
app.use('/api/v1/budgets', budgetRoutes);
app.use('/api/v1/goals', goalRoutes);
app.use('/api/v1/insights', insightRoutes);
app.use('/api/v1/notifications', notificationRoutes);
app.use('/api/v1/profile', profileRoutes);
app.use('/api/v1/settings', settingRoutes);

app.get('/api/v1/health', (req, res) => {
  res.json({ success: true, message: 'OK', data: { uptime: process.uptime() } });
});

app.use((req, res) => {
  res.status(404).json({
    success: false,
    message: `Route ${req.originalUrl} not found.`,
    errors: [],
  });
});

app.use(errorHandler);

export default app;
