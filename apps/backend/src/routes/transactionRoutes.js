import { Router } from 'express';
import {
  getTransactions,
  getTransaction,
  createTransaction,
  updateTransaction,
  deleteTransaction,
  getSummary,
} from '../controllers/transactionController.js';
import auth from '../middlewares/auth.js';
import validate from '../middlewares/validate.js';
import {
  createTransactionValidator,
  updateTransactionValidator,
} from '../validators/transactionValidator.js';

const router = Router();

router.use(auth);

router.get('/', getTransactions);
router.get('/summary', getSummary);
router.get('/:id', getTransaction);
router.post('/', validate(createTransactionValidator), createTransaction);
router.put('/:id', validate(updateTransactionValidator), updateTransaction);
router.delete('/:id', deleteTransaction);

export default router;
