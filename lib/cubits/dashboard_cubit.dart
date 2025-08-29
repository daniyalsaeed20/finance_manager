// dashboard_cubit.dart
// Aggregates data for dashboard charts and KPIs

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../repositories/income_repository.dart';
import '../repositories/expense_repository.dart';

part 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final IncomeRepository incomeRepo;
  final ExpenseRepository expenseRepo;
  DashboardCubit({required this.incomeRepo, required this.expenseRepo}) : super(DashboardState.initial());

  Future<void> loadForRange(DateTime start, DateTime end) async {
    emit(state.copyWith(loading: true, rangeStart: start, rangeEnd: end));
    final income = await incomeRepo.getIncomeForDateRange(start, end);
    final expenses = await expenseRepo.getExpensesForDateRange(start, end);
    final totalIncomeMinor = income.fold<int>(0, (s, r) => s + r.totalMinor);
    final totalExpenseMinor = expenses.fold<int>(0, (s, e) => s + e.amountMinor);
    final netMinor = totalIncomeMinor - totalExpenseMinor;
    emit(state.copyWith(
      loading: false,
      totalIncomeMinor: totalIncomeMinor,
      totalExpenseMinor: totalExpenseMinor,
      netMinor: netMinor,
    ));
  }
}

