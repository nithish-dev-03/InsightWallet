import { Router } from 'express';
import {
  getProfile,
  getProfileByEmail,
  createProfile,
  updateProfile,
  updateAvatar,
  getStatistics,
} from '../controllers/profileController.js';
import auth from '../middlewares/auth.js';
import validate from '../middlewares/validate.js';
import upload from '../middlewares/upload.js';
import { updateProfileValidator, createProfileValidator } from '../validators/profileValidator.js';

const router = Router();

router.use(auth);

router.get('/', getProfile);
router.get('/by-email/:email', getProfileByEmail);
router.post('/', validate(createProfileValidator), createProfile);
router.patch('/', validate(updateProfileValidator), updateProfile);
router.put('/', validate(updateProfileValidator), updateProfile);
router.post('/avatar', upload.single('avatar'), updateAvatar);
router.get('/statistics', getStatistics);

export default router;
