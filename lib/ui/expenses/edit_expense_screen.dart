import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../strings.dart';

import '../../cubits/expense_cubit.dart';
import '../../models/expense_models.dart';
import '../../utils/formatting.dart';
import '../../utils/amount_input_formatter.dart';
import '../../services/user_manager.dart';

class EditExpenseScreen extends StatefulWidget {
  final int expenseId;

  const EditExpenseScreen({super.key, required this.expenseId});

  @override
  State<EditExpenseScreen> createState() => _EditExpenseScreenState();
}

class _EditExpenseScreenState extends State<EditExpenseScreen> {
  Expense? _expense;
  DateTime? _date;
  int? _amountMinor;
  ExpenseCategory? _selectedCategory;
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _vendorController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadExpense();
  }

  Future<void> _loadExpense() async {
    // Load the expense data from the cubit state
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = context.read<ExpenseCubit>().state;
      final expense = state.expenses.firstWhere(
        (e) => e.id == widget.expenseId,
        orElse: () => Expense(),
      );

      if (expense.id != 0) {
        setState(() {
          _expense = expense;
          _date = expense.date;
          _amountMinor = expense.amountMinor;
          _amountController.text = ((expense.amountMinor) / 100).toString();
          _vendorController.text = expense.vendor ?? '';
          _noteController.text = expense.note ?? '';

          // Set the selected category based on the expense's categoryId
          final category = context
              .read<ExpenseCubit>()
              .state
              .categories
              .where((c) => c.id == expense.categoryId)
              .firstOrNull;
          _selectedCategory = category;
        });
      }
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    _vendorController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_expense == null) {
      return Scaffold(
        appBar: AppBar(title: Text(kEditExpenseLabel)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(kEditExpenseLabel)),
      body: BlocBuilder<ExpenseCubit, ExpenseState>(
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Date picker
                ListTile(
                  title: Text(kDateLabel),
                  subtitle: Text(
                    _date != null ? formatShortDate(_date!) : 'Select date',
                  ),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () => _selectDate(),
                ),

                const SizedBox(height: 16),

                // Category selection with cards
                Text(
                  'Category',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                if (state.categories.isEmpty)
                  const Card(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'No categories available. Please add categories in the Business section.',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  )
                else
                  Wrap(
                    spacing: 8.0,
                    children: state.categories.map((category) {
                      final isSelected = _selectedCategory?.id == category.id;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedCategory = category;
                          });
                        },
                        child: Card(
                          color: isSelected
                              ? Theme.of(context).colorScheme.primaryContainer
                              : null,
                          child: Container(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              children: [
                                Text(
                                  category.name,
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(
                                        fontWeight: isSelected
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                      ),
                                ),
                                if (isSelected) ...[
                                  const SizedBox(height: 4),
                                  Icon(
                                    Icons.check_circle,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                    size: 16,
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                const SizedBox(height: 16),

                // Amount input
                TextField(
                  controller: _amountController,
                  decoration: const InputDecoration(
                    labelText: 'Amount (e.g., 10.00)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [AmountInputFormatter()],
                  textInputAction: TextInputAction.done,
                  onChanged: (v) {
                    final parsed = double.tryParse(v) ?? 0;
                    _amountMinor = (parsed * 100).round();
                  },
                ),

                const SizedBox(height: 16),

                // Vendor input
                TextField(
                  controller: _vendorController,
                  decoration: const InputDecoration(
                    labelText: 'Vendor (optional)',
                    border: OutlineInputBorder(),
                  ),
                  textInputAction: TextInputAction.done,
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
                  textInputAction: TextInputAction.done,
                ),

                const SizedBox(height: 32),

                // Save button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _canSubmit() ? _saveExpense : null,
                    child: const Text('Save Changes'),
                  ),
                ),

                const SizedBox(height: 16),

                // Delete button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: _deleteExpense,
                    child: const Text('Delete Expense'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  bool _canSubmit() {
    return _selectedCategory != null &&
        _amountMinor != null &&
        _amountMinor! > 0;
  }

  Future<void> _saveExpense() async {
    if (!_canSubmit()) return;

    if (_expense == null) return;

    final expense = _expense!
      ..date = _date!
      ..categoryId = _selectedCategory!.id
      ..amountMinor = _amountMinor!
      ..vendor = _vendorController.text.isEmpty ? null : _vendorController.text
      ..note = _noteController.text.isEmpty ? null : _noteController.text;

    try {
      context.read<ExpenseCubit>().updateExpense(expense);

      // Navigate back with result to trigger refresh
      context.pop(true);
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating expense: $e'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  void _deleteExpense() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Expense'),
        content: const Text(
          'Are you sure you want to delete this expense? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop(); // Close dialog
              if (_expense != null) {
                try {
                  final userId = UserManager.instance.currentUserId;
                  context.read<ExpenseCubit>().deleteExpense(
                    _expense!.id,
                    userId,
                  );

                  // Navigate back with result to trigger refresh
                  context.pop(true);
                } catch (e) {
                  // Show error message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error deleting expense: $e'),
                      backgroundColor: Theme.of(context).colorScheme.error,
                    ),
                  );
                }
              }
            },
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _date = picked);
    }
  }
}
