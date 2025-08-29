// income_repository.dart
// CRUD for income records and service templates

import 'package:isar/isar.dart';

import '../models/income_models.dart';
import '../services/isar_service.dart';

class IncomeRepository {
  Future<List<ServiceTemplate>> getServiceTemplates() async {
    final db = await IsarService.instance.db;
    return db.serviceTemplates.where().sortBySortOrder().findAll();
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
    // compute totalMinor
    final totalServices = record.services.fold<int>(0, (sum, s) => sum + s.priceMinor);
    record.totalMinor = totalServices + (record.tipMinor);

    final db = await IsarService.instance.db;
    await db.writeTxn(() async {
      await db.incomeRecords.put(record);
    });
  }

  Future<void> updateIncomeRecord(IncomeRecord record) async {
    final totalServices = record.services.fold<int>(0, (sum, s) => sum + s.priceMinor);
    record.totalMinor = totalServices + (record.tipMinor);

    final db = await IsarService.instance.db;
    await db.writeTxn(() async {
      await db.incomeRecords.put(record);
    });
  }

  Future<void> deleteIncomeRecord(Id id) async {
    final db = await IsarService.instance.db;
    await db.writeTxn(() async {
      await db.incomeRecords.delete(id);
    });
  }

  Future<List<IncomeRecord>> getIncomeForDateRange(DateTime start, DateTime end) async {
    final db = await IsarService.instance.db;
    final from = DateTime(start.year, start.month, start.day);
    final to = DateTime(end.year, end.month, end.day, 23, 59, 59);
    return db.incomeRecords.filter().dateBetween(from, to).findAll();
  }
}

