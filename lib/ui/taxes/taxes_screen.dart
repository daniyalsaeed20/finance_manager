import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubits/dashboard_cubit.dart';
import '../../cubits/tax_cubit.dart';
import '../../models/tax_models.dart';
import '../../repositories/expense_repository.dart';
import '../../repositories/income_repository.dart';
import '../../repositories/tax_repository.dart';
import '../../utils/formatting.dart';

class TaxesScreen extends StatefulWidget {
  const TaxesScreen({super.key});

  @override
  State<TaxesScreen> createState() => _TaxesScreenState();
}

class _TaxesScreenState extends State<TaxesScreen> {
  DateTime _selectedMonth = DateTime.now();
  double _taxRate = 0.15; // Default 15%

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => DashboardCubit(
            incomeRepo: IncomeRepository(),
            expenseRepo: ExpenseRepository(),
          )..loadForRange(
              DateTime(_selectedMonth.year, _selectedMonth.month, 1),
              DateTime(_selectedMonth.year, _selectedMonth.month + 1, 0, 23, 59, 59),
            ),
        ),
        BlocProvider(
          create: (_) => TaxCubit(TaxRepository())..load(),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(title: const Text('Tax Planning')),
        floatingActionButton: const _AddPaymentButton(),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Month Selector
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month - 1);
                    });
                    context.read<DashboardCubit>().loadForRange(
                      DateTime(_selectedMonth.year, _selectedMonth.month, 1),
                      DateTime(_selectedMonth.year, _selectedMonth.month + 1, 0, 23, 59, 59),
                    );
                  },
                  icon: const Icon(Icons.chevron_left),
                ),
                Text(
                  '${_selectedMonth.month == DateTime.now().month && _selectedMonth.year == DateTime.now().year ? 'This Month' : formatMonthYear(_selectedMonth)}',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                IconButton(
                  onPressed: _selectedMonth.isBefore(DateTime.now()) ? () {
                    setState(() {
                      _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month + 1);
                    });
                    context.read<DashboardCubit>().loadForRange(
                      DateTime(_selectedMonth.year, _selectedMonth.month, 1),
                      DateTime(_selectedMonth.year, _selectedMonth.month + 1, 0, 23, 59, 59),
                    );
                  } : null,
                  icon: const Icon(Icons.chevron_right),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Tax Rate Setting
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Tax Rate Setting', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Slider(
                            value: _taxRate,
                            min: 0.0,
                            max: 0.50,
                            divisions: 50,
                            label: '${(_taxRate * 100).toStringAsFixed(1)}%',
                            onChanged: (value) {
                              setState(() {
                                _taxRate = value;
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          width: 80,
                          child: Text(
                            '${(_taxRate * 100).toStringAsFixed(1)}%',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'Adjust the slider to set your estimated tax rate',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Monthly Tax Summary
            BlocBuilder<DashboardCubit, DashboardState>(
              builder: (context, dashboardState) {
                if (dashboardState.loading) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                final monthlyIncome = dashboardState.totalIncomeMinor;
                final monthlyExpenses = dashboardState.totalExpenseMinor;
                final monthlyNetProfit = dashboardState.netMinor;
                final estimatedTax = (monthlyNetProfit * _taxRate).round();
                
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Monthly Tax Summary', style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  Text('Income', style: Theme.of(context).textTheme.labelMedium),
                                  Text(
                                    formatCurrencyMinor(monthlyIncome),
                                    style: Theme.of(context).textTheme.titleLarge,
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Text('Expenses', style: Theme.of(context).textTheme.labelMedium),
                                  Text(
                                    formatCurrencyMinor(monthlyExpenses),
                                    style: Theme.of(context).textTheme.titleLarge,
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Text('Net Profit', style: Theme.of(context).textTheme.labelMedium),
                                  Text(
                                    formatCurrencyMinor(monthlyNetProfit),
                                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                      color: monthlyNetProfit < 0 ? Colors.red : Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Estimated Tax Owed',
                                    style: Theme.of(context).textTheme.titleMedium,
                                  ),
                                  Text(
                                    'Based on ${(_taxRate * 100).toStringAsFixed(1)}% rate',
                                    style: Theme.of(context).textTheme.bodySmall,
                                  ),
                                ],
                              ),
                              Text(
                                formatCurrencyMinor(estimatedTax),
                                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                  color: estimatedTax > 0 ? Colors.red : Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),

            // Tax Plans
            Text('Tax Plans', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            BlocBuilder<TaxCubit, TaxState>(
              builder: (context, taxState) {
                if (taxState.loading) {
                  return const Center(child: CircularProgressIndicator());
                }
                return Column(
                  children: [
                    for (final p in taxState.plans)
                      Card(
                        child: ListTile(
                          title: Text(p.periodKey),
                          subtitle: Text('Rate: ${(p.estimatedRate * 100).toStringAsFixed(1)}%  Due: ${p.dueDate == null ? '-' : formatShortDate(p.dueDate!)}'),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () => context.read<TaxCubit>().deletePlan(p.id),
                          ),
                        ),
                      ),
                    const SizedBox(height: 16),
                    const _AddPlanCard(),
                  ],
                );
              },
            ),
            const SizedBox(height: 16),

            // Tax Payments
            Text('Tax Payments', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            BlocBuilder<TaxCubit, TaxState>(
              builder: (context, taxState) {
                if (taxState.loading) {
                  return const Center(child: CircularProgressIndicator());
                }
                return Column(
                  children: [
                    for (final pay in taxState.payments)
                      Card(
                        child: ListTile(
                          title: Text(formatShortDate(pay.date)),
                          subtitle: Text(pay.method ?? ''),
                          trailing: Text(formatCurrencyMinor(pay.amountMinor)),
                        ),
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _AddPlanCard extends StatefulWidget {
  const _AddPlanCard();

  @override
  State<_AddPlanCard> createState() => _AddPlanCardState();
}

class _AddPlanCardState extends State<_AddPlanCard> {
  final _periodController = TextEditingController();
  final _rateController = TextEditingController();
  DateTime? _dueDate;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Create Plan', style: Theme.of(context).textTheme.titleMedium),
            TextField(controller: _periodController, decoration: const InputDecoration(labelText: 'Period (e.g., 2025-01 or 2025-Q1)')),
            TextField(controller: _rateController, decoration: const InputDecoration(labelText: 'Estimated Rate (e.g., 0.25)')),
            Row(
              children: [
                TextButton(
                  onPressed: () async {
                    final now = DateTime.now();
                    final d = await showDatePicker(context: context, initialDate: now, firstDate: DateTime(2020), lastDate: DateTime(2100));
                    if (d != null) setState(() => _dueDate = d);
                  },
                  child: Text('Due: ${_dueDate == null ? '-' : formatShortDate(_dueDate!)}'),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () async {
                    final rate = double.tryParse(_rateController.text) ?? 0.0;
                    final plan = TaxPlan()
                      ..periodKey = _periodController.text
                      ..estimatedRate = rate
                      ..dueDate = _dueDate;
                    await context.read<TaxCubit>().upsertPlan(plan);
                    if (mounted) {
                      _periodController.clear();
                      _rateController.clear();
                      setState(() => _dueDate = null);
                    }
                  },
                  child: const Text('Add Plan'),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _AddPaymentButton extends StatelessWidget {
  const _AddPaymentButton();

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () async {
        await showDialog(context: context, builder: (_) => const _PaymentDialog());
      },
      icon: const Icon(Icons.add_card_outlined),
      label: const Text('Add Payment'),
    );
  }
}

class _PaymentDialog extends StatefulWidget {
  const _PaymentDialog();

  @override
  State<_PaymentDialog> createState() => _PaymentDialogState();
}

class _PaymentDialogState extends State<_PaymentDialog> {
  DateTime _date = DateTime.now();
  int _amountMinor = 0;
  final _amountController = TextEditingController();
  final _methodController = TextEditingController();
  final _noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('New Tax Payment'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              onPressed: () async {
                final d = await showDatePicker(context: context, initialDate: _date, firstDate: DateTime(2020), lastDate: DateTime(2100));
                if (d != null) setState(() => _date = d);
              },
              child: Text('Date: ${formatShortDate(_date)}'),
            ),
            TextField(
              controller: _amountController,
              decoration: const InputDecoration(labelText: 'Amount (e.g., 150.00)'),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              onChanged: (v) {
                final parsed = double.tryParse(v) ?? 0;
                _amountMinor = (parsed * 100).round();
              },
            ),
            TextField(controller: _methodController, decoration: const InputDecoration(labelText: 'Method (optional)')),
            TextField(controller: _noteController, decoration: const InputDecoration(labelText: 'Note (optional)')),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () async {
            final payment = TaxPayment()
              ..date = _date
              ..amountMinor = _amountMinor
              ..method = _methodController.text.isEmpty ? null : _methodController.text
              ..note = _noteController.text.isEmpty ? null : _noteController.text;
            await context.read<TaxCubit>().addPayment(payment);
            if (mounted) Navigator.pop(context);
          },
          child: const Text('Save'),
        )
      ],
    );
  }
}

