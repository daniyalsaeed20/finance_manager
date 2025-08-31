// formatting.dart
// Currency and date formatting utilities

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import '../services/currency_service.dart';

// Legacy method - kept for backward compatibility
String formatCurrencyMinor(int minor, {String currencySymbol = '₦'}) {
  final n = minor / 100.0;
  final format = NumberFormat.currency(
    symbol: currencySymbol,
    decimalDigits: 2,
  );
  return format.format(n);
}

// New method using currency service
Future<String> formatCurrency(int minorAmount) async {
  return await CurrencyService.formatAmount(minorAmount);
}

// Method to create highlighted currency text widget
Widget formatCurrencyHighlighted(int minorAmount, {double? fontSize}) {
  return FutureBuilder<String>(
    future: formatCurrency(minorAmount),
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        return Text(
          snapshot.data!,
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
            fontSize:
                fontSize ?? Theme.of(context).textTheme.titleLarge?.fontSize,
          ),
        );
      }
      return const CircularProgressIndicator();
    },
  );
}

// Method to create highlighted currency text with custom style
Widget formatCurrencyWithStyle(
  int minorAmount, {
  TextStyle? style,
  double? fontSize,
  FontWeight? fontWeight,
}) {
  return FutureBuilder<String>(
    future: formatCurrency(minorAmount),
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        return Text(
          snapshot.data!,
          style:
              style?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: fontWeight ?? FontWeight.bold,
                fontSize: fontSize,
              ) ??
              TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: fontWeight ?? FontWeight.bold,
                fontSize:
                    fontSize ??
                    Theme.of(context).textTheme.titleLarge?.fontSize,
              ),
        );
      }
      return const CircularProgressIndicator();
    },
  );
}

String formatShortDate(DateTime date) {
  return DateFormat.yMMMd().format(date);
}

String formatMonthYear(DateTime date) {
  return DateFormat.yMMM().format(date);
}

String monthKeyFromDate(DateTime date) =>
    '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}';
