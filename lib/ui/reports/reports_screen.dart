import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../cubits/dashboard_cubit.dart';
import '../../models/expense_models.dart';
import '../../repositories/expense_repository.dart';
import '../../repositories/income_repository.dart';
import '../../repositories/goal_repository.dart';
import '../../services/export_service.dart';
import '../../services/user_manager.dart';
import '../../utils/formatting.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  DateTimeRange? _range;

  @override
  void initState() {
    super.initState();
    // Set default range to current month
    final now = DateTime.now();
    _range = DateTimeRange(
      start: DateTime(now.year, now.month, 1),
      end: DateTime(now.year, now.month + 1, 0, 23, 59, 59),
    );

    // Load data for the selected range
    final userId = UserManager.instance.currentUserId;
    context.read<DashboardCubit>().loadForRange(
      _range!.start,
      _range!.end,
      userId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => DashboardCubit(
            incomeRepo: IncomeRepository(),
            expenseRepo: ExpenseRepository(),
            goalRepo: GoalRepository(),
          ),
        ),
      ],
      child: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                      end: now,
                    ),
                  );
                  if (picked != null) {
                    setState(() => _range = picked);
                    // Load data for the selected range
                    final userId = UserManager.instance.currentUserId;
                    context.read<DashboardCubit>().loadForRange(
                      picked.start,
                      picked.end,
                      userId,
                    );
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

              // Summary Cards
              if (_range != null) ...[
                BlocBuilder<DashboardCubit, DashboardState>(
                  builder: (context, state) {
                    if (state.loading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return Column(
                      children: [
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
                                      FutureBuilder<String>(
                                        future: formatCurrency(
                                          state.totalIncomeMinor,
                                        ),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            return Text(
                                              snapshot.data!,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleLarge
                                                  ?.copyWith(
                                                    color: Theme.of(
                                                      context,
                                                    ).colorScheme.primary,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            );
                                          }
                                          return const Text('Loading...');
                                        },
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
                                      FutureBuilder<String>(
                                        future: formatCurrency(
                                          state.totalExpenseMinor,
                                        ),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            return Text(
                                              snapshot.data!,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleLarge
                                                  ?.copyWith(
                                                    color: Theme.of(
                                                      context,
                                                    ).colorScheme.primary,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            );
                                          }
                                          return const Text('Loading...');
                                        },
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
                                        'Net Profit',
                                        style: Theme.of(
                                          context,
                                        ).textTheme.labelMedium,
                                      ),
                                      FutureBuilder<String>(
                                        future: formatCurrency(state.netMinor),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            return Text(
                                              snapshot.data!,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleLarge
                                                  ?.copyWith(
                                                    color: state.netMinor < 0
                                                        ? Colors.red
                                                        : Colors.green,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            );
                                          }
                                          return const Text('Loading...');
                                        },
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
              ],

              // Charts Section
              if (_range != null) ...[
                Text(
                  'Financial Overview',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 200,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: BlocBuilder<DashboardCubit, DashboardState>(
                        builder: (context, state) {
                          if (state.loading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          final income = state.totalIncomeMinor;
                          final expenses = state.totalExpenseMinor;
                          final netProfit = state.netMinor;

                          if (income == 0 && expenses == 0) {
                            return const Center(
                              child: Text('No data available for this period'),
                            );
                          }

                          return PieChart(
                            PieChartData(
                              sections: [
                                if (income > 0)
                                  PieChartSectionData(
                                    color: Colors.green,
                                    value: income.toDouble(),
                                    title:
                                        'Income\n${(income / 100).toStringAsFixed(0)}',
                                    radius: 60,
                                    titleStyle: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                if (expenses > 0)
                                  PieChartSectionData(
                                    color: Colors.red,
                                    value: expenses.toDouble(),
                                    title:
                                        'Expenses\n${(expenses / 100).toStringAsFixed(0)}',
                                    radius: 60,
                                    titleStyle: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                              ],
                              centerSpaceRadius: 40,
                              sectionsSpace: 2,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
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
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _exportCSV() async {
    if (_range == null) return;

    try {
      // Get the dashboard state to access repositories
      final dashboardCubit = context.read<DashboardCubit>();

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
            formatCurrencyMinor(service.priceMinor),
            record.note ?? '',
          ]);
        }
        if (record.tipMinor > 0) {
          csvData.add([
            formatShortDate(record.date),
            'Income',
            'Tip',
            formatCurrencyMinor(record.tipMinor),
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
          formatCurrencyMinor(expense.amountMinor),
          expense.note ?? '',
        ]);
      }

      // Generate and share CSV
      final filename =
          'financial_report_${formatShortDate(_range!.start)}_to_${formatShortDate(_range!.end)}.csv';
      final file = await ExportService.instance.exportCsv(filename, csvData);

      if (mounted) {
        await Share.shareXFiles(
          [XFile(file.path)],
          text:
              'Financial Report ${formatShortDate(_range!.start)} - ${formatShortDate(_range!.end)}',
        );
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
      final cubit = context.read<DashboardCubit>();
      final state = cubit.state;

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
            formatCurrencyMinor(service.priceMinor),
            record.note ?? '',
          ]);
        }
        if (record.tipMinor > 0) {
          pdfData.add([
            formatShortDate(record.date),
            'Income',
            'Tip',
            formatCurrencyMinor(record.tipMinor),
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
          formatCurrencyMinor(expense.amountMinor),
          expense.note ?? '',
        ]);
      }

      // Generate and share PDF
      final filename =
          'financial_report_${formatShortDate(_range!.start)}_to_${formatShortDate(_range!.end)}.pdf';
      final title =
          'Financial Report\n${formatShortDate(_range!.start)} - ${formatShortDate(_range!.end)}';
      final file = await ExportService.instance.exportPdf(
        filename,
        title,
        pdfData,
      );
      await Share.shareXFiles([XFile(file.path)], text: 'Financial Report PDF');

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('PDF exported successfully!')),
        );
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
