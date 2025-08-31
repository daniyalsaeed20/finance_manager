// currency_service.dart
// Manages user currency preferences and provides currency data

import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class CurrencyService {
  static const String _currencyKey = 'user_currency';
  
  // Comprehensive list of currencies with symbols and names
  static const List<Currency> _currencies = [
    Currency(code: 'USD', symbol: '\$', name: 'US Dollar'),
    Currency(code: 'EUR', symbol: '€', name: 'Euro'),
    Currency(code: 'GBP', symbol: '£', name: 'British Pound'),
    Currency(code: 'JPY', symbol: '¥', name: 'Japanese Yen'),
    Currency(code: 'CAD', symbol: 'C\$', name: 'Canadian Dollar'),
    Currency(code: 'AUD', symbol: 'A\$', name: 'Australian Dollar'),
    Currency(code: 'CHF', symbol: 'CHF', name: 'Swiss Franc'),
    Currency(code: 'CNY', symbol: '¥', name: 'Chinese Yuan'),
    Currency(code: 'INR', symbol: '₹', name: 'Indian Rupee'),
    Currency(code: 'BRL', symbol: 'R\$', name: 'Brazilian Real'),
    Currency(code: 'RUB', symbol: '₽', name: 'Russian Ruble'),
    Currency(code: 'KRW', symbol: '₩', name: 'South Korean Won'),
    Currency(code: 'MXN', symbol: '\$', name: 'Mexican Peso'),
    Currency(code: 'SGD', symbol: 'S\$', name: 'Singapore Dollar'),
    Currency(code: 'HKD', symbol: 'HK\$', name: 'Hong Kong Dollar'),
    Currency(code: 'NZD', symbol: 'NZ\$', name: 'New Zealand Dollar'),
    Currency(code: 'SEK', symbol: 'kr', name: 'Swedish Krona'),
    Currency(code: 'NOK', symbol: 'kr', name: 'Norwegian Krone'),
    Currency(code: 'DKK', symbol: 'kr', name: 'Danish Krone'),
    Currency(code: 'PLN', symbol: 'zł', name: 'Polish Złoty'),
    Currency(code: 'CZK', symbol: 'Kč', name: 'Czech Koruna'),
    Currency(code: 'HUF', symbol: 'Ft', name: 'Hungarian Forint'),
    Currency(code: 'RON', symbol: 'lei', name: 'Romanian Leu'),
    Currency(code: 'BGN', symbol: 'лв', name: 'Bulgarian Lev'),
    Currency(code: 'HRK', symbol: 'kn', name: 'Croatian Kuna'),
    Currency(code: 'TRY', symbol: '₺', name: 'Turkish Lira'),
    Currency(code: 'ILS', symbol: '₪', name: 'Israeli Shekel'),
    Currency(code: 'ZAR', symbol: 'R', name: 'South African Rand'),
    Currency(code: 'THB', symbol: '฿', name: 'Thai Baht'),
    Currency(code: 'MYR', symbol: 'RM', name: 'Malaysian Ringgit'),
    Currency(code: 'IDR', symbol: 'Rp', name: 'Indonesian Rupiah'),
    Currency(code: 'PHP', symbol: '₱', name: 'Philippine Peso'),
    Currency(code: 'VND', symbol: '₫', name: 'Vietnamese Dong'),
    Currency(code: 'EGP', symbol: 'E£', name: 'Egyptian Pound'),
    Currency(code: 'NGN', symbol: '₦', name: 'Nigerian Naira'),
    Currency(code: 'KES', symbol: 'KSh', name: 'Kenyan Shilling'),
    Currency(code: 'GHS', symbol: 'GH₵', name: 'Ghanaian Cedi'),
    Currency(code: 'UGX', symbol: 'USh', name: 'Ugandan Shilling'),
    Currency(code: 'TZS', symbol: 'TSh', name: 'Tanzanian Shilling'),
    Currency(code: 'ZMW', symbol: 'ZK', name: 'Zambian Kwacha'),
    Currency(code: 'BWP', symbol: 'P', name: 'Botswana Pula'),
    Currency(code: 'NAD', symbol: 'N\$', name: 'Namibian Dollar'),
    Currency(code: 'MUR', symbol: '₨', name: 'Mauritian Rupee'),
    Currency(code: 'LKR', symbol: '₨', name: 'Sri Lankan Rupee'),
    Currency(code: 'BDT', symbol: '৳', name: 'Bangladeshi Taka'),
    Currency(code: 'PKR', symbol: '₨', name: 'Pakistani Rupee'),
    Currency(code: 'AFN', symbol: '؋', name: 'Afghan Afghani'),
    Currency(code: 'IRR', symbol: '﷼', name: 'Iranian Rial'),
    Currency(code: 'IQD', symbol: 'ع.د', name: 'Iraqi Dinar'),
    Currency(code: 'SAR', symbol: '﷼', name: 'Saudi Riyal'),
    Currency(code: 'AED', symbol: 'د.إ', name: 'UAE Dirham'),
    Currency(code: 'QAR', symbol: 'ر.ق', name: 'Qatari Riyal'),
    Currency(code: 'KWD', symbol: 'د.ك', name: 'Kuwaiti Dinar'),
    Currency(code: 'BHD', symbol: '.د.ب', name: 'Bahraini Dinar'),
    Currency(code: 'OMR', symbol: 'ر.ع.', name: 'Omani Rial'),
    Currency(code: 'JOD', symbol: 'د.ا', name: 'Jordanian Dinar'),
    Currency(code: 'LBP', symbol: 'ل.ل', name: 'Lebanese Pound'),
    Currency(code: 'SYP', symbol: 'ل.س', name: 'Syrian Pound'),
    Currency(code: 'YER', symbol: '﷼', name: 'Yemeni Rial'),
    Currency(code: 'KHR', symbol: '៛', name: 'Cambodian Riel'),
    Currency(code: 'LAK', symbol: '₭', name: 'Lao Kip'),
    Currency(code: 'MMK', symbol: 'K', name: 'Myanmar Kyat'),
    Currency(code: 'MNT', symbol: '₮', name: 'Mongolian Tugrik'),
    Currency(code: 'UZS', symbol: 'so\'m', name: 'Uzbekistani Som'),
    Currency(code: 'KZT', symbol: '₸', name: 'Kazakhstani Tenge'),
    Currency(code: 'AZN', symbol: '₼', name: 'Azerbaijani Manat'),
    Currency(code: 'GEL', symbol: '₾', name: 'Georgian Lari'),
    Currency(code: 'AMD', symbol: '֏', name: 'Armenian Dram'),
    Currency(code: 'BYN', symbol: 'Br', name: 'Belarusian Ruble'),
    Currency(code: 'MDL', symbol: 'L', name: 'Moldovan Leu'),
    Currency(code: 'UAH', symbol: '₴', name: 'Ukrainian Hryvnia'),
    Currency(code: 'RSD', symbol: 'дин.', name: 'Serbian Dinar'),
    Currency(code: 'BAM', symbol: 'KM', name: 'Bosnia-Herzegovina Convertible Mark'),
    Currency(code: 'ALL', symbol: 'L', name: 'Albanian Lek'),
    Currency(code: 'MKD', symbol: 'ден', name: 'Macedonian Denar'),
    Currency(code: 'XOF', symbol: 'CFA', name: 'West African CFA Franc'),
    Currency(code: 'XAF', symbol: 'CFA', name: 'Central African CFA Franc'),
    Currency(code: 'XPF', symbol: 'CFP', name: 'CFP Franc'),
    Currency(code: 'CLP', symbol: '\$', name: 'Chilean Peso'),
    Currency(code: 'COP', symbol: '\$', name: 'Colombian Peso'),
    Currency(code: 'PEN', symbol: 'S/', name: 'Peruvian Sol'),
    Currency(code: 'ARS', symbol: '\$', name: 'Argentine Peso'),
    Currency(code: 'UYU', symbol: '\$', name: 'Uruguayan Peso'),
    Currency(code: 'PYG', symbol: '₲', name: 'Paraguayan Guaraní'),
    Currency(code: 'BOB', symbol: 'Bs', name: 'Bolivian Boliviano'),
    Currency(code: 'GTQ', symbol: 'Q', name: 'Guatemalan Quetzal'),
    Currency(code: 'HNL', symbol: 'L', name: 'Honduran Lempira'),
    Currency(code: 'NIO', symbol: 'C\$', name: 'Nicaraguan Córdoba'),
    Currency(code: 'CRC', symbol: '₡', name: 'Costa Rican Colón'),
    Currency(code: 'PAB', symbol: 'B/.', name: 'Panamanian Balboa'),
    Currency(code: 'DOP', symbol: 'RD\$', name: 'Dominican Peso'),
    Currency(code: 'JMD', symbol: 'J\$', name: 'Jamaican Dollar'),
    Currency(code: 'TTD', symbol: 'TT\$', name: 'Trinidad and Tobago Dollar'),
    Currency(code: 'BBD', symbol: 'B\$', name: 'Barbadian Dollar'),
    Currency(code: 'BZD', symbol: 'BZ\$', name: 'Belize Dollar'),
    Currency(code: 'GYD', symbol: 'G\$', name: 'Guyanese Dollar'),
    Currency(code: 'SRD', symbol: '\$', name: 'Surinamese Dollar'),
    Currency(code: 'FJD', symbol: 'FJ\$', name: 'Fijian Dollar'),
    Currency(code: 'WST', symbol: 'T', name: 'Samoan Tālā'),
    Currency(code: 'TOP', symbol: 'T\$', name: 'Tongan Paʻanga'),
    Currency(code: 'VUV', symbol: 'VT', name: 'Vanuatu Vatu'),
    Currency(code: 'SBD', symbol: 'SI\$', name: 'Solomon Islands Dollar'),
    Currency(code: 'PGK', symbol: 'K', name: 'Papua New Guinean Kina'),
    Currency(code: 'KID', symbol: '\$', name: 'Kiribati Dollar'),
    Currency(code: 'TVD', symbol: 'TVD', name: 'Tuvaluan Dollar'),
    Currency(code: 'NPR', symbol: '₨', name: 'Nepalese Rupee'),
    Currency(code: 'BTN', symbol: 'Nu.', name: 'Bhutanese Ngultrum'),
    Currency(code: 'MVR', symbol: 'MVR', name: 'Maldivian Rufiyaa'),
    Currency(code: 'SCR', symbol: '₨', name: 'Seychellois Rupee'),
    Currency(code: 'DJF', symbol: 'Fdj', name: 'Djiboutian Franc'),
    Currency(code: 'ETB', symbol: 'Br', name: 'Ethiopian Birr'),
    Currency(code: 'SOS', symbol: 'S', name: 'Somali Shilling'),
    Currency(code: 'SDG', symbol: 'ج.س.', name: 'Sudanese Pound'),
    Currency(code: 'LYD', symbol: 'ل.د', name: 'Libyan Dinar'),
    Currency(code: 'TND', symbol: 'د.ت', name: 'Tunisian Dinar'),
    Currency(code: 'DZD', symbol: 'د.ج', name: 'Algerian Dinar'),
    Currency(code: 'MAD', symbol: 'د.م.', name: 'Moroccan Dirham'),
    Currency(code: 'CVE', symbol: '\$', name: 'Cape Verdean Escudo'),
    Currency(code: 'GMD', symbol: 'D', name: 'Gambian Dalasi'),
    Currency(code: 'GNF', symbol: 'FG', name: 'Guinean Franc'),
    Currency(code: 'SLL', symbol: 'Le', name: 'Sierra Leonean Leone'),
    Currency(code: 'LRD', symbol: 'L\$', name: 'Liberian Dollar'),
    Currency(code: 'CDF', symbol: 'FC', name: 'Congolese Franc'),
    Currency(code: 'RWF', symbol: 'FRw', name: 'Rwandan Franc'),
    Currency(code: 'BIF', symbol: 'FBu', name: 'Burundian Franc'),
    Currency(code: 'KMF', symbol: 'CF', name: 'Comorian Franc'),
    Currency(code: 'MGA', symbol: 'Ar', name: 'Malagasy Ariary'),
    Currency(code: 'MZN', symbol: 'MT', name: 'Mozambican Metical'),
    Currency(code: 'MWK', symbol: 'MK', name: 'Malawian Kwacha'),
    Currency(code: 'ZWL', symbol: 'Z\$', name: 'Zimbabwean Dollar'),
    Currency(code: 'STD', symbol: 'Db', name: 'São Tomé and Príncipe Dobra'),
    Currency(code: 'AOA', symbol: 'Kz', name: 'Angolan Kwanza'),
    Currency(code: 'MOP', symbol: 'MOP\$', name: 'Macanese Pataca'),
    Currency(code: 'TWD', symbol: 'NT\$', name: 'New Taiwan Dollar'),
  ];

  // Get all currencies
  static List<Currency> get allCurrencies => _currencies;

  // Search currencies by name or code
  static List<Currency> searchCurrencies(String query) {
    if (query.isEmpty) return _currencies;
    
    final lowercaseQuery = query.toLowerCase();
    return _currencies.where((currency) {
      return currency.name.toLowerCase().contains(lowercaseQuery) ||
             currency.code.toLowerCase().contains(lowercaseQuery) ||
             currency.symbol.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }

  // Get user's selected currency
  static Future<Currency> getUserCurrency() async {
    final prefs = await SharedPreferences.getInstance();
    final currencyCode = prefs.getString(_currencyKey) ?? 'USD';
    return _currencies.firstWhere(
      (currency) => currency.code == currencyCode,
      orElse: () => _currencies.firstWhere((currency) => currency.code == 'USD'),
    );
  }

  // Set user's selected currency
  static Future<void> setUserCurrency(String currencyCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currencyKey, currencyCode);
  }

  // Format amount with user's selected currency
  static Future<String> formatAmount(int minorAmount) async {
    final currency = await getUserCurrency();
    final amount = minorAmount / 100.0;
    
    final format = NumberFormat.currency(
      symbol: currency.symbol,
      decimalDigits: 2,
      locale: 'en_US', // Use English locale for consistent formatting
    );
    
    return format.format(amount);
  }

  // Format amount with specific currency
  static String formatAmountWithCurrency(int minorAmount, Currency currency) {
    final amount = minorAmount / 100.0;
    
    final format = NumberFormat.currency(
      symbol: currency.symbol,
      decimalDigits: 2,
      locale: 'en_US',
    );
    
    return format.format(amount);
  }
}

class Currency {
  final String code;
  final String symbol;
  final String name;

  const Currency({
    required this.code,
    required this.symbol,
    required this.name,
  });

  @override
  String toString() => '$code - $name ($symbol)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Currency &&
          runtimeType == other.runtimeType &&
          code == other.code;

  @override
  int get hashCode => code.hashCode;
}
