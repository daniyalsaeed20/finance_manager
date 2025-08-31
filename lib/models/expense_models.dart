// expense_models.dart
// Defines models for expense categories and expenses using Isar.

import 'package:isar/isar.dart';

part 'expense_models.g.dart';

@collection
class ExpenseCategory {
  Id id = Isar.autoIncrement;
  late String name;
  // ARGB color integer
  int? color;
  String? iconName;
  int sortOrder = 0;

  // User ID for data isolation
  late String userId;
}

@collection
class Expense {
  Id id = Isar.autoIncrement;

  late DateTime date;
  late int categoryId;
  late int amountMinor; // currency minor units
  String? vendor;
  String? note;

  // User ID for data isolation
  late String userId;
}
