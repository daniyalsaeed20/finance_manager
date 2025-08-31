// goal_repository.dart
// Manage monthly income goals

import 'package:isar/isar.dart';
import 'dart:async';

import '../models/goal_models.dart';
import '../services/isar_service.dart';

class GoalRepository {
  // Stream controller for real-time updates
  final StreamController<MonthlyGoal?> _goalController =
      StreamController<MonthlyGoal?>.broadcast();

  Stream<MonthlyGoal?> get goalStream => _goalController.stream;

  Future<void> upsertGoal(MonthlyGoal goal) async {
    final db = await IsarService.instance.db;
    await db.writeTxn(() async {
      await db.monthlyGoals.put(goal);
    });

    // Notify listeners of data change
    _notifyDataChanged(goal);
  }

  Future<MonthlyGoal?> getGoalForMonth(String monthKey, String userId) async {
    final db = await IsarService.instance.db;
    return db.monthlyGoals
        .filter()
        .monthKeyEqualTo(monthKey)
        .and()
        .userIdEqualTo(userId)
        .findFirst();
  }

  // Stream method for real-time goal data
  Stream<MonthlyGoal?> watchGoalForMonth(
    String monthKey,
    String userId,
  ) async* {
    final db = await IsarService.instance.db;

    yield* db.monthlyGoals
        .filter()
        .monthKeyEqualTo(monthKey)
        .and()
        .userIdEqualTo(userId)
        .watch(fireImmediately: true)
        .map((goals) => goals.isNotEmpty ? goals.first : null);
  }

  Future<void> deleteGoal(Id id) async {
    final db = await IsarService.instance.db;
    await db.writeTxn(() async {
      await db.monthlyGoals.delete(id);
    });

    // Notify listeners of data change
    _notifyDataChanged(null);
  }

  // Notify all listeners that data has changed
  void _notifyDataChanged(MonthlyGoal? goal) {
    _goalController.add(goal);
  }

  // Dispose method to clean up resources
  void dispose() {
    _goalController.close();
  }
}
