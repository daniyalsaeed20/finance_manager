// goal_cubit.dart
// State for monthly income goal and strategies

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../models/goal_models.dart';
import '../repositories/goal_repository.dart';

part 'goal_state.dart';

class GoalCubit extends Cubit<GoalState> {
  final GoalRepository repository;
  GoalCubit(this.repository) : super(const GoalState.initial());

  Future<void> loadForMonth(String monthKey, String userId) async {
    emit(state.copyWith(loading: true, monthKey: monthKey));
    final goal = await repository.getGoalForMonthWithFallback(monthKey, userId);
    emit(state.copyWith(loading: false, goal: goal));
  }

  Future<void> loadAllGoals(String userId) async {
    emit(state.copyWith(loading: true));
    final goals = await repository.getAllGoalsForUser(userId);
    emit(state.copyWith(loading: false, allGoals: goals));
  }

  Future<void> upsert(MonthlyGoal goal) async {
    await repository.upsertGoal(goal);
    await loadForMonth(goal.monthKey, goal.userId);
  }

  Future<void> delete(int id) async {
    await repository.deleteGoal(id);
    // Note: We need userId to reload goal, but we don't have it here
    // This will be handled by the UI layer
  }
}
