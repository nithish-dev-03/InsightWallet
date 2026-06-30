import BaseRepository from './BaseRepository.js';
import Category from '../models/Category.js';

class CategoryRepository extends BaseRepository {
  constructor() {
    super(Category);
  }

  async findByUser(userId) {
    return this.model
      .find({
        $or: [{ user: userId }, { user: null, isDefault: true }],
      })
      .sort({ sortOrder: 1, name: 1 });
  }

  async findByNameAndUser(name, userId) {
    return this.model.findOne({
      name: { $regex: new RegExp(`^${name}$`, 'i') },
      $or: [{ user: userId }, { user: null, isDefault: true }],
    });
  }
}

export default new CategoryRepository();
