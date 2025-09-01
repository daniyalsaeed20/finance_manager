// expense_repository.dart
// CRUD for expense categories and expenses

import 'package:isar/isar.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';

import '../models/expense_models.dart';
import '../services/isar_service.dart';

class ExpenseRepository {
  // Stream controller for real-time updates
  final StreamController<List<Expense>> _expenseController =
      StreamController<List<Expense>>.broadcast();

  Stream<List<Expense>> get expenseStream => _expenseController.stream;

  Future<List<ExpenseCategory>> getCategories(String userId) async {
    final db = await IsarService.instance.db;
    return db.expenseCategorys
        .filter()
        .userIdEqualTo(userId)
        .sortBySortOrder()
        .findAll();
  }

  Future<void> upsertCategory(ExpenseCategory category) async {
    final db = await IsarService.instance.db;
    await db.writeTxn(() async {
      await db.expenseCategorys.put(category);
    });
  }

  Future<void> deleteCategory(Id id) async {
    final db = await IsarService.instance.db;
    await db.writeTxn(() async {
      await db.expenseCategorys.delete(id);
    });
  }

  Future<void> addExpense(Expense expense) async {
    final db = await IsarService.instance.db;
    await db.writeTxn(() async {
      await db.expenses.put(expense);
    });

    // Notify listeners of data change
    _notifyDataChanged();
  }

  Future<void> updateExpense(Expense expense) async {
    final db = await IsarService.instance.db;
    await db.writeTxn(() async {
      await db.expenses.put(expense);
    });

    // Notify listeners of data change
    _notifyDataChanged();
  }

  Future<void> deleteExpense(Id id) async {
    final db = await IsarService.instance.db;
    await db.writeTxn(() async {
      await db.expenses.delete(id);
    });

    // Notify listeners of data change
    _notifyDataChanged();
  }

  Future<List<Expense>> getExpensesForDateRange(
    DateTime start,
    DateTime end,
    String userId,
  ) async {
    final db = await IsarService.instance.db;
    // Ensure we have the correct time boundaries
    final from = DateTime(start.year, start.month, start.day);
    final to = DateTime(end.year, end.month, end.day, 23, 59, 59, 999);

    debugPrint('🔍 ExpenseRepo: Querying from $from to $to for user $userId');
    debugPrint('🔍 ExpenseRepo: Original start: $start, Original end: $end');
    debugPrint('🔍 ExpenseRepo: Adjusted from: $from, Adjusted to: $to');

    // First, let's see all records for this user to debug
    final allUserRecords = await db.expenses
        .filter()
        .userIdEqualTo(userId)
        .findAll();

    debugPrint(
      '🔍 ExpenseRepo: Total records for user: ${allUserRecords.length}',
    );
    for (int i = 0; i < allUserRecords.length; i++) {
      final record = allUserRecords[i];
      final isInRange =
          record.date.isAfter(from.subtract(const Duration(seconds: 1))) &&
          record.date.isBefore(to.add(const Duration(seconds: 1)));
      debugPrint(
        '🔍 ExpenseRepo: Record $i - Date: ${record.date}, Is in range: $isInRange',
      );
    }

    // Use a more inclusive date range query
    final results = await db.expenses
        .filter()
        .userIdEqualTo(userId)
        .and()
        .dateGreaterThan(from.subtract(const Duration(seconds: 1)))
        .and()
        .dateLessThan(to.add(const Duration(seconds: 1)))
        .findAll();

    debugPrint(
      '🔍 ExpenseRepo: Found ${results.length} expense records in range',
    );
    return results;
  }

  // Stream method for real-time expense data
  Stream<List<Expense>> watchExpensesForDateRange(
    DateTime start,
    DateTime end,
    String userId,
  ) async* {
    final db = await IsarService.instance.db;
    final from = DateTime(start.year, start.month, start.day);
    final to = DateTime(end.year, end.month, end.day, 23, 59, 59, 999);

    yield* db.expenses
        .filter()
        .userIdEqualTo(userId)
        .and()
        .dateGreaterThan(from.subtract(const Duration(seconds: 1)))
        .and()
        .dateLessThan(to.add(const Duration(seconds: 1)))
        .watch(fireImmediately: true);
  }

  Future<Expense?> getExpenseById(Id id) async {
    final db = await IsarService.instance.db;
    return db.expenses.get(id);
  }

  // Notify all listeners that data has changed
  void _notifyDataChanged() {
    // This will trigger a refresh in any listening widgets
    _expenseController.add([]); // Empty list to trigger refresh
  }

  // Dispose method to clean up resources
  void dispose() {
    _expenseController.close();
  }
}
