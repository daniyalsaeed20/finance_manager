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
      // Check if a goal already exists for this month and user
      final existingGoal = await db.monthlyGoals
          .filter()
          .monthKeyEqualTo(goal.monthKey)
          .and()
          .userIdEqualTo(goal.userId)
          .findFirst();
      
      if (existingGoal != null) {
        // Update existing goal
        goal.id = existingGoal.id;
        await db.monthlyGoals.put(goal);
      } else {
        // Create new goal
        await db.monthlyGoals.put(goal);
      }
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

  // Get all goals for a user (for historical view)
  Future<List<MonthlyGoal>> getAllGoalsForUser(String userId) async {
    final db = await IsarService.instance.db;
    return db.monthlyGoals
        .filter()
        .userIdEqualTo(userId)
        .sortByMonthKey()
        .findAll();
  }

  // Get the most recent goal for a user (for fallback)
  Future<MonthlyGoal?> getMostRecentGoal(String userId) async {
    final db = await IsarService.instance.db;
    return db.monthlyGoals
        .filter()
        .userIdEqualTo(userId)
        .sortByMonthKey()
        .findFirst();
  }

  // Get goal for a specific month, or fall back to the most recent goal
  Future<MonthlyGoal?> getGoalForMonthWithFallback(String monthKey, String userId) async {
    // First try to get the specific month's goal
    final specificGoal = await getGoalForMonth(monthKey, userId);
    if (specificGoal != null) {
      return specificGoal;
    }
    
    // If no specific goal exists, get the most recent goal
    final mostRecentGoal = await getMostRecentGoal(userId);
    if (mostRecentGoal != null) {
      // Check if the most recent goal is from a previous month
      final mostRecentMonth = mostRecentGoal.monthKey;
      if (monthKey.compareTo(mostRecentMonth) >= 0) {
        // The requested month is the same as or after the most recent goal month
        // Return the most recent goal as it applies to this month
        return mostRecentGoal;
      }
    }
    
    return null;
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
