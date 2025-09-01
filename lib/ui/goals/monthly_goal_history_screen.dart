import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../strings.dart';

import '../../cubits/goal_cubit.dart';
import '../../cubits/dashboard_cubit.dart';
import '../../models/goal_models.dart';
import '../../services/user_manager.dart';
import '../../utils/formatting.dart';

class MonthlyGoalHistoryScreen extends StatefulWidget {
  const MonthlyGoalHistoryScreen({super.key});

  @override
  State<MonthlyGoalHistoryScreen> createState() =>
      _MonthlyGoalHistoryScreenState();
}

class _MonthlyGoalHistoryScreenState extends State<MonthlyGoalHistoryScreen> {
  @override
  void initState() {
    super.initState();
    // Load all goals for the user
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = UserManager.instance.currentUserId;
      context.read<GoalCubit>().loadAllGoals(userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(kMonthlyGoalHistoryLabel),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(), // Navigate back to goals screen
        ),
      ),
      body: BlocBuilder<GoalCubit, GoalState>(
        builder: (context, goalState) {
          if (goalState.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (goalState.allGoals.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.flag_outlined, size: 64),
                  const SizedBox(height: 16),
                  Text(
                    kNoMonthlyGoalsSetLabel,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    kSetFirstMonthlyGoalLabel,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: goalState.allGoals.length,
            itemBuilder: (context, index) {
              final goal = goalState.allGoals[index];
              return _buildGoalHistoryCard(goal);
            },
          );
        },
      ),
    );
  }

  Widget _buildGoalHistoryCard(MonthlyGoal goal) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Month and Year Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatMonthYear(goal.monthKey),
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    goal.monthKey,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Goal Amount
            Row(
              children: [
                Icon(
                  Icons.flag_outlined,
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Target Amount:',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const Spacer(),
                FutureBuilder<String>(
                  future: formatCurrency(goal.targetAmountMinor),
                  builder: (context, snapshot) {
                    return Text(
                      snapshot.data ?? 'Loading...',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Achievement Progress
            BlocBuilder<DashboardCubit, DashboardState>(
              builder: (context, dashboardState) {
                final monthKey = goal.monthKey;
                final monthParts = monthKey.split('-');
                final year = int.parse(monthParts[0]);
                final month = int.parse(monthParts[1]);

                // Parse month and year from monthKey

                // Use the total income from dashboard state if it matches the month
                // Otherwise, we'll need to load data for this specific month
                int monthlyIncome = 0;
                if (dashboardState.rangeStart.year == year &&
                    dashboardState.rangeStart.month == month) {
                  monthlyIncome = dashboardState.totalIncomeMinor;
                }

                final progress = monthlyIncome / goal.targetAmountMinor;
                final percentage = (progress * 100).clamp(0.0, 100.0);
                final isAchieved = monthlyIncome >= goal.targetAmountMinor;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.trending_up,
                          color: isAchieved
                              ? Theme.of(context).colorScheme.tertiary
                              : Theme.of(context).colorScheme.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Achievement:',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const Spacer(),
                        Text(
                          '${percentage.toStringAsFixed(1)}%',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: isAchieved
                                    ? Theme.of(context).colorScheme.tertiary
                                    : Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Progress Bar
                    LinearProgressIndicator(
                      value: progress.clamp(0.0, 1.0),
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).colorScheme.primary,
                      ),
                      minHeight: 8,
                    ),

                    const SizedBox(height: 8),

                    // Income vs Goal
                    Row(
                      children: [
                        Text(
                          'Income: ',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        FutureBuilder<String>(
                          future: formatCurrency(monthlyIncome),
                          builder: (context, snapshot) {
                            return Text(
                              snapshot.data ?? 'Loading...',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.w500),
                            );
                          },
                        ),
                        const Spacer(),
                        if (isAchieved)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                                                          child: Text(
                                '✓ Achieved',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.tertiary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                          ),
                      ],
                    ),
                  ],
                );
              },
            ),

            // Strategies Section
            if (goal.strategies.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),

              Row(
                children: [
                  Icon(
                    Icons.lightbulb_outline,
                    color: Theme.of(context).colorScheme.secondary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Strategies:',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              ...goal.strategies.map(
                (strategy) => Padding(
                  padding: const EdgeInsets.only(left: 28, bottom: 4),
                  child: Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          strategy.title,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withValues(alpha: 0.8),
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatMonthYear(String monthKey) {
    final parts = monthKey.split('-');
    final year = int.parse(parts[0]);
    final month = int.parse(parts[1]);

    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return '${months[month - 1]} $year';
  }
}
