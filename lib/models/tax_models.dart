// tax_models.dart
// Defines tax planning and payment models using Isar.

import 'package:isar/isar.dart';

part 'tax_models.g.dart';

@collection
class TaxPlan {
  Id id = Isar.autoIncrement;
  late String periodKey; // e.g. 2025-01 for month or 2025-Q1 for quarter
  double estimatedRate = 0.0; // 0.0 to 1.0
  DateTime? dueDate;

  // User ID for data isolation
  late String userId;
}

@collection
class TaxPayment {
  Id id = Isar.autoIncrement;
  late DateTime date;
  late int amountMinor;
  String? method;
  String? note;

  // User ID for data isolation
  late String userId;
}
