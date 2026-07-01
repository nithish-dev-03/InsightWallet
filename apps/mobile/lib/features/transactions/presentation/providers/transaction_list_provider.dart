import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/services/sample_data_service.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/storage_service.dart';
import '../../data/models/transaction_filter.dart';
import '../../data/models/transaction_model.dart';
import '../../data/repositories/transaction_repository_impl.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../domain/repositories/transaction_repository.dart';

final _transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  final storage = StorageService();
  final api = ApiService(storage);
  return TransactionRepositoryImpl(api);
});

final transactionFilterProvider = StateProvider<TransactionFilter>(
  (_) => const TransactionFilter(),
);

final transactionListProvider =
    AsyncNotifierProvider<TransactionListNotifier, List<TransactionEntity>>(
  TransactionListNotifier.new,
);

class TransactionListNotifier extends AsyncNotifier<List<TransactionEntity>> {
  bool _hasMore = true;
  int _currentPage = 1;

  @override
  Future<List<TransactionEntity>> build() async {
    _currentPage = 1;
    _hasMore = true;
    return _fetchPage(1);
  }

  TransactionRepository get _repository =>
      ref.read(_transactionRepositoryProvider);

  TransactionFilter get _filter => ref.read(transactionFilterProvider);

  Future<List<TransactionEntity>> _fetchPage(int page) async {
    if (isLoadSampleData) {
      final json = await SampleDataService.getTransactionsData();
      final list = json['data'] as List<dynamic>;
      final transactions = list
          .map((e) {
            final model =
                TransactionModel.fromJson(e as Map<String, dynamic>);
            return TransactionEntity(
              id: model.id,
              amount: model.amount,
              type: model.type,
              category: model.category,
              categoryIcon: model.categoryIcon,
              categoryColor: model.categoryColor,
              description: model.description,
              date: model.date,
              note: model.note,
              tags: model.tags,
              receiptUrl: model.receiptUrl,
            );
          })
          .toList();
      _hasMore = false;
      return transactions;
    }
    final transactions = await _repository.getTransactions(
      page: page,
      limit: _filter.limit,
      type: _filter.type,
      category: _filter.category,
      dateFrom: _filter.dateFrom,
      dateTo: _filter.dateTo,
      sortBy: _filter.sortBy,
      sortOrder: _filter.sortOrder,
      search: _filter.search,
    );
    return transactions;
  }

  Future<void> loadMore() async {
    if (!_hasMore) return;
    final currentState = state;
    if (currentState is AsyncData && currentState.requireValue.isEmpty && _currentPage > 1) return;

    _currentPage++;
    try {
      final newTransactions = await _fetchPage(_currentPage);
      if (newTransactions.length < _filter.limit) {
        _hasMore = false;
      }
      if (currentState is AsyncData) {
        state = AsyncData([...currentState.requireValue, ...newTransactions]);
      }
    } catch (e) {
      _currentPage--;
    }
  }

  Future<void> refresh() async {
    _currentPage = 1;
    _hasMore = true;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetchPage(1));
  }

  Future<void> applyFilter(TransactionFilter filter) async {
    ref.read(transactionFilterProvider.notifier).state = filter;
    await refresh();
  }

  Future<void> search(String query) async {
    final currentFilter = _filter;
    await applyFilter(currentFilter.copyWith(search: query.isEmpty ? null : query));
  }
}
