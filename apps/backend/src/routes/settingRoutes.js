import { Router } from 'express';
import { getSettings, updateSettings } from '../controllers/settingController.js';
import auth from '../middlewares/auth.js';
import validate from '../middlewares/validate.js';
import { updateSettingValidator } from '../validators/settingValidator.js';

const router = Router();

router.use(auth);

router.get('/', getSettings);
router.patch('/', validate(updateSettingValidator), updateSettings);

export default router;
