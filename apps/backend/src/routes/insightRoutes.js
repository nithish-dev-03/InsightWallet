import { Router } from 'express';
import {
  getMonthlySummary,
  getSpendingPrediction,
  getBudgetSuggestions,
  getExpenseTrends,
} from '../controllers/insightController.js';
import auth from '../middlewares/auth.js';

const router = Router();

router.use(auth);

router.get('/monthly-summary', getMonthlySummary);
router.get('/spending-prediction', getSpendingPrediction);
router.get('/budget-suggestions', getBudgetSuggestions);
router.get('/expense-trends', getExpenseTrends);

export default router;
