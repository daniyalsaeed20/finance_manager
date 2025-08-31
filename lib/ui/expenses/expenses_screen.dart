import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../cubits/expense_cubit.dart';
import '../../models/expense_models.dart';
import '../../services/user_manager.dart';
import '../../utils/amount_input_formatter.dart';
import '../../utils/formatting.dart';

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({super.key});

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  DateTime _selectedMonth = DateTime.now();
  bool _isAddExpanded = false;

  @override
  void initState() {
    super.initState();
    // Load initial data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = UserManager.instance.currentUserId;
      context.read<ExpenseCubit>()
        ..loadCategories(userId)
        ..refreshRange(
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      context.read<ExpenseCubit>().refreshRange(
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
                            context.read<ExpenseCubit>().refreshRange(
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

            // Simple navigation button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextButton.icon(
                onPressed: () => context.push('/home/business'),
                icon: Icon(
                  Icons.category,
                  color: Theme.of(context).colorScheme.primary,
                  size: 18,
                ),
                label: Text(
                  'Manage Categories',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                ),
              ),
            ),

            // Add Expense Expandable Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Card(
                child: ExpansionTile(
                  title: const Text('Add Expense'),
                  leading: const Icon(Icons.add),
                  initiallyExpanded: _isAddExpanded,
                  onExpansionChanged: (expanded) {
                    setState(() {
                      _isAddExpanded = expanded;
                    });
                  },
                  children: [
                    _AddExpenseForm(
                      key: ValueKey(
                        '${_selectedMonth.year}-${_selectedMonth.month}',
                      ),
                      onSubmitted: () {
                        setState(() {
                          _isAddExpanded = false;
                        });
                      },
                      selectedMonth: _selectedMonth,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Expenses List
            BlocBuilder<ExpenseCubit, ExpenseState>(
              builder: (context, state) {
                if (state.loading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state.expenses.isEmpty) {
                  return const Center(
                    child: Text('No expenses for this month'),
                  );
                }

                return Column(
                  children: state.expenses
                      .map(
                        (expense) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: _ExpenseRecordTile(
                            expense: expense,
                            category: state.categories.firstWhere(
                              (c) => c.id == expense.categoryId,
                              orElse: () => ExpenseCategory()..name = 'Unknown',
                            ),
                            onTap: () => _editExpenseRecord(expense),
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
      final userId = UserManager.instance.currentUserId;
      context.read<ExpenseCubit>().refreshRange(
        DateTime(_selectedMonth.year, _selectedMonth.month, 1),
        DateTime(_selectedMonth.year, _selectedMonth.month + 1, 0, 23, 59, 59),
        userId,
      );
    }
  }

  Future<void> _editExpenseRecord(Expense expense) async {
    final result = await context.push('/home/expenses/edit/${expense.id}');
    if (result == true) {
      // Refresh data when returning from edit screen
      final userId = UserManager.instance.currentUserId;
      context.read<ExpenseCubit>().refreshRange(
        DateTime(_selectedMonth.year, _selectedMonth.month, 1),
        DateTime(_selectedMonth.year, _selectedMonth.month + 1, 0, 23, 59, 59),
        userId,
      );
    }
  }
}

class _AddExpenseForm extends StatefulWidget {
  final VoidCallback onSubmitted;
  final DateTime selectedMonth;

  const _AddExpenseForm({
    super.key,
    required this.onSubmitted,
    required this.selectedMonth,
  });

  @override
  State<_AddExpenseForm> createState() => _AddExpenseFormState();
}

class _AddExpenseFormState extends State<_AddExpenseForm> {
  DateTime _date = DateTime.now();
  int _amountMinor = 0;
  ExpenseCategory? _selectedCategory;
  final _amountController = TextEditingController();
  final _vendorController = TextEditingController();
  final _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Set default date based on current month selection
    _updateDefaultDate();
  }

  void _updateDefaultDate() {
    // Always use current date for new expenses, regardless of which month is being viewed
    _date = DateTime.now();

    // Trigger UI update
    setState(() {});
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Update date when dependencies change (e.g., month navigation)
    _updateDefaultDate();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExpenseCubit, ExpenseState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Date picker
              ListTile(
                title: const Text('Date'),
                subtitle: Text(formatShortDate(_date)),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDate(),
              ),

              const SizedBox(height: 16),

              // Category selection with cards
              Text('Category', style: Theme.of(context).textTheme.titleMedium),
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
                                  color: Theme.of(context).colorScheme.primary,
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
                onSubmitted: (_) => _addExpense(),
                onChanged: (v) {
                  final parsed = double.tryParse(v) ?? 0;
                  setState(() {
                    _amountMinor = (parsed * 100).round();
                  });
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
                onSubmitted: (_) => _addExpense(),
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
                onSubmitted: (_) => _addExpense(),
              ),

              const SizedBox(height: 16),

              // Save button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _canSubmit() ? () => _addExpense() : null,
                  child: const Text('Save Expense'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  bool _canSubmit() {
    return _selectedCategory != null && _amountMinor > 0;
  }

  void _addExpense() {
    final userId = UserManager.instance.currentUserId;

    // Ensure we always have a valid date, fallback to current date if needed
    final expenseDate = _date ?? DateTime.now();

    final expense = Expense()
      ..date = expenseDate
      ..categoryId = _selectedCategory!.id
      ..amountMinor = _amountMinor
      ..vendor = _vendorController.text.isEmpty ? null : _vendorController.text
      ..note = _noteController.text.isEmpty ? null : _noteController.text
      ..userId = userId;

    context.read<ExpenseCubit>().addExpense(expense);

    // Reset form
    _amountController.clear();
    _vendorController.clear();
    _noteController.clear();
    setState(() {
      _selectedCategory = null;
      _amountMinor = 0;
    });

    // Collapse the expansion tile after successful submission
    widget.onSubmitted();

    // Close keyboard
    FocusScope.of(context).unfocus();
  }

  Future<void> _selectDate() async {
    // Allow selecting dates in the selected month, but also allow current date
    final currentDate = DateTime.now();
    final lastDate = DateTime(
      widget.selectedMonth.year,
      widget.selectedMonth.month + 1,
      0,
    );
    final firstDate = DateTime(
      widget.selectedMonth.year,
      widget.selectedMonth.month,
      1,
    );

    // Allow selecting from the earlier of firstDate and currentDate
    final actualFirstDate = firstDate.isBefore(currentDate)
        ? firstDate
        : currentDate;

    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: actualFirstDate,
      lastDate: lastDate,
    );
    if (picked != null) {
      setState(() => _date = picked);
    }
  }
}

class _ExpenseRecordTile extends StatelessWidget {
  final Expense expense;
  final ExpenseCategory category;
  final VoidCallback onTap;

  const _ExpenseRecordTile({
    required this.expense,
    required this.category,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onTap,
        title: Text(formatShortDate(expense.date)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(category.name),
            if (expense.vendor != null) Text('Vendor: ${expense.vendor}'),
            if (expense.note != null) Text('Note: ${expense.note}'),
          ],
        ),
        trailing: FutureBuilder<String>(
          future: formatCurrency(expense.amountMinor),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text(
                snapshot.data!,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              );
            }
            return const Text('Loading...');
          },
        ),
      ),
    );
  }
}
