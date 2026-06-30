import { Router } from 'express';
import {
  getGoals,
  getGoal,
  createGoal,
  updateGoal,
  deleteGoal,
  addMilestone,
} from '../controllers/goalController.js';
import auth from '../middlewares/auth.js';
import validate from '../middlewares/validate.js';
import {
  createGoalValidator,
  updateGoalValidator,
  addMilestoneValidator,
} from '../validators/goalValidator.js';

const router = Router();

router.use(auth);

router.get('/', getGoals);
router.get('/:id', getGoal);
router.post('/', validate(createGoalValidator), createGoal);
router.put('/:id', validate(updateGoalValidator), updateGoal);
router.delete('/:id', deleteGoal);
router.post('/:id/milestones', validate(addMilestoneValidator), addMilestone);

export default router;
