// income_repository.dart
// CRUD for income records and service templates

import 'package:isar/isar.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';

import '../models/income_models.dart';
import '../services/isar_service.dart';

class IncomeRepository {
  // Stream controller for real-time updates
  final StreamController<List<IncomeRecord>> _incomeController =
      StreamController<List<IncomeRecord>>.broadcast();

  Stream<List<IncomeRecord>> get incomeStream => _incomeController.stream;

  Future<List<ServiceTemplate>> getServiceTemplates(String userId) async {
    final db = await IsarService.instance.db;
    return db.serviceTemplates
        .filter()
        .userIdEqualTo(userId)
        .sortBySortOrder()
        .findAll();
  }

  Future<void> upsertServiceTemplate(ServiceTemplate template) async {
    final db = await IsarService.instance.db;
    await db.writeTxn(() async {
      await db.serviceTemplates.put(template);
    });
  }

  Future<void> deleteServiceTemplate(Id id) async {
    final db = await IsarService.instance.db;
    await db.writeTxn(() async {
      await db.serviceTemplates.delete(id);
    });
  }

  Future<void> addIncomeRecord(IncomeRecord record) async {
    // compute totalMinor: sum(services.price * count) + tip
    final totalServices = record.services.fold<int>(
      0,
      (sum, s) => sum + (s.priceMinor * s.count),
    );
    record.totalMinor = totalServices + (record.tipMinor);

    final db = await IsarService.instance.db;
    await db.writeTxn(() async {
      await db.incomeRecords.put(record);
    });

    // Notify listeners of data change
    _notifyDataChanged();
  }

  Future<void> updateIncomeRecord(IncomeRecord record) async {
    // compute totalMinor: sum(services.price * count) + tip
    final totalServices = record.services.fold<int>(
      0,
      (sum, s) => sum + (s.priceMinor * s.count),
    );
    record.totalMinor = totalServices + (record.tipMinor);

    final db = await IsarService.instance.db;
    await db.writeTxn(() async {
      await db.incomeRecords.put(record);
    });

    // Notify listeners of data change
    _notifyDataChanged();
  }

  Future<void> deleteIncomeRecord(Id id) async {
    final db = await IsarService.instance.db;
    await db.writeTxn(() async {
      await db.incomeRecords.delete(id);
    });

    // Notify listeners of data change
    _notifyDataChanged();
  }

  Future<List<IncomeRecord>> getIncomeForDateRange(
    DateTime start,
    DateTime end,
    String userId,
  ) async {
    final db = await IsarService.instance.db;
    // Ensure we have the correct time boundaries
    final from = DateTime(start.year, start.month, start.day);
    final to = DateTime(end.year, end.month, end.day, 23, 59, 59, 999);

    debugPrint('🔍 IncomeRepo: Querying from $from to $to for user $userId');
    debugPrint('🔍 IncomeRepo: Original start: $start, Original end: $end');
    debugPrint('🔍 IncomeRepo: Adjusted from: $from, Adjusted to: $to');

    // First, let's see all records for this user to debug
    final allUserRecords = await db.incomeRecords
        .filter()
        .userIdEqualTo(userId)
        .findAll();

    debugPrint(
      '🔍 IncomeRepo: Total records for user: ${allUserRecords.length}',
    );
    for (int i = 0; i < allUserRecords.length; i++) {
      final record = allUserRecords[i];
      final isInRange =
          record.date.isAfter(from.subtract(const Duration(seconds: 1))) &&
          record.date.isBefore(to.add(const Duration(seconds: 1)));
      debugPrint(
        '🔍 IncomeRepo: Record $i - Date: ${record.date}, Is in range: $isInRange',
      );
    }

    // Use a more inclusive date range query
    final results = await db.incomeRecords
        .filter()
        .userIdEqualTo(userId)
        .and()
        .dateGreaterThan(from.subtract(const Duration(seconds: 1)))
        .and()
        .dateLessThan(to.add(const Duration(seconds: 1)))
        .findAll();

    debugPrint(
      '🔍 IncomeRepo: Found ${results.length} income records in range',
    );
    return results;
  }

  // Stream method for real-time income data
  Stream<List<IncomeRecord>> watchIncomeForDateRange(
    DateTime start,
    DateTime end,
    String userId,
  ) async* {
    final db = await IsarService.instance.db;
    final from = DateTime(start.year, start.month, start.day);
    final to = DateTime(end.year, end.month, end.day, 23, 59, 59, 999);

    yield* db.incomeRecords
        .filter()
        .userIdEqualTo(userId)
        .and()
        .dateGreaterThan(from.subtract(const Duration(seconds: 1)))
        .and()
        .dateLessThan(to.add(const Duration(seconds: 1)))
        .watch(fireImmediately: true);
  }

  Future<IncomeRecord?> getIncomeRecordById(Id id) async {
    final db = await IsarService.instance.db;
    return db.incomeRecords.get(id);
  }

  // Notify all listeners that data has changed
  void _notifyDataChanged() {
    // This will trigger a refresh in any listening widgets
    _incomeController.add([]); // Empty list to trigger refresh
  }

  // Dispose method to clean up resources
  void dispose() {
    _incomeController.close();
  }
}
