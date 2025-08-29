// formatting.dart
// Currency and date formatting utilities

import 'package:intl/intl.dart';

String formatCurrencyMinor(int minor, {String currencySymbol = '₦'}) {
  final n = minor / 100.0;
  final format = NumberFormat.currency(
    symbol: currencySymbol,
    decimalDigits: 2,
  );
  return format.format(n);
}

String formatShortDate(DateTime date) {
  return DateFormat.yMMMd().format(date);
}

String formatMonthYear(DateTime date) {
  return DateFormat.yMMM().format(date);
}

String monthKeyFromDate(DateTime date) =>
    '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}';
