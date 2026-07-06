import jwt from 'jsonwebtoken';
import env from '../config/env.js';
import Auth from '../models/Auth.js';
import { errorResponse } from '../utils/apiResponse.js';

const auth = async (req, res, next) => {
  try {
    const authHeader = req.headers.authorization;
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return errorResponse(res, 'Access denied. No token provided.', 401);
    }

    const token = authHeader.split(' ')[1];
    const decoded = jwt.verify(token, env.jwtSecret);

    const authRecord = await Auth.findById(decoded.userId);
    if (!authRecord) {
      return errorResponse(res, 'User not found.', 401);
    }

    req.user = authRecord;
    req.userId = authRecord._id;
    req.userEmail = authRecord.email;
    next();
  } catch (error) {
    if (error.name === 'TokenExpiredError') {
      return errorResponse(res, 'Token expired.', 401);
    }
    if (error.name === 'JsonWebTokenError') {
      return errorResponse(res, 'Invalid token.', 401);
    }
    next(error);
  }
};

export default auth;
