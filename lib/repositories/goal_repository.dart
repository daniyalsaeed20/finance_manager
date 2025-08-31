// goal_repository.dart
// Manage monthly income goals

import 'package:isar/isar.dart';

import '../models/goal_models.dart';
import '../services/isar_service.dart';

class GoalRepository {
  Future<void> upsertGoal(MonthlyGoal goal) async {
    final db = await IsarService.instance.db;
    await db.writeTxn(() async {
      await db.monthlyGoals.put(goal);
    });
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

  Future<void> deleteGoal(Id id) async {
    final db = await IsarService.instance.db;
    await db.writeTxn(() async {
      await db.monthlyGoals.delete(id);
    });
  }
}
