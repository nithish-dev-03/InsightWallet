import dotenv from 'dotenv';
dotenv.config();

import app from './app.js';
import connectDatabase from './config/database.js';
import env from './config/env.js';

const start = async () => {
  await connectDatabase();

  app.listen(env.port, () => {
    console.log(`
========================================
  InsightWallet API
  Environment: ${env.nodeEnv}
  Port: ${env.port}
  Docs: http://localhost:${env.port}/api/v1/docs
  Health: http://localhost:${env.port}/api/v1/health
========================================
    `);
  });
};

start().catch((error) => {
  console.error('Failed to start server:', error.message);
  process.exit(1);
});
