import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/api_service.dart';
import '../../../../core/services/storage_service.dart';
import '../../data/repositories/category_repository_impl.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/repositories/category_repository.dart';

final _categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  final storage = StorageService();
  final api = ApiService(storage);
  return CategoryRepositoryImpl(api);
});

final categoryProvider =
    AsyncNotifierProvider<CategoryNotifier, List<CategoryEntity>>(
  CategoryNotifier.new,
);

class CategoryNotifier extends AsyncNotifier<List<CategoryEntity>> {
  @override
  Future<List<CategoryEntity>> build() async {
    return _fetchCategories();
  }

  Future<List<CategoryEntity>> _fetchCategories({String? type}) async {
    final repository = ref.read(_categoryRepositoryProvider);
    return repository.getCategories(type: type);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetchCategories);
  }
}
