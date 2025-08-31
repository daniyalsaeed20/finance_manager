part of 'goal_cubit.dart';

class GoalState extends Equatable {
  final bool loading;
  final String monthKey;
  final MonthlyGoal? goal;
  final List<MonthlyGoal> allGoals;

  const GoalState({
    required this.loading, 
    required this.monthKey, 
    required this.goal,
    required this.allGoals,
  });

  const GoalState.initial() : 
    loading = false, 
    monthKey = '', 
    goal = null,
    allGoals = const [];

  GoalState copyWith({
    bool? loading, 
    String? monthKey, 
    MonthlyGoal? goal,
    List<MonthlyGoal>? allGoals,
  }) {
    return GoalState(
      loading: loading ?? this.loading,
      monthKey: monthKey ?? this.monthKey,
      goal: goal ?? this.goal,
      allGoals: allGoals ?? this.allGoals,
    );
  }

  @override
  List<Object?> get props => [loading, monthKey, goal, allGoals];
}

