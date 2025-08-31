import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../cubits/dashboard_cubit.dart';
import '../../cubits/goal_cubit.dart';
import '../../models/goal_models.dart';
import '../../services/user_manager.dart';
import '../../utils/formatting.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  DateTime _selectedMonth = DateTime.now();

  @override
  void initState() {
    super.initState();
    // Load initial data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = UserManager.instance.currentUserId;
      final monthKey =
          '${_selectedMonth.year}-${_selectedMonth.month.toString().padLeft(2, '0')}';

      context.read<DashboardCubit>().loadForRange(
        DateTime(_selectedMonth.year, _selectedMonth.month, 1),
        DateTime(_selectedMonth.year, _selectedMonth.month + 1, 0, 23, 59, 59),
        userId,
      );
      context.read<GoalCubit>().loadForMonth(monthKey, userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<DashboardCubit, DashboardState>(
        builder: (context, dashboardState) {
          return BlocBuilder<GoalCubit, GoalState>(
            builder: (context, goalState) {
              if (dashboardState.loading || goalState.loading) {
                return const Center(child: CircularProgressIndicator());
              }

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
                              _selectedMonth = DateTime(
                                _selectedMonth.year,
                                _selectedMonth.month - 1,
                              );
                            });
                            final userId = UserManager.instance.currentUserId;
                            final monthKey =
                                '${_selectedMonth.year}-${_selectedMonth.month.toString().padLeft(2, '0')}';

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
                            context.read<GoalCubit>().loadForMonth(
                              monthKey,
                              userId,
                            );
                          },
                          icon: const Icon(Icons.chevron_left),
                        ),
                        Text(
                          '${_selectedMonth.month == DateTime.now().month && _selectedMonth.year == DateTime.now().year ? 'This Month' : formatMonthYear(_selectedMonth)}',
                          style: Theme.of(context).textTheme.titleLarge,
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
                                  final userId =
                                      UserManager.instance.currentUserId;
                                  final monthKey =
                                      '${_selectedMonth.year}-${_selectedMonth.month.toString().padLeft(2, '0')}';

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
                                  context.read<GoalCubit>().loadForMonth(
                                    monthKey,
                                    userId,
                                  );
                                }
                              : null,
                          icon: const Icon(Icons.chevron_right),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Monthly Summary Cards
                    _KpiCard(
                      title: 'Income',
                      amount: dashboardState.totalIncomeMinor,
                    ),
                    _KpiCard(
                      title: 'Expenses',
                      amount: dashboardState.totalExpenseMinor,
                    ),
                    _KpiCard(
                      title: 'Net Profit',
                      amount: dashboardState.netMinor,
                    ),

                    const SizedBox(height: 12),

                    // Goal Progress Widget or No Goal Message
                    if (goalState.goal != null)
                      _buildGoalProgressWidget(
                        goalState.goal!,
                        dashboardState.totalIncomeMinor,
                      )
                    else
                      _buildNoGoalMessage(),

                    const Spacer(),
                    Text(
                      'Tip: Use the arrows to navigate between months and track your progress over time.',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildGoalProgressWidget(MonthlyGoal goal, int monthlyIncome) {
    final progress = monthlyIncome / goal.targetAmountMinor;
    final isAchieved = monthlyIncome >= goal.targetAmountMinor;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder<String>(
              future: formatCurrency(goal.targetAmountMinor),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(
                    'Monthly Goal: ${snapshot.data}',
                    style: Theme.of(context).textTheme.titleLarge,
                  );
                }
                return const Text('Monthly Goal: Loading...');
              },
            ),
            const SizedBox(height: 16),

            // Progress Bar
            LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(
                isAchieved
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.primary,
              ),
              minHeight: 10,
            ),

            const SizedBox(height: 8),

            Text(
              '${(progress * 100).clamp(0.0, 100.0).toStringAsFixed(1)}% Complete',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoGoalMessage() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.flag_outlined,
                  color: Theme.of(context).colorScheme.primary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'No Monthly Goal Set',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Set a monthly savings goal to track your financial progress and stay motivated!',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Navigate to goals screen
                  context.push('/home/goals');
                },
                icon: const Icon(Icons.add),
                label: const Text('Set Monthly Goal'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _KpiCard extends StatelessWidget {
  const _KpiCard({required this.title, required this.amount});
  final String title;
  final int amount;

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
              formatCurrencyAmount(amount),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
