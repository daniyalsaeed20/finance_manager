import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fl_chart/fl_chart.dart';

import '../../cubits/dashboard_cubit.dart';
import '../../models/expense_models.dart';
import '../../repositories/expense_repository.dart';
import '../../repositories/income_repository.dart';
import '../../repositories/goal_repository.dart';
import '../../services/export_service.dart';
import '../../services/user_manager.dart';
import '../../utils/formatting.dart';
import 'package:go_router/go_router.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  DateTimeRange? _range;
  double _taxRate = 15.0; // Default tax rate as per MVP
  late DashboardCubit _dashboardCubit;

  @override
  void initState() {
    super.initState();

    // Initialize the dashboard cubit
    _dashboardCubit = DashboardCubit(
      incomeRepo: IncomeRepository(),
      expenseRepo: ExpenseRepository(),
      goalRepo: GoalRepository(),
    );

    // Set default range to current month
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = _getEndOfMonth(now);

    _range = DateTimeRange(start: startOfMonth, end: endOfMonth);

    print('🔍 Reports: Setting date range in initState');
    print('🔍 Reports: Current date: $now');
    print('🔍 Reports: Range start: ${_range!.start}');
    print('🔍 Reports: Range end: ${_range!.end}');
    print(
      '🔍 Reports: DashboardCubit created with hash: ${_dashboardCubit.hashCode}',
    );

    // Load data after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _loadDataForRange();
      }
    });
  }

  DateTime _getEndOfMonth(DateTime date) {
    // Get the first day of the next month, then subtract 1 day
    final nextMonth = DateTime(date.year, date.month + 1, 1);
    final endOfMonth = nextMonth.subtract(const Duration(seconds: 1));
    return endOfMonth;
  }

  int _calculateMaxY(
    int income,
    int expenses,
    int netProfit,
    int afterTaxProfit,
  ) {
    final maxValue = [
      income,
      expenses,
      netProfit.abs(),
      afterTaxProfit.abs(),
    ].reduce((a, b) => a > b ? a : b);
    // Round up to the next nice number for better chart scaling
    if (maxValue <= 1000) return maxValue;
    if (maxValue <= 10000) return ((maxValue / 1000).ceil() * 1000);
    if (maxValue <= 100000) return ((maxValue / 10000).ceil() * 10000);
    return ((maxValue / 100000).ceil() * 100000);
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _dashboardCubit.close();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // We'll load data after the widget is built and the cubit is available
  }

  void _loadDataForRange() {
    if (_range != null) {
      final userId = UserManager.instance.currentUserId;
      print(
        '🔍 Reports: Loading data for range: ${_range!.start} to ${_range!.end}',
      );
      print(
        '🔍 Reports: Start date details: year=${_range!.start.year}, month=${_range!.start.month}, day=${_range!.start.day}',
      );
      print(
        '🔍 Reports: End date details: year=${_range!.end.year}, month=${_range!.end.month}, day=${_range!.end.day}',
      );
      print('🔍 Reports: User ID: $userId');
      print(
        '🔍 Reports: Firebase current user: ${FirebaseAuth.instance.currentUser?.uid}',
      );
      print(
        '🔍 Reports: UserManager isSignedIn: ${UserManager.instance.isSignedIn}',
      );

      // Use the instance variable directly
      print('🔍 Reports: About to call loadForRange on DashboardCubit');
      print('🔍 Reports: DashboardCubit instance: ${_dashboardCubit.hashCode}');
      _dashboardCubit.loadForRange(_range!.start, _range!.end, userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _dashboardCubit,
      child: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () {
                      if (_range != null) {
                        _loadDataForRange();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Reports refreshed!'),
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.primary,
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.refresh),
                    tooltip: 'Refresh Reports',
                  ),
                ],
              ),
              Text(
                'Select date range',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: () async {
                  final now = DateTime.now();
                  final picked = await showDateRangePicker(
                    context: context,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(now.year + 1),
                    initialDateRange: DateTimeRange(
                      start: DateTime(now.year, now.month, 1),
                      end: _getEndOfMonth(now),
                    ),
                  );
                  if (picked != null) {
                    setState(() => _range = picked);
                    // Load data for the selected range
                    _loadDataForRange();
                  }
                },
                icon: const Icon(Icons.calendar_today),
                label: Text(
                  _range == null
                      ? 'Choose range'
                      : '${formatShortDate(_range!.start)} - ${formatShortDate(_range!.end)}',
                ),
              ),
              const SizedBox(height: 16),

              // Tax Rate Configuration
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tax Rate Configuration',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: Slider(
                              value: _taxRate,
                              min: 0.0,
                              max: 50.0,
                              divisions: 50,
                              label: '${_taxRate.toStringAsFixed(1)}%',
                              onChanged: (value) {
                                setState(() {
                                  _taxRate = value;
                                });
                              },
                              activeColor: Theme.of(
                                context,
                              ).colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            '${_taxRate.toStringAsFixed(1)}%',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Summary Cards
              if (_range != null) ...[
                BlocBuilder<DashboardCubit, DashboardState>(
                  builder: (context, state) {
                    if (state.loading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final estimatedTax = (state.netMinor * _taxRate / 100)
                        .round();
                    final afterTaxProfit = state.netMinor - estimatedTax;

                    return Column(
                      children: [
                        // First row: Income and Expenses
                        Row(
                          children: [
                            Expanded(
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    children: [
                                      Text(
                                        'Income',
                                        style: Theme.of(
                                          context,
                                        ).textTheme.labelMedium,
                                      ),
                                      Text(
                                        formatCurrencySync(
                                          state.totalIncomeMinor,
                                        ),
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge
                                            ?.copyWith(
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.tertiary,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    children: [
                                      Text(
                                        'Expenses',
                                        style: Theme.of(
                                          context,
                                        ).textTheme.labelMedium,
                                      ),
                                      Text(
                                        formatCurrencySync(
                                          state.totalExpenseMinor,
                                        ),
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge
                                            ?.copyWith(
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.error,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // Second row: Net Profit and After Tax Profit
                        Row(
                          children: [
                            Expanded(
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    children: [
                                      Text(
                                        'Net Profit',
                                        style: Theme.of(
                                          context,
                                        ).textTheme.labelMedium,
                                      ),
                                      Text(
                                        formatCurrencySync(state.netMinor),
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge
                                            ?.copyWith(
                                              color: state.netMinor < 0
                                                  ? Theme.of(
                                                      context,
                                                    ).colorScheme.error
                                                  : Theme.of(
                                                      context,
                                                    ).colorScheme.primary,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    children: [
                                      Text(
                                        'After Tax',
                                        style: Theme.of(
                                          context,
                                        ).textTheme.labelMedium,
                                      ),
                                      Text(
                                        formatCurrencySync(afterTaxProfit),
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge
                                            ?.copyWith(
                                              color: afterTaxProfit < 0
                                                  ? Theme.of(
                                                      context,
                                                    ).colorScheme.error
                                                  : Theme.of(
                                                      context,
                                                    ).colorScheme.secondary,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),
                      ],
                    );
                  },
                ),
                // Charts Section
                if (_range != null) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Financial Trends',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        'Tax Rate: ${_taxRate.toStringAsFixed(1)}%',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 200,
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: BlocBuilder<DashboardCubit, DashboardState>(
                          key: ValueKey('chart_${_taxRate.toStringAsFixed(1)}'),
                          builder: (context, state) {
                            if (state.loading) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            final income = state.totalIncomeMinor;
                            final expenses = state.totalExpenseMinor;
                            final netProfit = state.netMinor;
                            final estimatedTax = (netProfit * _taxRate / 100)
                                .round();
                            final afterTaxProfit = netProfit - estimatedTax;

                            if (income == 0 && expenses == 0) {
                              return const Center(
                                child: Text(
                                  'No data available for this period',
                                ),
                              );
                            }

                            return LineChart(
                              LineChartData(
                                gridData: FlGridData(
                                  show: true,
                                  drawVerticalLine: true,
                                  horizontalInterval:
                                      _calculateMaxY(
                                        income,
                                        expenses,
                                        netProfit,
                                        afterTaxProfit,
                                      ) /
                                      4,
                                  verticalInterval: 1,
                                  getDrawingHorizontalLine: (value) {
                                    return FlLine(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.outline.withOpacity(0.3),
                                      strokeWidth: 1,
                                    );
                                  },
                                  getDrawingVerticalLine: (value) {
                                    return FlLine(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.outline.withOpacity(0.3),
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
                                        switch (value.toInt()) {
                                          case 0:
                                            return Text(
                                              'Inc',
                                              style: TextStyle(
                                                fontSize: 10,
                                                color: Theme.of(
                                                  context,
                                                ).colorScheme.onSurface,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            );
                                          case 1:
                                            return Text(
                                              'Exp',
                                              style: TextStyle(
                                                fontSize: 10,
                                                color: Theme.of(
                                                  context,
                                                ).colorScheme.onSurface,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            );
                                          case 2:
                                            return Text(
                                              'Net',
                                              style: TextStyle(
                                                fontSize: 10,
                                                color: Theme.of(
                                                  context,
                                                ).colorScheme.onSurface,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            );
                                          case 3:
                                            return Text(
                                              'Tax',
                                              style: TextStyle(
                                                fontSize: 10,
                                                color: Theme.of(
                                                  context,
                                                ).colorScheme.onSurface,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            );
                                          default:
                                            return const Text('');
                                        }
                                      },
                                    ),
                                  ),
                                  leftTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      interval:
                                          _calculateMaxY(
                                            income,
                                            expenses,
                                            netProfit,
                                            afterTaxProfit,
                                          ) /
                                          4,
                                      reservedSize: 50,
                                      getTitlesWidget: (value, meta) {
                                        return Text(
                                          formatCurrencySync(value.toInt()),
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.onSurface,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                borderData: FlBorderData(
                                  show: true,
                                  border: Border.all(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.outline.withOpacity(0.3),
                                  ),
                                ),
                                minX: 0,
                                maxX: 3,
                                minY: 0,
                                maxY: _calculateMaxY(
                                  income,
                                  expenses,
                                  netProfit,
                                  afterTaxProfit,
                                ).toDouble(),
                                lineBarsData: [
                                  LineChartBarData(
                                    spots: [
                                      FlSpot(0, income.toDouble()),
                                      FlSpot(1, expenses.toDouble()),
                                      FlSpot(2, netProfit.toDouble()),
                                      FlSpot(3, afterTaxProfit.toDouble()),
                                    ],
                                    isCurved: true,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                    barWidth: 3,
                                    isStrokeCapRound: true,
                                    dotData: FlDotData(
                                      show: true,
                                      getDotPainter:
                                          (spot, percent, barData, index) {
                                            Color dotColor;
                                            switch (index) {
                                              case 0:
                                                dotColor = Theme.of(
                                                  context,
                                                ).colorScheme.tertiary;
                                                break;
                                              case 1:
                                                dotColor = Theme.of(
                                                  context,
                                                ).colorScheme.error;
                                                break;
                                              case 2:
                                                dotColor = Theme.of(
                                                  context,
                                                ).colorScheme.primary;
                                                break;
                                              case 3:
                                                dotColor = Theme.of(
                                                  context,
                                                ).colorScheme.secondary;
                                                break;
                                              default:
                                                dotColor = Theme.of(
                                                  context,
                                                ).colorScheme.primary;
                                            }
                                            return FlDotCirclePainter(
                                              radius: 4,
                                              color: dotColor,
                                              strokeWidth: 2,
                                              strokeColor: Theme.of(
                                                context,
                                              ).colorScheme.surface,
                                            );
                                          },
                                    ),
                                    belowBarData: BarAreaData(
                                      show: true,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary.withOpacity(0.1),
                                    ),
                                  ),
                                ],
                                lineTouchData: LineTouchData(
                                  enabled: true,
                                  touchTooltipData: LineTouchTooltipData(
                                    tooltipRoundedRadius: 8,
                                    tooltipPadding: const EdgeInsets.all(8),
                                    tooltipMargin: 8,
                                    getTooltipColor: (touchedSpot) => Theme.of(context).colorScheme.surface,
                                    getTooltipItems: (touchedSpots) {
                                      return touchedSpots.map((touchedSpot) {
                                        String label;
                                        switch (touchedSpot.x.toInt()) {
                                          case 0:
                                            label = 'Income';
                                            break;
                                          case 1:
                                            label = 'Expenses';
                                            break;
                                          case 2:
                                            label = 'Net Profit';
                                            break;
                                          case 3:
                                            label = 'After Tax Profit';
                                            break;
                                          default:
                                            label = '';
                                        }
                                        return LineTooltipItem(
                                          '$label\n${formatCurrencySync(touchedSpot.y.toInt())}',
                                          TextStyle(
                                            color: Theme.of(context).colorScheme.onSurface,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                            shadows: [
                                              Shadow(
                                                offset: const Offset(0, 1),
                                                blurRadius: 2,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .shadow
                                                    .withOpacity(0.3),
                                              ),
                                            ],
                                          ),
                                        );
                                      }).toList();
                                    },
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),

                  // Chart Legend
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildLegendItem(
                        'Income',
                        Theme.of(context).colorScheme.tertiary,
                      ),
                      _buildLegendItem(
                        'Expenses',
                        Theme.of(context).colorScheme.error,
                      ),
                      _buildLegendItem(
                        'Net Profit',
                        Theme.of(context).colorScheme.primary,
                      ),
                      _buildLegendItem(
                        'After Tax',
                        Theme.of(context).colorScheme.secondary,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],

                // Export Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _range == null ? null : () => _exportCSV(),
                        icon: const Icon(Icons.file_download),
                        label: const Text('Export CSV'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _range == null
                            ? null
                            : () => _exportPdf(context),
                        icon: const Icon(Icons.picture_as_pdf),
                        label: const Text('Export PDF'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // View Exported Files Button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => context.push('/home/exported-files'),
                    icon: const Icon(Icons.folder_open),
                    label: const Text('View Exported Files'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _exportCSV() async {
    if (_range == null) return;

    try {
      // Prepare CSV data
      final List<List<dynamic>> csvData = [
        ['Date', 'Type', 'Category/Services', 'Amount', 'Notes'],
      ];

      // Add income records
      final incomeRepo = IncomeRepository();
      final incomeRecords = await incomeRepo.getIncomeForDateRange(
        _range!.start,
        _range!.end,
        FirebaseAuth.instance.currentUser!.uid,
      );
      for (final record in incomeRecords) {
        for (final service in record.services) {
          csvData.add([
            formatShortDate(record.date),
            'Income',
            service.serviceName,
            formatCurrencySync(service.priceMinor),
            record.note ?? '',
          ]);
        }
        if (record.tipMinor > 0) {
          csvData.add([
            formatShortDate(record.date),
            'Income',
            'Tip',
            formatCurrencySync(record.tipMinor),
            record.note ?? '',
          ]);
        }
      }

      // Add expense records
      final expenseRepo = ExpenseRepository();
      final expenses = await expenseRepo.getExpensesForDateRange(
        _range!.start,
        _range!.end,
        FirebaseAuth.instance.currentUser!.uid,
      );
      final categories = await expenseRepo.getCategories(
        FirebaseAuth.instance.currentUser!.uid,
      );

      for (final expense in expenses) {
        final category = categories.firstWhere(
          (c) => c.id == expense.categoryId,
          orElse: () => ExpenseCategory()..name = 'Unknown',
        );
        csvData.add([
          formatShortDate(expense.date),
          'Expense',
          category.name,
          formatCurrencySync(expense.amountMinor),
          expense.note ?? '',
        ]);
      }

      // Generate and save CSV
      final filename =
          'CSV-${formatShortDate(_range!.start)}_to_${formatShortDate(_range!.end)}.csv';
      await ExportService.instance.exportCsv(filename, csvData);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('CSV exported successfully!'),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );

        // Navigate to exported files screen
        context.push('/home/exported-files');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Export failed: $e')));
      }
    }
  }

  Future<void> _exportPdf(BuildContext context) async {
    if (_range == null) return;

    try {
      // Prepare PDF data
      final List<List<String>> pdfData = [
        ['Date', 'Type', 'Category/Services', 'Amount', 'Notes'],
      ];

      // Add income records
      final incomeRepo = IncomeRepository();
      final incomeRecords = await incomeRepo.getIncomeForDateRange(
        _range!.start,
        _range!.end,
        FirebaseAuth.instance.currentUser!.uid,
      );
      for (final record in incomeRecords) {
        for (final service in record.services) {
          pdfData.add([
            formatShortDate(record.date),
            'Income',
            service.serviceName,
            formatCurrencySync(service.priceMinor),
            record.note ?? '',
          ]);
        }
        if (record.tipMinor > 0) {
          pdfData.add([
            formatShortDate(record.date),
            'Income',
            'Tip',
            formatCurrencySync(record.tipMinor),
            record.note ?? '',
          ]);
        }
      }

      // Add expense records
      final expenseRepo = ExpenseRepository();
      final expenses = await expenseRepo.getExpensesForDateRange(
        _range!.start,
        _range!.end,
        FirebaseAuth.instance.currentUser!.uid,
      );
      final categories = await expenseRepo.getCategories(
        FirebaseAuth.instance.currentUser!.uid,
      );

      for (final expense in expenses) {
        final category = categories.firstWhere(
          (c) => c.id == expense.categoryId,
          orElse: () => ExpenseCategory()..name = 'Unknown',
        );
        pdfData.add([
          formatShortDate(expense.date),
          'Expense',
          category.name,
          formatCurrencySync(expense.amountMinor),
          expense.note ?? '',
        ]);
      }

      // Generate and save PDF
      final filename =
          'PDF-${formatShortDate(_range!.start)}_to_${formatShortDate(_range!.end)}.pdf';
      final title =
          '${formatShortDate(_range!.start)} - ${formatShortDate(_range!.end)}';

      // Get the current dashboard state for additional data
      final dashboardCubit = context.read<DashboardCubit>();
      final state = dashboardCubit.state;

      // Calculate tax and after-tax profit
      final estimatedTax = (state.netMinor * _taxRate / 100).round();
      final afterTaxProfit = state.netMinor - estimatedTax;

      // Get goals data for the PDF
      final goalRepo = GoalRepository();
      final monthKey =
          '${_range!.start.year}-${_range!.start.month.toString().padLeft(2, '0')}';
      final goal = await goalRepo.getGoalForMonth(
        monthKey,
        FirebaseAuth.instance.currentUser!.uid,
      );

      List<Map<String, dynamic>> goalsData = [];
      if (goal != null) {
        // Calculate progress based on current income vs target
        final currentIncome = state.totalIncomeMinor;
        final progress = goal.targetAmountMinor > 0
            ? ((currentIncome / goal.targetAmountMinor) * 100)
                  .clamp(0, 100)
                  .round()
            : 0;

        goalsData = [
          {
            'name': 'Monthly Income Goal',
            'targetAmount': formatCurrencySync(goal.targetAmountMinor),
            'progress': progress,
          },
        ];
      }

      // Prepare additional data for PDF
      final additionalData = {
        'totalIncome': formatCurrencySync(state.totalIncomeMinor),
        'totalExpenses': formatCurrencySync(state.totalExpenseMinor),
        'netProfit': formatCurrencySync(state.netMinor),
        'afterTax': formatCurrencySync(afterTaxProfit),
        'goals': goalsData,
      };

      await ExportService.instance.exportPdf(
        filename,
        title,
        pdfData,
        additionalData,
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('PDF exported successfully!'),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );

        // Navigate to exported files screen
        context.push('/home/exported-files');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Export failed: $e')));
      }
    }
  }
}
