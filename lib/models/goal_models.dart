// goal_models.dart
// Monthly income goal model using Isar.

import 'package:isar/isar.dart';

part 'goal_models.g.dart';

@embedded
class GoalStrategyItem {
  // Isar embedded objects must have a default constructor without required params
  String title = '';
}

@collection
class MonthlyGoal {
  Id id = Isar.autoIncrement;
  late String monthKey; // e.g. 2025-01
  late int targetAmountMinor;
  List<GoalStrategyItem> strategies = [];
}

