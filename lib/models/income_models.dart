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
}

@embedded
class IncomeServiceItem {
  late String serviceName;
  late int priceMinor;
}

@collection
class IncomeRecord {
  Id id = Isar.autoIncrement;

  // Use dateOnly (midnight) for grouping
  late DateTime date;

  // Optional number of clients served
  int? clientCount;

  // Selected services with prices captured at time of entry
  List<IncomeServiceItem> services = [];

  // Optional tip in minor units
  int tipMinor = 0;

  // Cached total for fast queries: sum(services.price) + tip
  int totalMinor = 0;

  String? note;
}

