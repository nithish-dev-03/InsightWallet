import categoryService from '../services/categoryService.js';
import { successResponse } from '../utils/apiResponse.js';

export const getCategories = async (req, res, next) => {
  try {
    const categories = await categoryService.getCategories(req.userId);
    return successResponse(res, categories);
  } catch (error) {
    next(error);
  }
};

export const getCategory = async (req, res, next) => {
  try {
    const category = await categoryService.getCategory(req.params.id, req.userId);
    return successResponse(res, category);
  } catch (error) {
    next(error);
  }
};

export const createCategory = async (req, res, next) => {
  try {
    const category = await categoryService.createCategory(req.userId, req.body);
    return successResponse(res, category, 'Category created.', 201);
  } catch (error) {
    next(error);
  }
};

export const updateCategory = async (req, res, next) => {
  try {
    const category = await categoryService.updateCategory(req.params.id, req.userId, req.body);
    return successResponse(res, category, 'Category updated.');
  } catch (error) {
    next(error);
  }
};

export const deleteCategory = async (req, res, next) => {
  try {
    await categoryService.deleteCategory(req.params.id, req.userId);
    return successResponse(res, null, 'Category deleted.');
  } catch (error) {
    next(error);
  }
};
