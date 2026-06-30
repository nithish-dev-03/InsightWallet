import { Router } from 'express';
import {
  getBudgets,
  getBudget,
  createBudget,
  updateBudget,
  deleteBudget,
  getAlerts,
} from '../controllers/budgetController.js';
import auth from '../middlewares/auth.js';
import validate from '../middlewares/validate.js';
import {
  createBudgetValidator,
  updateBudgetValidator,
} from '../validators/budgetValidator.js';

const router = Router();

router.use(auth);

router.get('/', getBudgets);
router.get('/alerts', getAlerts);
router.get('/:id', getBudget);
router.post('/', validate(createBudgetValidator), createBudget);
router.put('/:id', validate(updateBudgetValidator), updateBudget);
router.delete('/:id', deleteBudget);

export default router;
