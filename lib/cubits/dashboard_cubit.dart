// dashboard_cubit.dart
// Aggregates data for dashboard charts and KPIs

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../repositories/income_repository.dart';
import '../repositories/expense_repository.dart';
import '../repositories/goal_repository.dart';

part 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final IncomeRepository incomeRepo;
  final ExpenseRepository expenseRepo;
  final GoalRepository goalRepo;

  DashboardCubit({
    required this.incomeRepo,
    required this.expenseRepo,
    required this.goalRepo,
  }) : super(DashboardState.initial());

  Future<void> loadForRange(DateTime start, DateTime end, String userId) async {
    emit(state.copyWith(loading: true, rangeStart: start, rangeEnd: end));

    // Load all data concurrently
    final results = await Future.wait([
      incomeRepo.getIncomeForDateRange(start, end, userId),
      expenseRepo.getExpensesForDateRange(start, end, userId),
      _getGoalForMonth(start, userId),
    ]);

    final income = results[0] as List;
    final expenses = results[1] as List;
    final goal = results[2];

    final totalIncomeMinor = income.fold<int>(
      0,
      (s, r) => s + (r.totalMinor as int),
    );
    final totalExpenseMinor = expenses.fold<int>(
      0,
      (s, e) => s + (e.amountMinor as int),
    );
    final netMinor = totalIncomeMinor - totalExpenseMinor;
    final goalAmountMinor = goal?.targetAmountMinor ?? 0;

    emit(
      state.copyWith(
        loading: false,
        totalIncomeMinor: totalIncomeMinor,
        totalExpenseMinor: totalExpenseMinor,
        netMinor: netMinor,
        goalAmountMinor: goalAmountMinor,
      ),
    );
  }

  Future<dynamic> _getGoalForMonth(DateTime date, String userId) async {
    final monthKey = '${date.year}-${date.month.toString().padLeft(2, '0')}';
    return await goalRepo.getGoalForMonth(monthKey, userId);
  }
}
