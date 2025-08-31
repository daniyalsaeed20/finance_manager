// expense_repository.dart
// CRUD for expense categories and expenses

import 'package:isar/isar.dart';

import '../models/expense_models.dart';
import '../services/isar_service.dart';

class ExpenseRepository {
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
  }

  Future<void> updateExpense(Expense expense) async {
    final db = await IsarService.instance.db;
    await db.writeTxn(() async {
      await db.expenses.put(expense);
    });
  }

  Future<void> deleteExpense(Id id) async {
    final db = await IsarService.instance.db;
    await db.writeTxn(() async {
      await db.expenses.delete(id);
    });
  }

  Future<List<Expense>> getExpensesForDateRange(
    DateTime start,
    DateTime end,
    String userId,
  ) async {
    final db = await IsarService.instance.db;
    final from = DateTime(start.year, start.month, start.day);
    final to = DateTime(end.year, end.month, end.day, 23, 59, 59);
    return db.expenses
        .filter()
        .dateBetween(from, to)
        .and()
        .userIdEqualTo(userId)
        .findAll();
  }

  Future<Expense?> getExpenseById(Id id) async {
    final db = await IsarService.instance.db;
    return db.expenses.get(id);
  }
}
