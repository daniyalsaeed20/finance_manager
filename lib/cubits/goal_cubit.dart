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

  Future<void> loadForMonth(String monthKey) async {
    emit(state.copyWith(loading: true, monthKey: monthKey));
    final goal = await repository.getGoalForMonth(monthKey);
    emit(state.copyWith(loading: false, goal: goal));
  }

  Future<void> upsert(MonthlyGoal goal) async {
    await repository.upsertGoal(goal);
    await loadForMonth(goal.monthKey);
  }

  Future<void> delete(int id) async {
    await repository.deleteGoal(id);
    await loadForMonth(state.monthKey);
  }
}

