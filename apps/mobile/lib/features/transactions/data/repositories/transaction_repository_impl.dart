import '../../../../core/config/api_config.dart';
import '../../../../core/services/api_service.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../models/transaction_model.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final ApiService _api;

  TransactionRepositoryImpl(this._api);

  @override
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
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'limit': limit,
      if (type != null) 'type': type,
      if (category != null) 'category': category,
      if (dateFrom != null) 'dateFrom': dateFrom.toIso8601String(),
      if (dateTo != null) 'dateTo': dateTo.toIso8601String(),
      if (sortBy != null) 'sortBy': sortBy,
      if (sortOrder != null) 'sortOrder': sortOrder,
      if (search != null) 'search': search,
    };

    final response = await _api.get(
      ApiConfig.transactions,
      queryParameters: queryParams,
    );

    final List<dynamic> jsonList = response.data['data'];
    return jsonList
        .map((json) =>
            TransactionModel.fromJson(json as Map<String, dynamic>).toEntity())
        .toList();
  }

  @override
  Future<TransactionEntity> getTransactionById(String id) async {
    final response = await _api.get(ApiConfig.transactionById(id));
    final model =
        TransactionModel.fromJson(response.data['data'] as Map<String, dynamic>);
    return model.toEntity();
  }

  @override
  Future<TransactionEntity> createTransaction(Map<String, dynamic> data) async {
    final response = await _api.post(ApiConfig.transactions, data: data);
    final model =
        TransactionModel.fromJson(response.data['data'] as Map<String, dynamic>);
    return model.toEntity();
  }

  @override
  Future<TransactionEntity> updateTransaction(
      String id, Map<String, dynamic> data) async {
    final response = await _api.put(ApiConfig.transactionById(id), data: data);
    final model =
        TransactionModel.fromJson(response.data['data'] as Map<String, dynamic>);
    return model.toEntity();
  }

  @override
  Future<void> deleteTransaction(String id) async {
    await _api.delete(ApiConfig.transactionById(id));
  }
}

extension _TransactionModelX on TransactionModel {
  TransactionEntity toEntity() {
    return TransactionEntity(
      id: id,
      amount: amount,
      type: type,
      category: category,
      categoryIcon: categoryIcon,
      categoryColor: categoryColor,
      description: description,
      date: date,
      note: note,
      tags: tags,
      receiptUrl: receiptUrl,
    );
  }
}
