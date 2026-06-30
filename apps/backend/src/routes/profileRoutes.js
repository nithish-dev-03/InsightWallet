import { Router } from 'express';
import {
  getProfile,
  updateProfile,
  updateAvatar,
  getStatistics,
} from '../controllers/profileController.js';
import auth from '../middlewares/auth.js';
import validate from '../middlewares/validate.js';
import upload from '../middlewares/upload.js';
import { updateProfileValidator } from '../validators/profileValidator.js';

const router = Router();

router.use(auth);

router.get('/', getProfile);
router.patch('/', validate(updateProfileValidator), updateProfile);
router.post('/avatar', upload.single('avatar'), updateAvatar);
router.get('/statistics', getStatistics);

export default router;
