// ignore_for_file: unused_import
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'ui/auth/auth_screen.dart';
import 'ui/onboarding/onboarding_screen.dart';
import 'ui/home/home_shell.dart';
import 'ui/dashboard/dashboard_screen.dart';
import 'ui/income/income_screen.dart';
import 'ui/expenses/expenses_screen.dart';
import 'ui/reports/reports_screen.dart';
import 'ui/goals/goals_screen.dart';
import 'ui/taxes/taxes_screen.dart';
import 'app_manager/ui/settings_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/onboarding',
  routes: [
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(path: '/auth', builder: (context, state) => const AuthScreen()),
    ShellRoute(
      builder: (context, state, child) => HomeShell(child: child),
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) => const DashboardScreen(),
        ),
        GoRoute(
          path: '/home/dashboard',
          builder: (context, state) => const DashboardScreen(),
        ),
        GoRoute(
          path: '/home/income',
          builder: (context, state) => const IncomeScreen(),
        ),
        GoRoute(
          path: '/home/expenses',
          builder: (context, state) => const ExpensesScreen(),
        ),
        GoRoute(
          path: '/home/reports',
          builder: (context, state) => const ReportsScreen(),
        ),
        GoRoute(
          path: '/home/goals',
          builder: (context, state) => const GoalsScreen(),
        ),
        GoRoute(
          path: '/home/taxes',
          builder: (context, state) => const TaxesScreen(),
        ),
        GoRoute(
          path: '/home/settings',
          builder: (context, state) => const SettingsScreen(),
        ),
      ],
    ),
  ],
);
