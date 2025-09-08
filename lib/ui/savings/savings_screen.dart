import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../utils/formatting.dart';
import '../../repositories/income_repository.dart';
import '../../repositories/expense_repository.dart';
import '../../models/income_models.dart';
import '../../models/expense_models.dart';

class SavingsScreen extends StatefulWidget {
  const SavingsScreen({super.key});

  @override
  State<SavingsScreen> createState() => _SavingsScreenState();
}

class _SavingsScreenState extends State<SavingsScreen> {
  DateTime _selectedMonth = DateTime.now();
  late IncomeRepository _incomeRepo;
  late ExpenseRepository _expenseRepo;

  // Real data from repositories
  List<IncomeRecord> _incomeRecords = [];
  List<Expense> _expenses = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _incomeRepo = IncomeRepository();
    _expenseRepo = ExpenseRepository();
    _loadData();
  }

  Future<void> _loadData() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        setState(() {
          _error = 'User not authenticated';
          _isLoading = false;
        });
        return;
      }

      // Load all income and expense data for the user
      final allIncome = await _incomeRepo.getIncomeForDateRange(
        DateTime(2020, 1, 1), // Start from 2020
        DateTime.now().add(const Duration(days: 1)), // Up to today
        userId,
      );

      final allExpenses = await _expenseRepo.getExpensesForDateRange(
        DateTime(2020, 1, 1), // Start from 2020
        DateTime.now().add(const Duration(days: 1)), // Up to today
        userId,
      );

      if (mounted) {
        setState(() {
          _incomeRecords = allIncome;
          _expenses = allExpenses;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Error loading data: $e';
          _isLoading = false;
        });
      }
    }
  }

  // Calculate savings for a specific month
  Map<String, int> _calculateMonthlySavings(int year, int month) {
    final monthStart = DateTime(year, month, 1);
    final monthEnd = DateTime(year, month + 1, 0, 23, 59, 59);

    final monthIncome = _incomeRecords
        .where((record) {
          return record.date.isAfter(
                monthStart.subtract(const Duration(seconds: 1)),
              ) &&
              record.date.isBefore(monthEnd.add(const Duration(seconds: 1)));
        })
        .fold<int>(0, (sum, record) => sum + record.totalMinor);

    final monthExpenses = _expenses
        .where((expense) {
          return expense.date.isAfter(
                monthStart.subtract(const Duration(seconds: 1)),
              ) &&
              expense.date.isBefore(monthEnd.add(const Duration(seconds: 1)));
        })
        .fold<int>(0, (sum, expense) => sum + expense.amountMinor);

    final savings = (monthIncome - monthExpenses)
        .clamp(0, double.infinity)
        .toInt();

    return {
      'income': monthIncome,
      'expenses': monthExpenses,
      'savings': savings,
    };
  }

  // Get all-time totals
  Map<String, int> _getAllTimeTotals() {
    final totalIncome = _incomeRecords.fold<int>(
      0,
      (sum, record) => sum + record.totalMinor,
    );
    final totalExpenses = _expenses.fold<int>(
      0,
      (sum, expense) => sum + expense.amountMinor,
    );
    final totalSavings = (totalIncome - totalExpenses)
        .clamp(0, double.infinity)
        .toInt();

    return {
      'income': totalIncome,
      'expenses': totalExpenses,
      'savings': totalSavings,
    };
  }

  // Get savings history for the last 12 months
  List<Map<String, dynamic>> _getSavingsHistory() {
    final now = DateTime.now();
    final List<Map<String, dynamic>> history = [];

    for (int i = 11; i >= 0; i--) {
      final month = now.month - i;
      final year = now.year;
      final adjustedMonth = month <= 0 ? month + 12 : month;
      final adjustedYear = month <= 0 ? year - 1 : year;

      final monthData = _calculateMonthlySavings(adjustedYear, adjustedMonth);
      final monthKey =
          '${adjustedYear}-${adjustedMonth.toString().padLeft(2, '0')}';

      history.add({
        'monthKey': monthKey,
        'year': adjustedYear,
        'month': adjustedMonth,
        'income': monthData['income']!,
        'expenses': monthData['expenses']!,
        'savings': monthData['savings']!,
      });
    }

    return history;
  }

  @override
  Widget build(BuildContext context) {
    final currentMonthData = _calculateMonthlySavings(
      _selectedMonth.year,
      _selectedMonth.month,
    );
    final allTimeData = _getAllTimeTotals();
    final savingsHistory = _getSavingsHistory();

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Savings Analytics')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Savings Analytics')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(_error!, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 16),
              ElevatedButton(onPressed: _loadData, child: const Text('Retry')),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Savings Analytics'),
        actions: [
          IconButton(
            onPressed: _loadData,
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh Data',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Month selector
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _selectedMonth = DateTime(
                          _selectedMonth.year,
                          _selectedMonth.month - 1,
                        );
                      });
                    },
                    icon: const Icon(Icons.chevron_left),
                  ),
                  TextButton(
                    onPressed: () => _selectMonth(),
                    child: Text(formatMonthYear(_selectedMonth)),
                  ),
                  IconButton(
                    onPressed: _selectedMonth.isBefore(DateTime.now())
                        ? () {
                            setState(() {
                              _selectedMonth = DateTime(
                                _selectedMonth.year,
                                _selectedMonth.month + 1,
                              );
                            });
                          }
                        : null,
                    icon: const Icon(Icons.chevron_right),
                  ),
                ],
              ),
            ),

            // Savings Overview
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  // Monthly Savings Card
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Monthly Savings',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            formatCurrencySync(currentMonthData['savings']!),
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildSavingsDetail(
                                'Income',
                                currentMonthData['income']!,
                                Theme.of(context).colorScheme.tertiary,
                              ),
                              _buildSavingsDetail(
                                'Expenses',
                                currentMonthData['expenses']!,
                                Theme.of(context).colorScheme.error,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // All-Time Savings Card
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'All-Time Savings',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            formatCurrencySync(allTimeData['savings']!),
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.secondary,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildSavingsDetail(
                                'Total Income',
                                allTimeData['income']!,
                                Theme.of(context).colorScheme.tertiary,
                              ),
                              _buildSavingsDetail(
                                'Total Expenses',
                                allTimeData['expenses']!,
                                Theme.of(context).colorScheme.error,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Savings History Chart
                  if (savingsHistory.isNotEmpty) ...[
                    Text(
                      'Savings History (Last 12 Months)',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 200,
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: _buildSavingsHistoryChart(savingsHistory),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Monthly Breakdown Cards
                  Text(
                    'Monthly Breakdown',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  ...savingsHistory.map((monthData) {
                    return _buildMonthCard(monthData);
                  }).toList(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSavingsDetail(String label, int amount, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
        Text(
          formatCurrencySync(amount),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildSavingsHistoryChart(List<Map<String, dynamic>> history) {
    final spots = history.asMap().entries.map((entry) {
      final index = entry.key;
      final data = entry.value;
      return FlSpot(index.toDouble(), data['savings'].toDouble());
    }).toList();

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          horizontalInterval: _calculateMaxY(history) / 4,
          verticalInterval: 1,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Theme.of(
                context,
              ).colorScheme.outline.withValues(alpha: 0.3),
              strokeWidth: 1,
            );
          },
          getDrawingVerticalLine: (value) {
            return FlLine(
              color: Theme.of(
                context,
              ).colorScheme.outline.withValues(alpha: 0.3),
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (value, meta) {
                if (value.toInt() < history.length) {
                  final monthKey = history[value.toInt()]['monthKey'];
                  final parts = monthKey.split('-');
                  return Text(
                    '${parts[1]}/${parts[0].substring(2)}',
                    style: Theme.of(context).textTheme.bodySmall,
                  );
                }
                return const Text('');
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                return Text(
                  formatCurrencySync(value.toInt()),
                  style: Theme.of(context).textTheme.bodySmall,
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: Theme.of(context).colorScheme.primary,
            barWidth: 3,
            dotData: FlDotData(show: true),
            belowBarData: BarAreaData(
              show: true,
              color: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.1),
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            tooltipRoundedRadius: 8,
            tooltipPadding: const EdgeInsets.all(8),
            tooltipMargin: 8,
            getTooltipColor: (touchedSpot) =>
                Theme.of(context).colorScheme.surface,
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((touchedSpot) {
                final monthData = history[touchedSpot.x.toInt()];
                return LineTooltipItem(
                  '${monthData['monthKey']}\n${formatCurrencySync(monthData['savings'])}',
                  TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                );
              }).toList();
            },
          ),
        ),
      ),
    );
  }

  int _calculateMaxY(List<Map<String, dynamic>> data) {
    if (data.isEmpty) return 1000;

    final maxValue = data
        .map((entry) => entry['savings'] as int)
        .reduce((a, b) => a > b ? a : b);

    // Round up to the next nice number for better chart scaling
    if (maxValue <= 1000) return maxValue;
    if (maxValue <= 10000) return ((maxValue / 1000).ceil() * 1000);
    if (maxValue <= 100000) return ((maxValue / 10000).ceil() * 10000);
    return ((maxValue / 100000).ceil() * 100000);
  }

  Widget _buildMonthCard(Map<String, dynamic> monthData) {
    final monthKey = monthData['monthKey'];
    final parts = monthKey.split('-');
    final monthName = _getMonthName(int.parse(parts[1]));
    final year = parts[0];
    final income = monthData['income'] as int;
    final expenses = monthData['expenses'] as int;
    final savings = monthData['savings'] as int;

    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Month name
            Expanded(
              flex: 2,
              child: Text(
                '$monthName $year',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),

            // Income
            Expanded(
              child: _buildCompactDataItem(
                formatCurrencySync(income),
                Theme.of(context).colorScheme.tertiary,
                Icons.trending_up,
              ),
            ),

            // Expenses
            Expanded(
              child: _buildCompactDataItem(
                formatCurrencySync(expenses),
                Theme.of(context).colorScheme.error,
                Icons.trending_down,
              ),
            ),

            // Savings
            Expanded(
              child: _buildCompactDataItem(
                formatCurrencySync(savings),
                Theme.of(context).colorScheme.primary,
                Icons.savings,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactDataItem(String amount, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: color.withValues(alpha: 0.2), width: 1),
      ),
      child: Column(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(height: 4),
          Text(
            amount,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }

  Future<void> _selectMonth() async {
    final now = DateTime.now();
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _selectedMonth,
      firstDate: DateTime(2020, 1, 1),
      lastDate: now,
      initialDatePickerMode: DatePickerMode.year,
    );

    if (selectedDate != null && mounted) {
      setState(() {
        _selectedMonth = selectedDate;
      });
    }
  }

  @override
  void dispose() {
    _incomeRepo.dispose();
    _expenseRepo.dispose();
    super.dispose();
  }
}
