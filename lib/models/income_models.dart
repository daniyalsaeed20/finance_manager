// income_models.dart
// Defines models for services and income records using Isar for local storage.

import 'package:isar/isar.dart';

part 'income_models.g.dart';

@collection
class ServiceTemplate {
  // Isar auto-increment id
  Id id = Isar.autoIncrement;

  late String name;
  // Store currency amount in minor units (cents) to avoid floating precision
  late int defaultPriceMinor;
  bool active = true;
  int sortOrder = 0;

  // User ID for data isolation
  late String userId;
}

@embedded
class IncomeServiceCount {
  late String serviceName;
  late int priceMinor;
  late int count; // Number of times this service was provided
}

@collection
class IncomeRecord {
  Id id = Isar.autoIncrement;

  // Use dateOnly (midnight) for grouping
  late DateTime date;

  // Selected services with prices captured at time of entry and counts
  List<IncomeServiceCount> services = [];

  // Optional tip in minor units
  int tipMinor = 0;

  // Cached total for fast queries: sum(services.price * count) + tip
  int totalMinor = 0;

  String? note;

  // User ID for data isolation
  late String userId;
}
