import { validationResult } from 'express-validator';
import { errorResponse } from '../utils/apiResponse.js';

const validate = (validations) => {
  return async (req, res, next) => {
    for (const validation of validations) {
      const result = await validation.run(req);
      if (!result.isEmpty()) break;
    }

    const errors = validationResult(req);
    if (errors.isEmpty()) {
      return next();
    }

    const extractedErrors = errors.array().map((err) => err.msg);
    return errorResponse(res, 'Validation failed', 400, extractedErrors);
  };
};

export default validate;
