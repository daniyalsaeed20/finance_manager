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

  Future<void> loadCategories() async {
    emit(state.copyWith(loading: true));
    final cats = await repository.getCategories();
    emit(state.copyWith(loading: false, categories: cats));
  }

  Future<void> upsertCategory(ExpenseCategory c) async {
    await repository.upsertCategory(c);
    await loadCategories();
  }

  Future<void> deleteCategory(int id) async {
    await repository.deleteCategory(id);
    await loadCategories();
  }

  Future<void> addExpense(Expense e) async {
    await repository.addExpense(e);
    await refreshRange(state.rangeStart, state.rangeEnd);
  }

  Future<void> updateExpense(Expense e) async {
    await repository.updateExpense(e);
    await refreshRange(state.rangeStart, state.rangeEnd);
  }

  Future<void> deleteExpense(int id) async {
    await repository.deleteExpense(id);
    await refreshRange(state.rangeStart, state.rangeEnd);
  }

  Future<void> refreshRange(DateTime start, DateTime end) async {
    emit(state.copyWith(loading: true, rangeStart: start, rangeEnd: end));
    final items = await repository.getExpensesForDateRange(start, end);
    final totalMinor = items.fold<int>(0, (sum, e) => sum + e.amountMinor);
    emit(state.copyWith(loading: false, expenses: items, totalMinor: totalMinor));
  }
}

