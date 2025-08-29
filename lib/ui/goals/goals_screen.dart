import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubits/dashboard_cubit.dart';
import '../../cubits/goal_cubit.dart';
import '../../models/goal_models.dart';
import '../../repositories/expense_repository.dart';
import '../../repositories/goal_repository.dart';
import '../../repositories/income_repository.dart';
import '../../utils/formatting.dart';

class GoalsScreen extends StatefulWidget {
  const GoalsScreen({super.key});

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  final _amountController = TextEditingController();
  final _strategyController = TextEditingController();
  DateTime _selectedMonth = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final monthKey = monthKeyFromDate(_selectedMonth);
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => GoalCubit(GoalRepository())..loadForMonth(monthKey),
        ),
        BlocProvider(
          create: (_) => DashboardCubit(
            incomeRepo: IncomeRepository(),
            expenseRepo: ExpenseRepository(),
          )..loadForRange(
              DateTime(_selectedMonth.year, _selectedMonth.month, 1),
              DateTime(_selectedMonth.year, _selectedMonth.month + 1, 0, 23, 59, 59),
            ),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(title: const Text('Monthly Goal')),
        body: ListView(
          padding: const EdgeInsets.all(16.0),
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
                    final newMonthKey = monthKeyFromDate(_selectedMonth);
                    context.read<GoalCubit>().loadForMonth(newMonthKey);
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
                    final newMonthKey = monthKeyFromDate(_selectedMonth);
                    context.read<GoalCubit>().loadForMonth(newMonthKey);
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

            // Goal Progress Section
            BlocBuilder<GoalCubit, GoalState>(
              builder: (context, goalState) {
                if (goalState.loading) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                final goal = goalState.goal;
                if (goal == null) {
                  return _buildNoGoalCard();
                }
                
                return _buildGoalProgressCard(goal);
              },
            ),
            const SizedBox(height: 16),

            // Goal Setting Form
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Set or Update Goal', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _amountController,
                      decoration: const InputDecoration(
                        labelText: 'Target Amount (e.g., 2000.00)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _strategyController,
                      decoration: const InputDecoration(
                        labelText: 'Add a strategy (optional)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          final amount = double.tryParse(_amountController.text) ?? 0;
                          if (amount > 0) {
                            final g = MonthlyGoal()
                              ..monthKey = monthKeyFromDate(_selectedMonth)
                              ..targetAmountMinor = (amount * 100).round()
                              ..strategies = [
                                if (_strategyController.text.isNotEmpty)
                                  (GoalStrategyItem()..title = _strategyController.text)
                              ];
                            await context.read<GoalCubit>().upsert(g);
                            _amountController.clear();
                            _strategyController.clear();
                          }
                        },
                        child: const Text('Save Goal'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoGoalCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(
              Icons.flag_outlined,
              size: 48,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 8),
            Text(
              'No goal set for this month',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(
              'Set a monthly income goal to track your progress',
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalProgressCard(MonthlyGoal goal) {
    return BlocBuilder<DashboardCubit, DashboardState>(
      builder: (context, dashboardState) {
        if (dashboardState.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        final currentIncome = dashboardState.totalIncomeMinor;
        final targetAmount = goal.targetAmountMinor;
        final progress = targetAmount > 0 ? (currentIncome / targetAmount).clamp(0.0, 1.0) : 0.0;
        final percentage = (progress * 100).round();
        final remaining = targetAmount - currentIncome;
        final isAchieved = currentIncome >= targetAmount;

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Goal Progress', style: Theme.of(context).textTheme.titleMedium),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: isAchieved ? Colors.green : Colors.orange,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        isAchieved ? 'Achieved!' : '$percentage%',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Progress Bar
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isAchieved ? Colors.green : Theme.of(context).colorScheme.primary,
                  ),
                  minHeight: 8,
                ),
                const SizedBox(height: 16),

                // Goal Details
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text('Target', style: Theme.of(context).textTheme.labelMedium),
                          Text(
                            formatCurrencyMinor(targetAmount),
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text('Current', style: Theme.of(context).textTheme.labelMedium),
                          Text(
                            formatCurrencyMinor(currentIncome),
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: isAchieved ? Colors.green : null,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            isAchieved ? 'Surplus' : 'Remaining',
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                          Text(
                            formatCurrencyMinor(remaining.abs()),
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: isAchieved ? Colors.green : Colors.orange,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Strategies
                if (goal.strategies.isNotEmpty) ...[
                  Text('Strategies', style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 8),
                  ...goal.strategies.map((strategy) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_circle_outline,
                          size: 16,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Expanded(child: Text(strategy.title)),
                      ],
                    ),
                  )),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

