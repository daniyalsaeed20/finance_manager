// amount_input_formatter.dart
// Custom input formatter for currency amounts

import 'package:flutter/services.dart';

class AmountInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Remove any non-digit characters except decimal point
    String filtered = newValue.text.replaceAll(RegExp(r'[^\d.]'), '');
    
    // Ensure only one decimal point
    if (filtered.split('.').length > 2) {
      filtered = oldValue.text;
    }
    
    // Limit to 2 decimal places
    if (filtered.contains('.')) {
      final parts = filtered.split('.');
      if (parts.length == 2 && parts[1].length > 2) {
        filtered = '${parts[0]}.${parts[1].substring(0, 2)}';
      }
    }
    
    // Don't allow decimal point at the beginning
    if (filtered.startsWith('.')) {
      filtered = '0$filtered';
    }
    
    // Don't allow multiple zeros at the beginning (e.g., 00123)
    if (filtered.length > 1 && filtered.startsWith('0') && !filtered.startsWith('0.')) {
      filtered = filtered.substring(1);
    }
    
    // If empty, return empty
    if (filtered.isEmpty) {
      return newValue.copyWith(text: '');
    }
    
    // Format the number with proper decimal places
    double? number = double.tryParse(filtered);
    if (number != null) {
      // Format to always show 2 decimal places
      String formatted = number.toStringAsFixed(2);
      
      // Remove trailing zeros after decimal point if they're not needed
      if (formatted.endsWith('.00')) {
        formatted = formatted.substring(0, formatted.length - 3);
      } else if (formatted.endsWith('0')) {
        formatted = formatted.substring(0, formatted.length - 1);
      }
      
      return newValue.copyWith(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }
    
    return newValue.copyWith(text: filtered);
  }
}

// Alternative formatter that allows typing and formats on blur
class AmountInputFormatterLoose extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Remove any non-digit characters except decimal point
    String filtered = newValue.text.replaceAll(RegExp(r'[^\d.]'), '');
    
    // Ensure only one decimal point
    if (filtered.split('.').length > 2) {
      filtered = oldValue.text;
    }
    
    // Don't allow decimal point at the beginning
    if (filtered.startsWith('.')) {
      filtered = '0$filtered';
    }
    
    // Don't allow multiple zeros at the beginning (e.g., 00123)
    if (filtered.length > 1 && filtered.startsWith('0') && !filtered.startsWith('0.')) {
      filtered = filtered.substring(0, 1);
    }
    
    return newValue.copyWith(text: filtered);
  }
}

// Helper function to format amount on blur/focus out
String formatAmountOnBlur(String input) {
  if (input.isEmpty) return '';
  
  // Parse the input
  double? number = double.tryParse(input);
  if (number == null) return input;
  
  // Format to 2 decimal places
  return number.toStringAsFixed(2);
}
