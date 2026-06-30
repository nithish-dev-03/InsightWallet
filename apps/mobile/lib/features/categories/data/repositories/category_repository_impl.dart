import '../../../../core/config/api_config.dart';
import '../../../../core/services/api_service.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/repositories/category_repository.dart';
import '../models/category_model.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final ApiService _api;

  CategoryRepositoryImpl(this._api);

  @override
  Future<List<CategoryEntity>> getCategories({String? type}) async {
    final queryParams = <String, dynamic>{};
    if (type != null) queryParams['type'] = type;

    final response = await _api.get(
      ApiConfig.categories,
      queryParameters: queryParams,
    );

    final List<dynamic> jsonList = response.data['data'];
    return jsonList
        .map((json) =>
            CategoryModel.fromJson(json as Map<String, dynamic>).toEntity())
        .toList();
  }
}

extension _CategoryModelX on CategoryModel {
  CategoryEntity toEntity() {
    return CategoryEntity(
      id: id,
      name: name,
      type: type,
      icon: icon,
      color: color,
      isDefault: isDefault,
    );
  }
}
