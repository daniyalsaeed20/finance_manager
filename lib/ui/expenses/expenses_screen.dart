import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubits/expense_cubit.dart';
import '../../models/expense_models.dart';
import '../../repositories/expense_repository.dart';
import '../../utils/formatting.dart';

class ExpensesScreen extends StatelessWidget {
  const ExpensesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ExpenseCubit(ExpenseRepository())
        ..loadCategories()
        ..refreshRange(DateTime.now().subtract(const Duration(days: 6)), DateTime.now()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Expenses')),
        floatingActionButton: const _AddExpenseButton(),
        body: BlocBuilder<ExpenseCubit, ExpenseState>(
          builder: (context, state) {
            if (state.loading) return const Center(child: CircularProgressIndicator());
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text('This Week Total: ${formatCurrencyMinor(state.totalMinor)}'),
                const SizedBox(height: 12),
                for (final e in state.expenses)
                  Card(
                    child: ListTile(
                      title: Text(formatShortDate(e.date)),
                      subtitle: Text(state.categories.firstWhere((c) => c.id == e.categoryId, orElse: () => ExpenseCategory()..name='Unknown').name),
                      trailing: Text(formatCurrencyMinor(e.amountMinor)),
                    ),
                  ),
                const SizedBox(height: 100),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _AddExpenseButton extends StatelessWidget {
  const _AddExpenseButton();

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () async {
        final cubit = context.read<ExpenseCubit>();
        await showDialog(
          context: context,
          builder: (_) => _ExpenseDialog(categories: cubit.state.categories),
        );
      },
      icon: const Icon(Icons.add),
      label: const Text('Add Expense'),
    );
  }
}

class _ExpenseDialog extends StatefulWidget {
  const _ExpenseDialog({required this.categories});

  final List<ExpenseCategory> categories;

  @override
  State<_ExpenseDialog> createState() => _ExpenseDialogState();
}

class _ExpenseDialogState extends State<_ExpenseDialog> {
  DateTime _date = DateTime.now();
  int _amountMinor = 0;
  ExpenseCategory? _selectedCategory;
  final _amountController = TextEditingController();
  final _vendorController = TextEditingController();
  final _noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('New Expense'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextButton(
              onPressed: () async {
                final d = await showDatePicker(
                  context: context,
                  initialDate: _date,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2100),
                );
                if (d != null) setState(() => _date = d);
              },
              child: Text('Date: ${formatShortDate(_date)}'),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<ExpenseCategory>(
              items: [
                for (final c in widget.categories)
                  DropdownMenuItem(value: c, child: Text(c.name)),
              ],
              onChanged: (v) => setState(() => _selectedCategory = v),
              decoration: const InputDecoration(labelText: 'Category'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _amountController,
              decoration: const InputDecoration(labelText: 'Amount (e.g., 10.00)'),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              onChanged: (v) {
                final parsed = double.tryParse(v) ?? 0;
                _amountMinor = (parsed * 100).round();
              },
            ),
            const SizedBox(height: 8),
            TextField(controller: _vendorController, decoration: const InputDecoration(labelText: 'Vendor (optional)')),
            const SizedBox(height: 8),
            TextField(controller: _noteController, decoration: const InputDecoration(labelText: 'Note (optional)')),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () async {
            if (_selectedCategory == null) return;
            final e = Expense()
              ..date = _date
              ..categoryId = _selectedCategory!.id
              ..amountMinor = _amountMinor
              ..vendor = _vendorController.text.isEmpty ? null : _vendorController.text
              ..note = _noteController.text.isEmpty ? null : _noteController.text;
            await context.read<ExpenseCubit>().addExpense(e);
            if (mounted) Navigator.pop(context);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}

