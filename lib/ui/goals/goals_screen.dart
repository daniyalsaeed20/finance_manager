import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:go_router/go_router.dart';

import '../../cubits/dashboard_cubit.dart';
import '../../cubits/goal_cubit.dart';
import '../../models/goal_models.dart';
import '../../services/user_manager.dart';
import '../../utils/formatting.dart';

class GoalsScreen extends StatefulWidget {
  const GoalsScreen({super.key});

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  DateTime _selectedMonth = DateTime.now();

  @override
  void initState() {
    super.initState();
    // Load initial data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = UserManager.instance.currentUserId;
      final monthKey =
          '${_selectedMonth.year}-${_selectedMonth.month.toString().padLeft(2, '0')}';
      context.read<GoalCubit>().loadForMonth(monthKey, userId);
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
        title: const Text('Financial Goals & Analytics'),
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
                      final newMonth = DateTime(
                        _selectedMonth.year,
                        _selectedMonth.month - 1,
                      );
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (mounted) {
                          setState(() {
                            _selectedMonth = newMonth;
                          });
                        }
                      });
                      final userId = UserManager.instance.currentUserId;
                      final monthKey =
                          '${newMonth.year}-${newMonth.month.toString().padLeft(2, '0')}';
                      context.read<GoalCubit>().loadForMonth(monthKey, userId);
                      context.read<DashboardCubit>().loadForRange(
                        DateTime(newMonth.year, newMonth.month, 1),
                        DateTime(
                          newMonth.year,
                          newMonth.month + 1,
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
                            final newMonth = DateTime(
                              _selectedMonth.year,
                              _selectedMonth.month + 1,
                            );
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              if (mounted) {
                                setState(() {
                                  _selectedMonth = newMonth;
                                });
                              }
                            });
                            final userId = UserManager.instance.currentUserId;
                            final monthKey =
                                '${newMonth.year}-${newMonth.month.toString().padLeft(2, '0')}';
                            context.read<GoalCubit>().loadForMonth(
                              monthKey,
                              userId,
                            );
                            context.read<DashboardCubit>().loadForRange(
                              DateTime(newMonth.year, newMonth.month, 1),
                              DateTime(
                                newMonth.year,
                                newMonth.month + 1,
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
                onPressed: () {
                  debugPrint('🎯 Goals: Navigating to Business Manager');
                  context.push('/home/business');
                },
                icon: Icon(
                  Icons.flag,
                  color: Theme.of(context).colorScheme.primary,
                  size: 18,
                ),
                label: Text(
                  'Manage Monthly Goals',
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

            // Monthly Goal Management Notice
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Theme.of(context).colorScheme.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Monthly Goal Management',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Monthly goals are now managed in the Business Manager. Go to Business Manager → Monthly Goals to set or modify your savings goals.',
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
                          debugPrint(
                            '🎯 Goals: Navigating to Business Manager (from card)',
                          );
                          context.push('/home/business');
                        },
                        icon: const Icon(Icons.business),
                        label: const Text('Go to Business Manager'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.primary,
                          foregroundColor: Theme.of(
                            context,
                          ).colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // How It Works Tip
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.lightbulb_outline,
                          color: Theme.of(context).colorScheme.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'How This Screen Works',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '• Set monthly savings goals to track your financial progress\n'
                      '• Savings = Income - Expenses (what you can actually save)\n'
                      '• Profit = Income - Expenses - Savings Goal (what remains after meeting your goal)\n'
                      '• Both values show \$0 when there\'s no surplus\n'
                      '• Strategies help you plan how to achieve your goals',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Financial Overview with Charts
            BlocBuilder<GoalCubit, GoalState>(
              builder: (context, goalState) {
                return BlocBuilder<DashboardCubit, DashboardState>(
                  builder: (context, dashboardState) {
                    if (goalState.loading || dashboardState.loading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final goal = goalState.goal;
                    final monthlyIncome = dashboardState.totalIncomeMinor;
                    final monthlyExpenses = dashboardState.totalExpenseMinor;

                    if (goal == null) {
                      return const Center(
                        child: Text('No goal set for this month'),
                      );
                    }

                    final progress = monthlyIncome / goal.targetAmountMinor;
                    final isAchieved = monthlyIncome >= goal.targetAmountMinor;

                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          // Goal Summary Card
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  FutureBuilder<String>(
                                    future: formatCurrency(
                                      goal.targetAmountMinor,
                                    ),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return Text(
                                          'Monthly Goal: ${snapshot.data}',
                                          style: Theme.of(
                                            context,
                                          ).textTheme.titleLarge,
                                        );
                                      }
                                      return const Text(
                                        'Monthly Goal: Loading...',
                                      );
                                    },
                                  ),
                                  const SizedBox(height: 16),

                                  // Progress Bar
                                  LinearProgressIndicator(
                                    value: progress.clamp(0.0, 1.0),
                                    backgroundColor: Colors.grey[300],
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      isAchieved
                                          ? Theme.of(
                                              context,
                                            ).colorScheme.primary
                                          : Theme.of(
                                              context,
                                            ).colorScheme.secondary,
                                    ),
                                    minHeight: 10,
                                  ),

                                  const SizedBox(height: 8),

                                  Text(
                                    '${(progress * 100).clamp(0.0, 100.0).toStringAsFixed(1)}% Complete',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Financial Metrics Overview - Grid Layout
                          GridView.count(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            // childAspectRatio: 1.5,
                            children: [
                              // Income Card
                              Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.trending_up,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.tertiary,
                                        size: 32,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Income',
                                        style: Theme.of(
                                          context,
                                        ).textTheme.labelMedium,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        formatCurrencyAmount(monthlyIncome),
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.copyWith(
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.tertiary,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // Expenses Card
                              Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.trending_down,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.error,
                                        size: 32,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Expenses',
                                        style: Theme.of(
                                          context,
                                        ).textTheme.labelMedium,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        formatCurrencyAmount(monthlyExpenses),
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.copyWith(
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.error,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // Savings Card (Actual Savings Achieved)
                              Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.savings,
                                        color:
                                            (monthlyIncome - monthlyExpenses)
                                                    .clamp(0, double.infinity) >
                                                0
                                            ? Theme.of(
                                                context,
                                              ).colorScheme.primary
                                            : Colors.grey,
                                        size: 32,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Savings',
                                        style: Theme.of(
                                          context,
                                        ).textTheme.labelMedium,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        formatCurrencyAmount(
                                          (monthlyIncome - monthlyExpenses)
                                              .clamp(0, double.infinity)
                                              .toInt(),
                                        ),
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.copyWith(
                                              color:
                                                  (monthlyIncome -
                                                              monthlyExpenses)
                                                          .clamp(
                                                            0,
                                                            double.infinity,
                                                          ) >
                                                      0
                                                  ? Theme.of(
                                                      context,
                                                    ).colorScheme.primary
                                                  : Colors.grey,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // Profit Card (Income - Expenses - Savings)
                              Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.account_balance_wallet,
                                        color: Colors.orange,
                                        size: 32,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Profit',
                                        style: Theme.of(
                                          context,
                                        ).textTheme.labelMedium,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        formatCurrencyAmount(
                                          (monthlyIncome -
                                                  monthlyExpenses -
                                                  goal.targetAmountMinor)
                                              .clamp(0, double.infinity)
                                              .toInt(),
                                        ),
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.copyWith(
                                              color: Colors.orange,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),

                          // Pie Chart - Financial Breakdown
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Financial Breakdown',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleLarge,
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    children: [
                                      // Pie Chart - takes most of the space
                                      Expanded(
                                        flex: 3,
                                        child: SizedBox(
                                          height: 200,
                                          child: PieChart(
                                            PieChartData(
                                              sections: [
                                                PieChartSectionData(
                                                  value: monthlyIncome
                                                      .toDouble(),
                                                  title: '', // Remove label
                                                  color: Theme.of(
                                                    context,
                                                  ).colorScheme.tertiary,
                                                  radius: 60,
                                                ),
                                                PieChartSectionData(
                                                  value: monthlyExpenses
                                                      .toDouble(),
                                                  title: '', // Remove label
                                                  color: Theme.of(
                                                    context,
                                                  ).colorScheme.error,
                                                  radius: 60,
                                                ),
                                                PieChartSectionData(
                                                  value:
                                                      (monthlyIncome -
                                                              monthlyExpenses)
                                                          .clamp(
                                                            0,
                                                            double.infinity,
                                                          )
                                                          .toDouble(),
                                                  title: '', // Remove label
                                                  color: Theme.of(
                                                    context,
                                                  ).colorScheme.primary,
                                                  radius: 60,
                                                ),
                                                PieChartSectionData(
                                                  value:
                                                      (monthlyIncome -
                                                              monthlyExpenses -
                                                              goal.targetAmountMinor)
                                                          .clamp(
                                                            0,
                                                            double.infinity,
                                                          )
                                                          .toDouble(),
                                                  title: '', // Remove label
                                                  color: Colors.orange,
                                                  radius: 60,
                                                ),
                                              ],
                                              centerSpaceRadius: 40,
                                              sectionsSpace: 2,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      // Legend - compact and positioned to the right
                                      Expanded(
                                        flex: 1,
                                        child: _buildPieChartLegend(
                                          monthlyIncome,
                                          monthlyExpenses,
                                          goal,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Bar Chart - Progress vs Goal
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Financial Overview vs Savings Goal',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleLarge,
                                  ),
                                  const SizedBox(height: 16),
                                  SizedBox(
                                    height: 200,
                                    child: BarChart(
                                      BarChartData(
                                        alignment:
                                            BarChartAlignment.spaceAround,
                                        minY:
                                            -1, // Start at -1 for visual purposes
                                        maxY: _calculateMaxY(
                                          monthlyIncome,
                                          monthlyExpenses,
                                          goal,
                                        ),
                                        barTouchData: BarTouchData(
                                          enabled: true,
                                        ),
                                        titlesData: FlTitlesData(
                                          show: true,
                                          bottomTitles: AxisTitles(
                                            sideTitles: SideTitles(
                                              showTitles: true,
                                              getTitlesWidget: (value, meta) {
                                                switch (value.toInt()) {
                                                  case 0:
                                                    return const Text(
                                                      'Savings',
                                                    );
                                                  case 1:
                                                    return const Text('Income');
                                                  case 2:
                                                    return const Text(
                                                      'Expenses',
                                                    );
                                                  case 3:
                                                    return const Text('Profit');
                                                  default:
                                                    return const Text('');
                                                }
                                              },
                                            ),
                                          ),
                                          leftTitles: AxisTitles(
                                            sideTitles: SideTitles(
                                              showTitles: true,
                                              reservedSize: 40,
                                              interval:
                                                  _calculateMaxY(
                                                    monthlyIncome,
                                                    monthlyExpenses,
                                                    goal,
                                                  ) /
                                                  3, // 4 values (0, 1/3, 2/3, max)
                                              getTitlesWidget: (value, meta) {
                                                // Only show labels for 0 and positive values
                                                if (value < 0) {
                                                  return const SizedBox.shrink();
                                                }
                                                return Text(
                                                  _formatAxisValue(value),
                                                  style: const TextStyle(
                                                    fontSize: 10,
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                          topTitles: const AxisTitles(
                                            sideTitles: SideTitles(
                                              showTitles: false,
                                            ),
                                          ),
                                          rightTitles: const AxisTitles(
                                            sideTitles: SideTitles(
                                              showTitles: false,
                                            ),
                                          ),
                                        ),
                                        borderData: FlBorderData(show: false),
                                        barGroups: [
                                          BarChartGroupData(
                                            x: 0,
                                            barRods: [
                                              BarChartRodData(
                                                toY:
                                                    (monthlyIncome -
                                                            monthlyExpenses)
                                                        .clamp(
                                                          0,
                                                          double.infinity,
                                                        )
                                                        .toDouble(),
                                                color:
                                                    (monthlyIncome -
                                                                monthlyExpenses)
                                                            .clamp(
                                                              0,
                                                              double.infinity,
                                                            ) >
                                                        0
                                                    ? Theme.of(
                                                        context,
                                                      ).colorScheme.primary
                                                    : Colors.grey,
                                                width: 25,
                                                borderRadius:
                                                    const BorderRadius.vertical(
                                                      top: Radius.circular(4),
                                                    ),
                                              ),
                                            ],
                                          ),
                                          BarChartGroupData(
                                            x: 1,
                                            barRods: [
                                              BarChartRodData(
                                                toY: monthlyIncome.toDouble(),
                                                color: Theme.of(
                                                  context,
                                                ).colorScheme.tertiary,
                                                width: 25,
                                                borderRadius:
                                                    const BorderRadius.vertical(
                                                      top: Radius.circular(4),
                                                    ),
                                              ),
                                            ],
                                          ),
                                          BarChartGroupData(
                                            x: 2,
                                            barRods: [
                                              BarChartRodData(
                                                toY: monthlyExpenses.toDouble(),
                                                color: Theme.of(
                                                  context,
                                                ).colorScheme.error,
                                                width: 25,
                                                borderRadius:
                                                    const BorderRadius.vertical(
                                                      top: Radius.circular(4),
                                                    ),
                                              ),
                                            ],
                                          ),
                                          BarChartGroupData(
                                            x: 3,
                                            barRods: [
                                              BarChartRodData(
                                                toY:
                                                    (monthlyIncome -
                                                            monthlyExpenses -
                                                            goal.targetAmountMinor)
                                                        .clamp(
                                                          0,
                                                          double.infinity,
                                                        )
                                                        .toDouble(),
                                                color: Colors.orange,
                                                width: 25,
                                                borderRadius:
                                                    const BorderRadius.vertical(
                                                      top: Radius.circular(4),
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Goal Strategies
                          if (goal.strategies.isNotEmpty) ...[
                            Card(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Strategies',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleLarge,
                                    ),
                                    const SizedBox(height: 8),
                                    ...goal.strategies.map(
                                      (strategy) => ListTile(
                                        leading: const Icon(Icons.check_circle),
                                        title: Text(strategy.title),
                                        trailing: const SizedBox.shrink(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectMonth() async {
    final currentContext = context;
    final picked = await showDatePicker(
      context: currentContext,
      initialDate: _selectedMonth,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDatePickerMode: DatePickerMode.year,
    );

    if (picked != null && mounted) {
      setState(() {
        _selectedMonth = DateTime(picked.year, picked.month);
      });
      final userId = UserManager.instance.currentUserId;
      final monthKey =
          '${_selectedMonth.year}-${_selectedMonth.month.toString().padLeft(2, '0')}';

      // Check if context is still valid before using it
      if (currentContext.mounted) {
        currentContext.read<GoalCubit>().loadForMonth(monthKey, userId);
        currentContext.read<DashboardCubit>().loadForRange(
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
      }
    }
  }

  double _calculateMaxY(
    int monthlyIncome,
    int monthlyExpenses,
    MonthlyGoal goal,
  ) {
    // Calculate all four values
    final savings = (monthlyIncome - monthlyExpenses).clamp(0, double.infinity);
    final profit = (monthlyIncome - monthlyExpenses - goal.targetAmountMinor)
        .clamp(0, double.infinity);

    // Find the highest value among all four metrics
    final maxValue = [
      monthlyIncome.toDouble(),
      monthlyExpenses.toDouble(),
      savings.toDouble(),
      profit.toDouble(),
    ].reduce((a, b) => a > b ? a : b);

    // Add 30% padding and ensure it's at least 1.0 to avoid division by zero
    return (maxValue * 1.3).clamp(1.0, double.infinity);
  }

  String _formatAxisValue(double value) {
    if (value >= 1000000) {
      return '\$${(value / 1000000).toStringAsFixed(1)}m';
    } else if (value >= 1000) {
      return '\$${(value / 1000).toStringAsFixed(1)}k';
    } else {
      return '\$${value.toStringAsFixed(0)}';
    }
  }

  Widget _buildPieChartLegend(
    int monthlyIncome,
    int monthlyExpenses,
    MonthlyGoal goal,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Income Legend Item
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.tertiary,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              'Income',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 10,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        // Expenses Legend Item
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.error,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              'Expenses',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 10,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        // Savings Legend Item
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              'Savings',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 10,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        // Profit Legend Item
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: Colors.orange,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              'Profit',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
