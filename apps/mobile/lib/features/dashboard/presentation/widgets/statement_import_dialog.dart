import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:dio/dio.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/api_config.dart';
import '../../../../core/providers/providers.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/format_utils.dart';
import '../../../../core/shared/widgets/glass_card.dart';
import '../../../profile/presentation/providers/profile_provider.dart';
import '../../../transactions/presentation/providers/transaction_list_provider.dart';
import '../../presentation/providers/dashboard_provider.dart';

class StatementImportDialog extends ConsumerStatefulWidget {
  const StatementImportDialog({super.key});

  @override
  ConsumerState<StatementImportDialog> createState() => _StatementImportDialogState();
}

class _StatementImportDialogState extends ConsumerState<StatementImportDialog> {
  // Navigation & Wizard State
  int _step = 1; // 1 = Upload & Password, 2 = Review, 3 = Success
  bool _isLoading = false;
  String? _errorMessage;

  // File Upload State
  PlatformFile? _selectedFile;
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  // Parsed Data State
  String? _bankName;
  int? _statementYear;
  String? _dateStart;
  String? _dateEnd;
  String? _accountName;
  List<_ReviewTransaction> _parsedTransactions = [];

  // Dropdown Categories
  final List<(String, IconData, String)> _categories = [
    ('food', Icons.restaurant_rounded, 'Food'),
    ('transport', Icons.directions_car_rounded, 'Transport'),
    ('shopping', Icons.shopping_bag_rounded, 'Shopping'),
    ('entertainment', Icons.movie_rounded, 'Entertainment'),
    ('bills', Icons.receipt_long_rounded, 'Bills'),
    ('salary', Icons.work_rounded, 'Salary'),
    ('freelance', Icons.code_rounded, 'Freelance'),
    ('investment', Icons.trending_up_rounded, 'Investment'),
    ('health', Icons.favorite_rounded, 'Health'),
    ('education', Icons.school_rounded, 'Education'),
    ('credit', Icons.credit_card_rounded, 'Credit'),
  ];

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null && result.files.isNotEmpty) {
        setState(() {
          _selectedFile = result.files.first;
          _errorMessage = null;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to pick file: $e';
      });
    }
  }

  String _suggestCategory(String description, String type) {
    final descLower = description.toLowerCase();
    if (type == 'income') {
      if (descLower.contains('freelance') || descLower.contains('contract') || descLower.contains('upwork')) {
        return 'freelance';
      }
      if (descLower.contains('invest') || descLower.contains('dividend') || descLower.contains('interest')) {
        return 'investment';
      }
      if (descLower.contains('salary')) {
        return 'salary';
      }
      return 'credit';
    } else {
      if (descLower.contains('starbucks') ||
          descLower.contains('mcdonald') ||
          descLower.contains('restaurant') ||
          descLower.contains('food') ||
          descLower.contains('cafe') ||
          descLower.contains('eats') ||
          descLower.contains('grubhub') ||
          descLower.contains('ubereats') ||
          descLower.contains('coffee')) {
        return 'food';
      }
      if (descLower.contains('uber') ||
          descLower.contains('lyft') ||
          descLower.contains('gas') ||
          descLower.contains('chevron') ||
          descLower.contains('shell') ||
          descLower.contains('transit') ||
          descLower.contains('train') ||
          descLower.contains('metro') ||
          descLower.contains('parking') ||
          descLower.contains('fuel')) {
        return 'transport';
      }
      if (descLower.contains('netflix') ||
          descLower.contains('spotify') ||
          descLower.contains('disney') ||
          descLower.contains('steam') ||
          descLower.contains('hulu') ||
          descLower.contains('ticket') ||
          descLower.contains('cinema') ||
          descLower.contains('game')) {
        return 'entertainment';
      }
      if (descLower.contains('bill') ||
          descLower.contains('electric') ||
          descLower.contains('power') ||
          descLower.contains('water') ||
          descLower.contains('utility') ||
          descLower.contains('internet') ||
          descLower.contains('comcast') ||
          descLower.contains('verizon') ||
          descLower.contains('t-mobile') ||
          descLower.contains('phone') ||
          descLower.contains('insurance') ||
          descLower.contains('mobile')) {
        return 'bills';
      }
      if (descLower.contains('doctor') ||
          descLower.contains('pharmacy') ||
          descLower.contains('hospital') ||
          descLower.contains('medical') ||
          descLower.contains('dentist') ||
          descLower.contains('health') ||
          descLower.contains('gym') ||
          descLower.contains('fitness')) {
        return 'health';
      }
      if (descLower.contains('school') ||
          descLower.contains('course') ||
          descLower.contains('book') ||
          descLower.contains('tutor') ||
          descLower.contains('education') ||
          descLower.contains('university')) {
        return 'education';
      }
      return 'shopping';
    }
  }

  Future<void> _uploadAndExtract() async {
    if (_selectedFile == null) {
      setState(() => _errorMessage = 'Please select a statement PDF file.');
      return;
    }
    if (_passwordController.text.trim().isEmpty) {
      setState(() => _errorMessage = 'PDF Password is required.');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final apiService = ref.read(apiServiceProvider);
      
      // Construct FormData for multipart upload
      final file = File(_selectedFile!.path!);
      final multipartFile = await MultipartFile.fromFile(
        file.path,
        filename: _selectedFile!.name,
      );

      final formData = FormData.fromMap({
        'pdf': multipartFile,
        'password': _passwordController.text,
      });

      final response = await apiService.post(
        ApiConfig.importStatement,
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
        ),
      );

      final responseData = response.data;
      if (responseData['success'] == true) {
        final data = responseData['data'];
        final rawTxns = data['transactions'] as List<dynamic>;

        setState(() {
          _bankName = data['bank'] as String?;
          _statementYear = data['year'] as int?;
          _dateStart = data['date_start'] as String?;
          _dateEnd = data['date_end'] as String?;
          _accountName = data['name'] as String?;
          _parsedTransactions = rawTxns.map((json) {
            final desc = json['description'] as String? ?? '';
            final type = json['type'] as String? ?? 'expense';
            final dateStr = json['date'] as String? ?? '';
            final amount = (json['amount'] as num?)?.toDouble() ?? 0.0;
            
            return _ReviewTransaction(
              date: DateTime.tryParse(dateStr) ?? DateTime.now(),
              description: desc,
              amount: amount,
              type: type,
              category: _suggestCategory(desc, type),
              selected: true,
            );
          }).toList();
          _step = 2; // Move to Review step
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = responseData['message'] ?? 'Failed to parse statement.';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        if (e is DioException) {
          final res = e.response;
          if (res != null && res.data is Map) {
            _errorMessage = res.data['message'] ?? 'An error occurred on the server.';
          } else {
            _errorMessage = e.message ?? 'Network connection error.';
          }
        } else {
          _errorMessage = e.toString();
        }
        _isLoading = false;
      });
    }
  }

  Future<void> _importTransactions() async {
    final selectedTxns = _parsedTransactions.where((t) => t.selected).toList();
    if (selectedTxns.isEmpty) {
      setState(() => _errorMessage = 'Please select at least one transaction to import.');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final apiService = ref.read(apiServiceProvider);

      // Save all selected transactions in a single bulk request
      final transactionList = selectedTxns.map((txn) {
        return {
          'amount': txn.amount,
          'type': txn.type,
          'category': txn.category,
          'description': txn.description,
          'date': txn.date.toIso8601String(),
          'note': 'Imported from $_bankName statement',
        };
      }).toList();

      await apiService.post(
        ApiConfig.bulkTransactions,
        data: {
          'transactions': transactionList,
        },
      );

      // Save statement details (date_start, date_end, name) to DB if available
      if (_dateStart != null && _dateEnd != null && _accountName != null) {
        await apiService.post(
          ApiConfig.saveStatementImport,
          data: {
            'date_start': _dateStart,
            'date_end': _dateEnd,
            'name': _accountName,
          },
        );
      }

      // Invalidate providers to refresh the dashboard and transaction lists
      ref.invalidate(transactionListProvider);
      ref.invalidate(dashboardProvider);

      setState(() {
        _step = 3; // Move to Success step
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to import transactions: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currencySymbol = ref.watch(currencySymbolProvider);

    return Dialog(
      backgroundColor: isDark
          ? const Color(0xFF1E293B).withValues(alpha: 0.6)
          : Colors.white.withValues(alpha: 0.8),
      insetPadding: const EdgeInsets.symmetric(horizontal: Insets.md, vertical: Insets.lg),
      child: GlassCard(
        padding: const EdgeInsets.all(Insets.md),
        child: AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: _isLoading
              ? _buildLoadingState()
              : _step == 1
                  ? _buildUploadState(isDark)
                  : _step == 2
                      ? _buildReviewState(isDark, currencySymbol)
                      : _buildSuccessState(isDark),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      padding: const EdgeInsets.all(Insets.xl),
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(
            color: AppColors.primary,
          ),
          const SizedBox(height: Insets.lg),
          Text(
            _step == 1 ? 'Decrypting & parsing statement...' : 'Importing transactions...',
            style: AppTypography.headlineSm.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: Insets.sm),
          Text(
            _step == 1 ? 'This may take a few seconds' : 'Writing to local database',
            style: AppTypography.bodySm.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadState(bool isDark) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Import PDF Statement',
                style: AppTypography.headlineSm.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => context.pop(),
              ),
            ],
          ),
          const SizedBox(height: Insets.md),
          if (_errorMessage != null) ...[
            Container(
              padding: const EdgeInsets.all(Insets.sm),
              decoration: BoxDecoration(
                color: AppColors.expense.withValues(alpha: 0.15),
                borderRadius: AppRadius.brMd,
              ),
              child: Row(
                children: [
                  const Icon(Icons.error_outline_rounded, color: AppColors.expense),
                  const SizedBox(width: Insets.sm),
                  Expanded(
                    child: Text(
                      _errorMessage!,
                      style: AppTypography.bodySm.copyWith(color: AppColors.expense),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: Insets.md),
          ],
          // File selection box
          InkWell(
            onTap: _pickFile,
            borderRadius: AppRadius.brLg,
            child: Container(
              padding: const EdgeInsets.all(Insets.lg),
              decoration: BoxDecoration(
                border: Border.all(
                  color: _selectedFile != null
                      ? AppColors.success
                      : Theme.of(context).colorScheme.outlineVariant,
                  width: 1.5,
                ),
                borderRadius: AppRadius.brLg,
                color: (isDark ? AppColors.darkSurface : AppColors.lightSurface)
                    .withValues(alpha: 0.3),
              ),
              child: Column(
                children: [
                  Icon(
                    _selectedFile != null
                        ? Icons.check_circle_rounded
                        : Icons.upload_file_rounded,
                    size: 48,
                    color: _selectedFile != null
                        ? AppColors.success
                        : Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: Insets.sm),
                  Text(
                    _selectedFile != null ? _selectedFile!.name : 'Choose PDF Statement',
                    style: AppTypography.bodyMd.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: Insets.xs),
                  Text(
                    _selectedFile != null
                        ? '${(_selectedFile!.size / 1024).toStringAsFixed(1)} KB'
                        : 'Chase or Wells Fargo Statement PDF supported',
                    style: AppTypography.bodySm.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: Insets.md),
          // Password Input
          Text(
            'PDF Password',
            style: AppTypography.bodyMd.copyWith(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: Insets.xs),
          TextField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            decoration: InputDecoration(
              hintText: 'Enter statement PDF password',
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                ),
                onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
              ),
              border: const OutlineInputBorder(
                borderRadius: AppRadius.brMd,
              ),
            ),
          ),
          const SizedBox(height: Insets.lg),
          FilledButton.icon(
            onPressed: _selectedFile == null ? null : _uploadAndExtract,
            icon: const Icon(Icons.analytics_outlined),
            label: const Text('Extract Transactions'),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.all(Insets.md),
              backgroundColor: AppColors.primary,
              shape: const RoundedRectangleBorder(
                borderRadius: AppRadius.brMd,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewState(bool isDark, String currencySymbol) {
    final selectedCount = _parsedTransactions.where((t) => t.selected).length;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Review Extracted Transactions',
                    style: AppTypography.headlineSm.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '$_bankName Statement${_statementYear != null ? ' ($_statementYear)' : ''}',
                    style: AppTypography.bodySm.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => context.pop(),
            ),
          ],
        ),
        const SizedBox(height: Insets.md),
        if (_errorMessage != null) ...[
          Container(
            padding: const EdgeInsets.all(Insets.sm),
            decoration: BoxDecoration(
              color: AppColors.expense.withValues(alpha: 0.15),
              borderRadius: AppRadius.brMd,
            ),
            child: Text(
              _errorMessage!,
              style: AppTypography.bodySm.copyWith(color: AppColors.expense),
            ),
          ),
          const SizedBox(height: Insets.md),
        ],
        // Transaction list container
        Container(
          constraints: const BoxConstraints(maxHeight: 350),
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
            borderRadius: AppRadius.brLg,
          ),
          child: ClipRRect(
            borderRadius: AppRadius.brLg,
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: _parsedTransactions.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (ctx, index) {
                final txn = _parsedTransactions[index];
                final isIncome = txn.type == 'income';

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: Insets.xs, horizontal: Insets.sm),
                  child: Row(
                    children: [
                      Checkbox(
                        value: txn.selected,
                        onChanged: (val) {
                          setState(() {
                            txn.selected = val ?? false;
                          });
                        },
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              txn.description,
                              style: AppTypography.bodyMd.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              FormatUtils.formatAbsoluteDate(txn.date),
                              style: AppTypography.bodySm.copyWith(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: Insets.sm),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${isIncome ? '+' : '-'}${FormatUtils.formatCurrency(txn.amount, currencySymbol: currencySymbol)}',
                            style: AppTypography.bodyMd.copyWith(
                              fontWeight: FontWeight.bold,
                              color: isIncome ? AppColors.income : AppColors.expense,
                            ),
                          ),
                          const SizedBox(height: 4),
                          // Dropdown for Category selection
                          DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: txn.category,
                              isDense: true,
                              iconSize: 16,
                              style: AppTypography.bodySm.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              onChanged: (cat) {
                                if (cat != null) {
                                  setState(() {
                                    txn.category = cat;
                                  });
                                }
                              },
                              items: _categories.map((c) {
                                final (key, icon, label) = c;
                                return DropdownMenuItem<String>(
                                  value: key,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(icon, size: 14),
                                      const SizedBox(width: 4),
                                      Text(label),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: Insets.lg),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  setState(() {
                    _step = 1;
                    _errorMessage = null;
                  });
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: Insets.md),
                  shape: const RoundedRectangleBorder(
                    borderRadius: AppRadius.brMd,
                  ),
                ),
                child: const Text('Back'),
              ),
            ),
            const SizedBox(width: Insets.md),
            Expanded(
              child: FilledButton(
                onPressed: selectedCount == 0 ? null : _importTransactions,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: Insets.md),
                  backgroundColor: AppColors.primary,
                  shape: const RoundedRectangleBorder(
                    borderRadius: AppRadius.brMd,
                  ),
                ),
                child: Text('Import ($selectedCount)'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSuccessState(bool isDark) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Icon(
          Icons.check_circle_outline_rounded,
          size: 64,
          color: AppColors.success,
        ),
        const SizedBox(height: Insets.md),
        Text(
          'Import Successful!',
          style: AppTypography.headlineSm.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: Insets.sm),
        Text(
          'Your bank statement has been successfully imported. Your dashboard and transaction lists have been updated.',
          style: AppTypography.bodyMd.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: Insets.lg),
        FilledButton(
          onPressed: () => context.pop(),
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.all(Insets.md),
            backgroundColor: AppColors.primary,
            shape: const RoundedRectangleBorder(
              borderRadius: AppRadius.brMd,
            ),
          ),
          child: const Text('Dismiss'),
        ),
      ],
    );
  }
}

class _ReviewTransaction {
  final DateTime date;
  final String description;
  final double amount;
  final String type;
  String category;
  bool selected;

  _ReviewTransaction({
    required this.date,
    required this.description,
    required this.amount,
    required this.type,
    required this.category,
    required this.selected,
  });
}
