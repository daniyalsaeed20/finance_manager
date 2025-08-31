// isar_service.dart
// Centralized Isar initialization, schema registration, and common helpers.

import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../models/expense_models.dart';
import '../models/goal_models.dart';
import '../models/income_models.dart';
import '../models/tax_models.dart';

class IsarService {
  IsarService._();
  static final IsarService instance = IsarService._();

  Isar? _isar;

  Future<Isar> get db async {
    if (_isar != null) return _isar!;
    final dir = await getApplicationDocumentsDirectory();
    _isar = await Isar.open([
      ServiceTemplateSchema,
      IncomeRecordSchema,
      ExpenseCategorySchema,
      ExpenseSchema,
      TaxPlanSchema,
      TaxPaymentSchema,
      MonthlyGoalSchema,
    ], directory: dir.path);
    return _isar!;
  }

  Future<void> populateDefaultExpenseCategories(
    Isar isar,
    String userId,
  ) async {
    await isar.writeTxn(() async {
      final count = await isar.expenseCategorys
          .filter()
          .userIdEqualTo(userId)
          .count();
      if (count == 0) {
        final defaultCategories = [
          ExpenseCategory()
            ..name = 'Rent'
            ..userId = userId,
          ExpenseCategory()
            ..name = 'Utilities'
            ..userId = userId,
          ExpenseCategory()
            ..name = 'Supplies'
            ..userId = userId,
          ExpenseCategory()
            ..name = 'Marketing'
            ..userId = userId,
          ExpenseCategory()
            ..name = 'Salaries'
            ..userId = userId,
          ExpenseCategory()
            ..name = 'Other'
            ..userId = userId,
        ];
        await isar.expenseCategorys.putAll(defaultCategories);
      }
    });
  }
}
