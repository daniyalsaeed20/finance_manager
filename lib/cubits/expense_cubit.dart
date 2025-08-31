// expense_cubit.dart
// Holds state and logic for expenses module

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../models/expense_models.dart';
import '../repositories/expense_repository.dart';

part 'expense_state.dart';

class ExpenseCubit extends Cubit<ExpenseState> {
  final ExpenseRepository repository;
  ExpenseCubit(this.repository) : super(ExpenseState.initial());

  Future<void> loadCategories(String userId) async {
    emit(state.copyWith(loading: true));
    final cats = await repository.getCategories(userId);
    emit(state.copyWith(loading: false, categories: cats));
  }

  Future<void> upsertCategory(ExpenseCategory c) async {
    await repository.upsertCategory(c);
    await loadCategories(c.userId);
  }

  Future<void> deleteCategory(int id) async {
    await repository.deleteCategory(id);
    // Note: We need userId to reload categories, but we don't have it here
    // This will be handled by the UI layer
  }

  Future<void> addExpense(Expense e) async {
    await repository.addExpense(e);
    await refreshRange(state.rangeStart, state.rangeEnd, e.userId);
  }

  Future<void> updateExpense(Expense e) async {
    await repository.updateExpense(e);
    await refreshRange(state.rangeStart, state.rangeEnd, e.userId);
  }

  Future<void> deleteExpense(int id, String userId) async {
    await repository.deleteExpense(id);
    // Immediately remove from state and refresh range
    await refreshRange(state.rangeStart, state.rangeEnd, userId);
  }

  Future<void> refreshRange(DateTime start, DateTime end, String userId) async {
    emit(state.copyWith(loading: true, rangeStart: start, rangeEnd: end));
    final items = await repository.getExpensesForDateRange(start, end, userId);
    final totalMinor = items.fold<int>(0, (sum, e) => sum + e.amountMinor);
    emit(
      state.copyWith(loading: false, expenses: items, totalMinor: totalMinor),
    );
  }
}
