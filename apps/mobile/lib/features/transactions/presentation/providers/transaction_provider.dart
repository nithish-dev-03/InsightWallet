import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/api_service.dart';
import '../../../../core/services/storage_service.dart';
import '../../data/repositories/transaction_repository_impl.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../domain/repositories/transaction_repository.dart';

final _transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  final storage = StorageService();
  final api = ApiService(storage);
  return TransactionRepositoryImpl(api);
});

final singleTransactionProvider =
    FutureProvider.family<TransactionEntity, String>((ref, id) async {
  final repository = ref.read(_transactionRepositoryProvider);
  return repository.getTransactionById(id);
});

final createTransactionProvider =
    FutureProvider.family<TransactionEntity, Map<String, dynamic>>(
        (ref, data) async {
  final repository = ref.read(_transactionRepositoryProvider);
  return repository.createTransaction(data);
});

final updateTransactionProvider =
    FutureProvider.family<TransactionEntity, ({String id, Map<String, dynamic> data})>(
        (ref, params) async {
  final repository = ref.read(_transactionRepositoryProvider);
  return repository.updateTransaction(params.id, params.data);
});

final deleteTransactionProvider =
    FutureProvider.family<void, String>((ref, id) async {
  final repository = ref.read(_transactionRepositoryProvider);
  await repository.deleteTransaction(id);
});
