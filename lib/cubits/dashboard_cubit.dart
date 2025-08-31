// dashboard_cubit.dart
// Aggregates data for dashboard charts and KPIs

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'dart:async';

import '../repositories/income_repository.dart';
import '../repositories/expense_repository.dart';
import '../repositories/goal_repository.dart';

part 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final IncomeRepository incomeRepo;
  final ExpenseRepository expenseRepo;
  final GoalRepository goalRepo;

  StreamSubscription? _incomeSubscription;
  StreamSubscription? _expenseSubscription;
  StreamSubscription? _goalSubscription;
  bool _isLoading = false;

  DashboardCubit({
    required this.incomeRepo,
    required this.expenseRepo,
    required this.goalRepo,
  }) : super(DashboardState.initial());

  Future<void> loadForRange(DateTime start, DateTime end, String userId) async {
    emit(state.copyWith(loading: true, rangeStart: start, rangeEnd: end));

    // Cancel previous subscriptions
    await _cancelSubscriptions();

    // Load initial data
    await _loadData(start, end, userId);

    // Set up real-time listeners
    _setupRealTimeListeners(start, end, userId);
  }

  Future<void> _loadData(DateTime start, DateTime end, String userId) async {
    if (_isLoading) {
      print('🔍 DashboardCubit: Already loading data, skipping...');
      return;
    }

    _isLoading = true;
    try {
      print('🔍 DashboardCubit: Loading data for range: $start to $end');
      print('🔍 DashboardCubit: User ID: $userId');
      print('🔍 DashboardCubit: Start date: ${start.toString()}');
      print('🔍 DashboardCubit: End date: ${end.toString()}');

      // Load all data concurrently
      final results = await Future.wait([
        incomeRepo.getIncomeForDateRange(start, end, userId),
        expenseRepo.getExpensesForDateRange(start, end, userId),
        _getGoalForMonth(start, userId),
      ]);

      final income = results[0] as List;
      final expenses = results[1] as List;
      final goal = results[2];

      print('🔍 DashboardCubit: Found ${income.length} income records');
      print('🔍 DashboardCubit: Found ${expenses.length} expense records');
      print('🔍 DashboardCubit: Goal: ${goal?.targetAmountMinor ?? 'None'}');

      // Debug: Print first few records
      if (income.isNotEmpty) {
        print('🔍 DashboardCubit: First income record: ${income.first}');
      }
      if (expenses.isNotEmpty) {
        print('🔍 DashboardCubit: First expense record: ${expenses.first}');
      }

      _updateState(income, expenses, goal);
    } catch (e) {
      print('❌ DashboardCubit: Error loading data: $e');
      emit(state.copyWith(loading: false));
    } finally {
      _isLoading = false;
    }
  }

  void _setupRealTimeListeners(DateTime start, DateTime end, String userId) {
    // Listen to income changes
    _incomeSubscription = incomeRepo
        .watchIncomeForDateRange(start, end, userId)
        .listen((_) => _refreshData(start, end, userId));

    // Listen to expense changes
    _expenseSubscription = expenseRepo
        .watchExpensesForDateRange(start, end, userId)
        .listen((_) => _refreshData(start, end, userId));

    // Listen to goal changes
    _goalSubscription = goalRepo
        .watchGoalForMonth(
          '${start.year}-${start.month.toString().padLeft(2, '0')}',
          userId,
        )
        .listen((_) => _refreshData(start, end, userId));
  }

  Future<void> _refreshData(DateTime start, DateTime end, String userId) async {
    await _loadData(start, end, userId);
  }

  void _updateState(List income, List expenses, dynamic goal) {
    print(
      '🔍 DashboardCubit: _updateState called with ${income.length} income and ${expenses.length} expense records',
    );

    // Debug each income record
    for (int i = 0; i < income.length; i++) {
      final record = income[i];
      print(
        '🔍 DashboardCubit: Income record $i - totalMinor: ${record.totalMinor}, type: ${record.runtimeType}, date: ${record.date}',
      );
    }

    // Debug each expense record
    for (int i = 0; i < expenses.length; i++) {
      final record = expenses[i];
      print(
        '🔍 DashboardCubit: Expense record $i - amountMinor: ${record.amountMinor}, type: ${record.runtimeType}, date: ${record.date}',
      );
    }

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

    print(
      '🔍 DashboardCubit: Calculated totals - Income: $totalIncomeMinor, Expenses: $totalExpenseMinor, Net: $netMinor, Goal: $goalAmountMinor',
    );
    print(
      '🔍 DashboardCubit: Raw income values: ${income.map((r) => r.totalMinor).toList()}',
    );
    print(
      '🔍 DashboardCubit: Raw expense values: ${expenses.map((r) => r.amountMinor).toList()}',
    );

    final newState = state.copyWith(
      loading: false,
      totalIncomeMinor: totalIncomeMinor,
      totalExpenseMinor: totalExpenseMinor,
      netMinor: netMinor,
      goalAmountMinor: goalAmountMinor,
    );

    print(
      '🔍 DashboardCubit: Emitting new state: ${newState.totalIncomeMinor}, ${newState.totalExpenseMinor}, ${newState.netMinor}',
    );

    emit(newState);
  }

  Future<dynamic> _getGoalForMonth(DateTime date, String userId) async {
    final monthKey = '${date.year}-${date.month.toString().padLeft(2, '0')}';
    return await goalRepo.getGoalForMonth(monthKey, userId);
  }

  Future<void> _cancelSubscriptions() async {
    await _incomeSubscription?.cancel();
    await _expenseSubscription?.cancel();
    await _goalSubscription?.cancel();

    _incomeSubscription = null;
    _expenseSubscription = null;
    _goalSubscription = null;
  }

  @override
  Future<void> close() {
    _cancelSubscriptions();
    return super.close();
  }
}
