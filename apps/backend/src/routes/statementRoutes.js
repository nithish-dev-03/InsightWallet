import { Router } from 'express';
import multer from 'multer';
import { importStatement, saveStatementImport } from '../controllers/statementController.js';
import auth from '../middlewares/auth.js';

// Configure memory storage and limits for bank statement uploads
const storage = multer.memoryStorage();
const upload = multer({
  storage,
  limits: {
    fileSize: 10 * 1024 * 1024, // 10MB maximum size
  },
});

const router = Router();

// Protect statement routes with authorization
router.use(auth);

// Import endpoint expects multipart/form-data with 'pdf' field
router.post('/import', upload.single('pdf'), importStatement);

// Save statement import metadata details endpoint
router.post('/save-import', saveStatementImport);

export default router;
