import categoryRepository from '../repositories/categoryRepository.js';

class CategoryService {
  async getCategories(userId) {
    return categoryRepository.findByUser(userId);
  }

  async getCategory(categoryId, userId) {
    const category = await categoryRepository.findOne({
      _id: categoryId,
      $or: [{ user: userId }, { user: null, isDefault: true }],
    });
    if (!category) {
      const error = new Error('Category not found.');
      error.statusCode = 404;
      throw error;
    }
    return category;
  }

  async createCategory(userId, data) {
    const existing = await categoryRepository.findByNameAndUser(data.name, userId);
    if (existing) {
      const error = new Error('Category with this name already exists.');
      error.statusCode = 409;
      throw error;
    }
    return categoryRepository.create({ ...data, user: userId });
  }

  async updateCategory(categoryId, userId, data) {
    const category = await categoryRepository.findOne({
      _id: categoryId,
      user: userId,
    });
    if (!category) {
      const error = new Error('Category not found.');
      error.statusCode = 404;
      throw error;
    }
    if (data.name && data.name !== category.name) {
      const existing = await categoryRepository.findByNameAndUser(data.name, userId);
      if (existing) {
        const error = new Error('Category with this name already exists.');
        error.statusCode = 409;
        throw error;
      }
    }
    return categoryRepository.update(categoryId, data);
  }

  async deleteCategory(categoryId, userId) {
    const category = await categoryRepository.findOne({
      _id: categoryId,
      user: userId,
    });
    if (!category) {
      const error = new Error('Category not found.');
      error.statusCode = 404;
      throw error;
    }
    await categoryRepository.delete(categoryId);
  }
}

export default new CategoryService();
