import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubits/dashboard_cubit.dart';
import '../../cubits/tax_cubit.dart';
import '../../models/tax_models.dart';
import '../../services/user_manager.dart';
import '../../utils/formatting.dart';
import '../../utils/amount_input_formatter.dart';

class TaxesScreen extends StatefulWidget {
  const TaxesScreen({super.key});

  @override
  State<TaxesScreen> createState() => _TaxesScreenState();
}

class _TaxesScreenState extends State<TaxesScreen> {
  DateTime _selectedMonth = DateTime.now();
  double _taxRate = 0.15; // Default 15%
  bool _isAddPaymentExpanded = false;

  @override
  void initState() {
    super.initState();
    // Load initial data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = UserManager.instance.currentUserId;
      context.read<TaxCubit>().load(userId);
      context.read<DashboardCubit>().loadForRange(
        DateTime(_selectedMonth.year, _selectedMonth.month, 1),
        DateTime(_selectedMonth.year, _selectedMonth.month + 1, 0, 23, 59, 59),
        userId,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tax Planning'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        elevation: 0,
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
                      final userId = UserManager.instance.currentUserId;
                      context.read<DashboardCubit>().loadForRange(
                        DateTime(_selectedMonth.year, _selectedMonth.month, 1),
                        DateTime(
                          _selectedMonth.year,
                          _selectedMonth.month + 1,
                          0,
                          23,
                          59,
                          59,
                        ),
                        userId,
                      );
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
                            final userId = UserManager.instance.currentUserId;
                            context.read<DashboardCubit>().loadForRange(
                              DateTime(
                                _selectedMonth.year,
                                _selectedMonth.month,
                                1,
                              ),
                              DateTime(
                                _selectedMonth.year,
                                _selectedMonth.month + 1,
                                0,
                                23,
                                59,
                                59,
                              ),
                              userId,
                            );
                          }
                        : null,
                    icon: const Icon(Icons.chevron_right),
                  ),
                ],
              ),
            ),

            // Tax Rate Setting
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tax Rate',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Slider(
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
                      Text(
                        'Current Rate: ${(_taxRate * 100).toStringAsFixed(1)}%',
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Monthly Tax Summary
            BlocBuilder<TaxCubit, TaxState>(
              builder: (context, taxState) {
                return BlocBuilder<DashboardCubit, DashboardState>(
                  builder: (context, dashboardState) {
                    if (taxState.loading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final monthlyIncome = dashboardState.totalIncomeMinor;
                    final monthlyExpenses = dashboardState.totalExpenseMinor;
                    final monthlyNetProfit = dashboardState.netMinor;
                    final estimatedTax = (monthlyNetProfit * _taxRate).round();

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        children: [
                          // Income, Expenses, Net Profit
                          Row(
                            children: [
                              Expanded(
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      children: [
                                        Text(
                                          'Income',
                                          style: Theme.of(
                                            context,
                                          ).textTheme.labelMedium,
                                        ),
                                        FutureBuilder<String>(
                                          future: formatCurrency(monthlyIncome),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              return Text(
                                                snapshot.data!,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium
                                                    ?.copyWith(
                                                      color: Theme.of(
                                                        context,
                                                      ).colorScheme.primary,
                                                      fontWeight:
                                                          FontWeight.bold,
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
                              Expanded(
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
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
                                            monthlyExpenses,
                                          ),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              return Text(
                                                snapshot.data!,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium
                                                    ?.copyWith(
                                                      color: Theme.of(
                                                        context,
                                                      ).colorScheme.primary,
                                                      fontWeight:
                                                          FontWeight.bold,
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
                              Expanded(
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      children: [
                                        Text(
                                          'Net Profit',
                                          style: Theme.of(
                                            context,
                                          ).textTheme.labelMedium,
                                        ),
                                        FutureBuilder<String>(
                                          future: formatCurrency(
                                            monthlyNetProfit,
                                          ),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              return Text(
                                                snapshot.data!,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium
                                                    ?.copyWith(
                                                      color:
                                                          monthlyNetProfit >= 0
                                                          ? Colors.green
                                                          : Colors.red,
                                                      fontWeight:
                                                          FontWeight.bold,
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

                          // Estimated Tax
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).colorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Estimated Tax',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium,
                                ),
                                FutureBuilder<String>(
                                  future: formatCurrency(estimatedTax),
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
                                              ).colorScheme.onPrimaryContainer,
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
                        ],
                      ),
                    );
                  },
                );
              },
            ),

            const SizedBox(height: 16),

            // Add Tax Payment Expandable Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Card(
                child: ExpansionTile(
                  title: const Text('Add Tax Payment'),
                  leading: const Icon(Icons.add),
                  initiallyExpanded: _isAddPaymentExpanded,
                  onExpansionChanged: (expanded) {
                    setState(() {
                      _isAddPaymentExpanded = expanded;
                    });
                  },
                  children: [const _AddTaxPaymentForm()],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Tax Payments List
            BlocBuilder<TaxCubit, TaxState>(
              builder: (context, state) {
                if (state.payments.isEmpty) {
                  return const Center(child: Text('No tax payments recorded'));
                }

                return Column(
                  children: state.payments
                      .map(
                        (payment) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: _TaxPaymentTile(
                            payment: payment,
                            onTap: () => _editTaxPayment(payment),
                          ),
                        ),
                      )
                      .toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectMonth() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedMonth,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDatePickerMode: DatePickerMode.year,
    );

    if (picked != null) {
      setState(() {
        _selectedMonth = DateTime(picked.year, picked.month);
      });
      final userId = 'current_user_id'; // TODO: Get from AppManager
      context.read<DashboardCubit>().loadForRange(
        DateTime(_selectedMonth.year, _selectedMonth.month, 1),
        DateTime(_selectedMonth.year, _selectedMonth.month + 1, 0, 23, 59, 59),
        userId,
      );
    }
  }

  void _editTaxPayment(TaxPayment payment) {
    showDialog(
      context: context,
      builder: (context) => _EditTaxPaymentDialog(payment: payment),
    );
  }
}

class _AddTaxPaymentForm extends StatefulWidget {
  const _AddTaxPaymentForm();

  @override
  State<_AddTaxPaymentForm> createState() => _AddTaxPaymentFormState();
}

class _AddTaxPaymentFormState extends State<_AddTaxPaymentForm> {
  final _amountController = TextEditingController();
  final _methodController = TextEditingController();
  final _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  int _amountMinor = 0;

  @override
  void dispose() {
    _amountController.dispose();
    _methodController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date picker
          ListTile(
            title: const Text('Date'),
            subtitle: Text(formatShortDate(_selectedDate)),
            trailing: const Icon(Icons.calendar_today),
            onTap: () => _selectDate(),
          ),

          const SizedBox(height: 16),

          // Amount input
          TextField(
            controller: _amountController,
            decoration: const InputDecoration(
              labelText: 'Amount (e.g., 10.00)',
              border: OutlineInputBorder(),
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [AmountInputFormatter()],
            onChanged: (value) {
              final parsed = double.tryParse(value) ?? 0;
              setState(() {
                _amountMinor = (parsed * 100).round();
              });
            },
          ),

          const SizedBox(height: 16),

          // Method input
          TextField(
            controller: _methodController,
            decoration: const InputDecoration(
              labelText: 'Payment Method (e.g., Bank Transfer)',
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 16),

          // Note input
          TextField(
            controller: _noteController,
            decoration: const InputDecoration(
              labelText: 'Note (optional)',
              border: OutlineInputBorder(),
            ),
            maxLines: 2,
          ),

          const SizedBox(height: 16),

          // Add button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _canSubmit() ? () => _addTaxPayment() : null,
              child: const Text('Add Tax Payment'),
            ),
          ),
        ],
      ),
    );
  }

  bool _canSubmit() {
    return _amountMinor > 0;
  }

  void _addTaxPayment() {
    final payment = TaxPayment()
      ..date = _selectedDate
      ..amountMinor = _amountMinor
      ..method = _methodController.text.isEmpty ? null : _methodController.text
      ..note = _noteController.text.isEmpty ? null : _noteController.text
      ..userId = 'current_user_id'; // TODO: Get from AppManager

    context.read<TaxCubit>().addPayment(payment);

    // Reset form
    _amountController.clear();
    _methodController.clear();
    _noteController.clear();
    setState(() {
      _amountMinor = 0;
    });
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }
}

class _TaxPaymentTile extends StatelessWidget {
  final TaxPayment payment;
  final VoidCallback onTap;

  const _TaxPaymentTile({required this.payment, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onTap,
        title: Text(formatShortDate(payment.date)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(payment.method ?? 'No method specified'),
            if (payment.note != null) Text('Note: ${payment.note}'),
          ],
        ),
        trailing: Text(
          formatCurrencyMinor(payment.amountMinor),
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
    );
  }
}

class _EditTaxPaymentDialog extends StatefulWidget {
  final TaxPayment payment;

  const _EditTaxPaymentDialog({required this.payment});

  @override
  State<_EditTaxPaymentDialog> createState() => _EditTaxPaymentDialogState();
}

class _EditTaxPaymentDialogState extends State<_EditTaxPaymentDialog> {
  final _amountController = TextEditingController();
  final _methodController = TextEditingController();
  final _noteController = TextEditingController();
  late DateTime _selectedDate;
  late int _amountMinor;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.payment.date;
    _amountController.text = (widget.payment.amountMinor / 100).toStringAsFixed(
      2,
    );
    _methodController.text = widget.payment.method ?? '';
    _noteController.text = widget.payment.note ?? '';
    _amountMinor = widget.payment.amountMinor;
  }

  @override
  void dispose() {
    _amountController.dispose();
    _methodController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Tax Payment'),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Date picker
            ListTile(
              title: const Text('Date'),
              subtitle: Text(formatShortDate(_selectedDate)),
              trailing: const Icon(Icons.calendar_today),
              onTap: () => _selectDate(),
            ),

            const SizedBox(height: 16),

            // Amount input
            TextField(
              controller: _amountController,
              decoration: const InputDecoration(
                labelText: 'Amount',
                border: OutlineInputBorder(),
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [AmountInputFormatter()],
              onChanged: (value) {
                final parsed = double.tryParse(value) ?? 0;
                setState(() {
                  _amountMinor = (parsed * 100).round();
                });
              },
            ),

            const SizedBox(height: 16),

            // Method input
            TextField(
              controller: _methodController,
              decoration: const InputDecoration(
                labelText: 'Payment Method',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            // Note input
            TextField(
              controller: _noteController,
              decoration: const InputDecoration(
                labelText: 'Note',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => _updateTaxPayment(),
          child: const Text('Update'),
        ),
        ElevatedButton(
          onPressed: () => _deleteTaxPayment(),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child: const Text('Delete'),
        ),
      ],
    );
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _updateTaxPayment() {
    final updatedPayment = widget.payment
      ..date = _selectedDate
      ..amountMinor = _amountMinor
      ..method = _methodController.text.isEmpty ? null : _methodController.text
      ..note = _noteController.text.isEmpty ? null : _noteController.text;

    context.read<TaxCubit>().addPayment(updatedPayment);
    Navigator.pop(context);
  }

  void _deleteTaxPayment() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Tax Payment'),
        content: const Text(
          'Are you sure you want to delete this tax payment?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<TaxCubit>().deletePayment(widget.payment.id);
              Navigator.pop(context); // Close confirmation dialog
              Navigator.pop(context); // Close edit dialog
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
