import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubits/dashboard_cubit.dart';
import '../../repositories/expense_repository.dart';
import '../../repositories/income_repository.dart';
import '../../utils/formatting.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  DateTime _selectedMonth = DateTime.now();

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
        )
      ],
      child: Scaffold(
        appBar: AppBar(title: const Text('Dashboard')),
        body: BlocBuilder<DashboardCubit, DashboardState>(
          builder: (context, state) {
            if (state.loading) return const Center(child: CircularProgressIndicator());
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
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
                  const SizedBox(height: 12),
                  
                  // Monthly Summary Cards
                  _KpiCard(title: 'Income', value: formatCurrencyMinor(state.totalIncomeMinor)),
                  _KpiCard(title: 'Expenses', value: formatCurrencyMinor(state.totalExpenseMinor)),
                  _KpiCard(title: 'Net Profit', value: formatCurrencyMinor(state.netMinor)),
                  
                  const SizedBox(height: 16),
                  
                  // Quick Actions
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => Navigator.pushNamed(context, '/home/income'),
                          icon: const Icon(Icons.add),
                          label: const Text('Add Income'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => Navigator.pushNamed(context, '/home/expenses'),
                          icon: const Icon(Icons.remove),
                          label: const Text('Add Expense'),
                        ),
                      ),
                    ],
                  ),
                  
                  const Spacer(),
                  Text(
                    'Tip: Use the arrows to navigate between months and track your progress over time.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _KpiCard extends StatelessWidget {
  const _KpiCard({required this.title, required this.value});
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            Text(
              value,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: title == 'Net Profit' 
                  ? (value.startsWith('-') ? Colors.red : Colors.green)
                  : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

