import '../entities/transaction_entity.dart';

abstract class TransactionRepository {
  Future<List<TransactionEntity>> getTransactions({
    int page = 1,
    int limit = 20,
    String? type,
    String? category,
    DateTime? dateFrom,
    DateTime? dateTo,
    String? sortBy,
    String? sortOrder,
    String? search,
  });
  Future<TransactionEntity> getTransactionById(String id);
  Future<TransactionEntity> createTransaction(Map<String, dynamic> data);
  Future<TransactionEntity> updateTransaction(String id, Map<String, dynamic> data);
  Future<void> deleteTransaction(String id);
}
