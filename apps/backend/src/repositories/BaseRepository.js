class BaseRepository {
  constructor(model) {
    this.model = model;
  }

  async findById(id, select = null) {
    const query = this.model.findById(id);
    if (select) query.select(select);
    return query;
  }

  async findOne(filter, select = null) {
    const query = this.model.findOne(filter);
    if (select) query.select(select);
    return query;
  }

  async findAll(
    filter = {},
    { page = 1, limit = 20, sort = { createdAt: -1 }, select = null } = {}
  ) {
    const skip = (page - 1) * limit;
    const query = this.model.find(filter).sort(sort).skip(skip).limit(limit);
    if (select) query.select(select);
    const [data, total] = await Promise.all([
      query,
      this.model.countDocuments(filter),
    ]);
    return { data, total, page, limit };
  }

  async create(data) {
    return this.model.create(data);
  }

  async update(id, data) {
    return this.model.findByIdAndUpdate(id, data, {
      new: true,
      runValidators: true,
    });
  }

  async delete(id) {
    return this.model.findByIdAndDelete(id);
  }

  async count(filter = {}) {
    return this.model.countDocuments(filter);
  }

  async aggregate(pipeline) {
    return this.model.aggregate(pipeline);
  }
}

export default BaseRepository;
