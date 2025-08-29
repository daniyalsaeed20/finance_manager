part of 'goal_cubit.dart';

class GoalState extends Equatable {
  final bool loading;
  final String monthKey;
  final MonthlyGoal? goal;

  const GoalState({required this.loading, required this.monthKey, required this.goal});

  const GoalState.initial() : loading = false, monthKey = '', goal = null;

  GoalState copyWith({bool? loading, String? monthKey, MonthlyGoal? goal}) {
    return GoalState(
      loading: loading ?? this.loading,
      monthKey: monthKey ?? this.monthKey,
      goal: goal ?? this.goal,
    );
  }

  @override
  List<Object?> get props => [loading, monthKey, goal];
}

