import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';

import '../../cubits/dashboard_cubit.dart';
import '../../models/expense_models.dart';
import '../../repositories/expense_repository.dart';
import '../../repositories/income_repository.dart';
import '../../services/export_service.dart';
import '../../utils/formatting.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  DateTimeRange? _range;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => DashboardCubit(
            incomeRepo: IncomeRepository(),
            expenseRepo: ExpenseRepository(),
          ),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(title: const Text('Reports')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Select date range', style: Theme.of(context).textTheme.titleMedium),
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
                    context.read<DashboardCubit>().loadForRange(picked.start, picked.end);
                  }
                },
                icon: const Icon(Icons.calendar_today),
                label: Text(_range == null
                    ? 'Choose range'
                    : '${formatShortDate(_range!.start)} - ${formatShortDate(_range!.end)}'),
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
                                      Text('Income', style: Theme.of(context).textTheme.labelMedium),
                                      Text(
                                        formatCurrencyMinor(state.totalIncomeMinor),
                                        style: Theme.of(context).textTheme.titleLarge,
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
                                      Text('Expenses', style: Theme.of(context).textTheme.labelMedium),
                                      Text(
                                        formatCurrencyMinor(state.totalExpenseMinor),
                                        style: Theme.of(context).textTheme.titleLarge,
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
                                      Text('Net Profit', style: Theme.of(context).textTheme.labelMedium),
                                      Text(
                                        formatCurrencyMinor(state.netMinor),
                                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                          color: state.netMinor < 0 ? Colors.red : Colors.green,
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
              ],
              
              // Export Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _range == null
                          ? null
                          : () => _exportCsv(context),
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

  Future<void> _exportCsv(BuildContext context) async {
    if (_range == null) return;

    try {
      final cubit = context.read<DashboardCubit>();
      final state = cubit.state;
      
      // Prepare CSV data
      final List<List<dynamic>> csvData = [
        ['Date', 'Type', 'Category/Services', 'Amount', 'Notes'],
      ];

      // Add income records
      final incomeRepo = IncomeRepository();
      final incomeRecords = await incomeRepo.getIncomeForDateRange(_range!.start, _range!.end);
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
      final expenses = await expenseRepo.getExpensesForDateRange(_range!.start, _range!.end);
      final categories = await expenseRepo.getCategories();
      
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
      final filename = 'financial_report_${formatShortDate(_range!.start)}_to_${formatShortDate(_range!.end)}.csv';
      final file = await ExportService.instance.exportCsv(filename, csvData);
      await Share.shareXFiles([XFile(file.path)], text: 'Financial Report CSV');
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('CSV exported successfully!')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Export failed: $e')),
        );
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
      final incomeRecords = await incomeRepo.getIncomeForDateRange(_range!.start, _range!.end);
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
      final expenses = await expenseRepo.getExpensesForDateRange(_range!.start, _range!.end);
      final categories = await expenseRepo.getCategories();
      
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
      final filename = 'financial_report_${formatShortDate(_range!.start)}_to_${formatShortDate(_range!.end)}.pdf';
      final title = 'Financial Report\n${formatShortDate(_range!.start)} - ${formatShortDate(_range!.end)}';
      final file = await ExportService.instance.exportPdf(filename, title, pdfData);
      await Share.shareXFiles([XFile(file.path)], text: 'Financial Report PDF');
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('PDF exported successfully!')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Export failed: $e')),
        );
      }
    }
  }
}

