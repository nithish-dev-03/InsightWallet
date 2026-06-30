import { Router } from 'express';
import {
  getCategories,
  getCategory,
  createCategory,
  updateCategory,
  deleteCategory,
} from '../controllers/categoryController.js';
import auth from '../middlewares/auth.js';
import validate from '../middlewares/validate.js';
import {
  createCategoryValidator,
  updateCategoryValidator,
} from '../validators/categoryValidator.js';

const router = Router();

router.use(auth);

router.get('/', getCategories);
router.get('/:id', getCategory);
router.post('/', validate(createCategoryValidator), createCategory);
router.put('/:id', validate(updateCategoryValidator), updateCategory);
router.delete('/:id', deleteCategory);

export default router;
