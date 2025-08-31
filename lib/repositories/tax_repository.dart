// tax_repository.dart
// Manage tax plans and tax payments

import 'package:isar/isar.dart';

import '../models/tax_models.dart';
import '../services/isar_service.dart';

class TaxRepository {
  Future<void> upsertPlan(TaxPlan plan) async {
    final db = await IsarService.instance.db;
    await db.writeTxn(() async {
      await db.taxPlans.put(plan);
    });
  }

  Future<List<TaxPlan>> getPlans(String userId) async {
    final db = await IsarService.instance.db;
    return db.taxPlans.filter().userIdEqualTo(userId).findAll();
  }

  Future<void> deletePlan(Id id) async {
    final db = await IsarService.instance.db;
    await db.writeTxn(() async {
      await db.taxPlans.delete(id);
    });
  }

  Future<void> addPayment(TaxPayment payment) async {
    final db = await IsarService.instance.db;
    await db.writeTxn(() async {
      await db.taxPayments.put(payment);
    });
  }

  Future<List<TaxPayment>> getPayments(String userId) async {
    final db = await IsarService.instance.db;
    return db.taxPayments.filter().userIdEqualTo(userId).findAll();
  }

  Future<void> deletePayment(Id id) async {
    final db = await IsarService.instance.db;
    await db.writeTxn(() async {
      await db.taxPayments.delete(id);
    });
  }
}
