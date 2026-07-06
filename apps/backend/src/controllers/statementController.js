import statementService from '../services/statementService.js';
import { successResponse, errorResponse } from '../utils/apiResponse.js';
import { StatementImport } from '../models/Transaction.js';

/**
 * Handles the bank statement PDF upload, decryption, and parsing.
 * POST /api/v1/statements/import
 */
export const importStatement = async (req, res, next) => {
  try {
    // 1. Validate PDF file exists
    if (!req.file) {
      return errorResponse(res, 'PDF file is required.', 400, ['File not found in request.']);
    }

    // 2. Validate file type is PDF
    if (req.file.mimetype !== 'application/pdf') {
      return errorResponse(res, 'File type must be application/pdf.', 400, ['Invalid file type.']);
    }

    // 3. Validate password is not empty
    const { password } = req.body;
    if (!password || password.trim() === '') {
      return errorResponse(res, 'Password is required and cannot be empty.', 400, ['Password not found in request.']);
    }

    // 4. Call statement service to decrypt and parse
    const result = await statementService.importStatement(req.file.buffer, password);

    // 5. Return success response with structured transactions
    return successResponse(
      res, 
      {
        bank: result.bank,
        year: result.year,
        transactions: result.transactions,
        date_start: result.date_start,
        date_end: result.date_end,
        name: result.name
      },
      'Statement parsed successfully.'
    );
  } catch (error) {
    // If it's a known invalid password error, format it exactly as requested
    if (error.message === 'Invalid PDF password') {
      return res.status(400).json({
        success: false,
        message: 'Invalid PDF password'
      });
    }

    // Let the global error handler handle other unexpected errors or forward status
    if (error.statusCode) {
      return errorResponse(res, error.message, error.statusCode);
    }
    
    next(error);
  }
};

/**
 * Saves the statement import details (date_start, date_end, name) with user email as id.
 * POST /api/v1/statements/save-import
 */
export const saveStatementImport = async (req, res, next) => {
  try {
    const { date_start, date_end, name } = req.body;
    const email = req.user.email;

    if (!date_start || !date_end || !name) {
      return res.status(400).json({
        success: false,
        message: 'date_start, date_end, and name are required.'
      });
    }

    const doc = await StatementImport.findByIdAndUpdate(
      email,
      {
        date_start,
        date_end,
        name
      },
      { new: true, upsert: true }
    );

    return successResponse(res, doc, 'Statement import details saved successfully.');
  } catch (error) {
    next(error);
  }
};

export default {
  importStatement,
  saveStatementImport,
};
