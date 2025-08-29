// isar_service.dart
// Centralized Isar initialization, schema registration, and common helpers.

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:isar/isar.dart';

import '../models/income_models.dart';
import '../models/expense_models.dart';
import '../models/tax_models.dart';
import '../models/goal_models.dart';

class IsarService {
  IsarService._();
  static final IsarService instance = IsarService._();

  Isar? _isar;

  Future<Isar> get db async {
    if (_isar != null) return _isar!;
    final dir = await getApplicationDocumentsDirectory();
    _isar = await Isar.open(
      [
        ServiceTemplateSchema,
        IncomeRecordSchema,
        ExpenseCategorySchema,
        ExpenseSchema,
        TaxPlanSchema,
        TaxPaymentSchema,
        MonthlyGoalSchema,
      ],
      directory: dir.path,
      inspector: kDebugMode,
    );
    
    // Populate default data on first run
    await _populateDefaultData();
    
    return _isar!;
  }

  Future<void> _populateDefaultData() async {
    try {
      // Check if we already have expense categories
      final existingCategories = await _isar!.expenseCategorys.where().findAll();
      if (existingCategories.isEmpty) {
        // Add default expense categories
        final defaultCategories = [
          ExpenseCategory()
            ..name = 'Rent'
            ..color = 0xFFE57373
            ..iconName = 'home'
            ..sortOrder = 1,
          ExpenseCategory()
            ..name = 'Supplies'
            ..color = 0xFF81C784
            ..iconName = 'inventory'
            ..sortOrder = 2,
          ExpenseCategory()
            ..name = 'Utilities'
            ..color = 0xFF64B5F6
            ..iconName = 'bolt'
            ..sortOrder = 3,
          ExpenseCategory()
            ..name = 'Marketing'
            ..color = 0xFFFFB74D
            ..iconName = 'campaign'
            ..sortOrder = 4,
          ExpenseCategory()
            ..name = 'Insurance'
            ..color = 0xFFBA68C8
            ..iconName = 'security'
            ..sortOrder = 5,
          ExpenseCategory()
            ..name = 'Other'
            ..color = 0xFF90A4AE
            ..iconName = 'more_horiz'
            ..sortOrder = 6,
        ];

        await _isar!.writeTxn(() async {
          for (final category in defaultCategories) {
            await _isar!.expenseCategorys.put(category);
          }
        });
        debugPrint('Default expense categories populated');
      }

      // Check if we have service templates
      final existingTemplates = await _isar!.serviceTemplates.where().findAll();
      if (existingTemplates.isEmpty) {
        // Add default service templates
        final defaultTemplates = [
          ServiceTemplate()
            ..name = 'Haircut'
            ..defaultPriceMinor = 2500
            ..active = true
            ..sortOrder = 1,
          ServiceTemplate()
            ..name = 'Hair Styling'
            ..defaultPriceMinor = 3500
            ..active = true
            ..sortOrder = 2,
          ServiceTemplate()
            ..name = 'Hair Coloring'
            ..defaultPriceMinor = 8000
            ..active = true
            ..sortOrder = 3,
          ServiceTemplate()
            ..name = 'Beard Trim'
            ..defaultPriceMinor = 1500
            ..active = true
            ..sortOrder = 4,
        ];

        await _isar!.writeTxn(() async {
          for (final template in defaultTemplates) {
            await _isar!.serviceTemplates.put(template);
          }
        });
        debugPrint('Default service templates populated');
      }
    } catch (e) {
      debugPrint('Error populating default data: $e');
    }
  }
}

