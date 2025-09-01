import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../strings.dart';

import '../../cubits/dashboard_cubit.dart';
import '../../cubits/goal_cubit.dart';
import '../../models/goal_models.dart';
import '../../services/user_manager.dart';
import '../../services/currency_service.dart';
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
                          '${_selectedMonth.month == DateTime.now().month && _selectedMonth.year == DateTime.now().month ? kThisMonthLabel : formatMonthYear(_selectedMonth)}',
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
                      title: kIncomeLabel2,
                      amount: dashboardState.totalIncomeMinor,
                    ),
                    _KpiCard(
                      title: kExpensesLabel2,
                      amount: dashboardState.totalExpenseMinor,
                    ),
                    _KpiCard(
                      title: kNetProfitLabel,
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
                      kDashboardTipLabel,
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
            StreamBuilder<Currency>(
              stream: CurrencyService.currencyStream,
              builder: (context, snapshot) {
                // Use stream data if available, otherwise fall back to cached currency
                final currency =
                    snapshot.data ?? CurrencyService.getCurrentCurrencySync();
                if (currency != null) {
                  return Text(
                    '$kMonthlyGoalLabel: ${CurrencyService.formatAmountWithCurrency(goal.targetAmountMinor, currency)}',
                    style: Theme.of(context).textTheme.titleLarge,
                  );
                }
                // Fallback to async method if no currency available
                return FutureBuilder<String>(
                  future: formatCurrency(goal.targetAmountMinor),
                  builder: (context, asyncSnapshot) {
                    if (asyncSnapshot.hasData) {
                      return Text(
                        '$kMonthlyGoalLabel: ${asyncSnapshot.data}',
                        style: Theme.of(context).textTheme.titleLarge,
                      );
                    }
                    return Text('$kMonthlyGoalLabel: Loading...');
                  },
                );
              },
            ),
            const SizedBox(height: 16),

            // Progress Bar
            LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
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
                  kNoMonthlyGoalSetLabel,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              kSetMonthlySavingsGoalLabel,
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
                label: Text(kSetMonthlyGoalLabel),
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
            StreamBuilder<Currency>(
              stream: CurrencyService.currencyStream,
              builder: (context, snapshot) {
                // Use stream data if available, otherwise fall back to cached currency
                final currency =
                    snapshot.data ?? CurrencyService.getCurrentCurrencySync();
                if (currency != null) {
                  return Text(
                    CurrencyService.formatAmountWithCurrency(amount, currency),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }
                // Fallback to sync method if no currency available
                return Text(
                  formatCurrencySync(amount),
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
