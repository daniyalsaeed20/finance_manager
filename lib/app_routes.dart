// ignore_for_file: unused_import
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'ui/auth/auth_screen.dart';
import 'ui/onboarding/onboarding_screen.dart';
import 'ui/home/home_shell.dart';
import 'ui/dashboard/dashboard_screen.dart';
import 'ui/income/income_screen.dart';

import 'ui/income/edit_income_screen.dart';
import 'ui/expenses/expenses_screen.dart';
import 'ui/expenses/edit_expense_screen.dart';
import 'ui/reports/reports_screen.dart';
import 'ui/reports/exported_files_screen.dart';
import 'ui/goals/goals_screen.dart';
import 'ui/taxes/taxes_screen.dart';
import 'ui/business/business_management_screen.dart';
import 'app_manager/ui/settings_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/onboarding',
  debugLogDiagnostics: true,
  redirect: (context, state) {
    final user = FirebaseAuth.instance.currentUser;
    final isOnboarding = state.matchedLocation == '/onboarding';
    final isAuth = state.matchedLocation == '/auth';

    // Log navigation redirects for debugging
    debugPrint(
      '🔀 Navigation redirect: ${state.uri.path} -> ${state.matchedLocation}',
    );
    debugPrint('👤 User: ${user?.uid ?? 'null'}');

    // If user is not signed in and trying to access protected routes
    if (user == null && !isOnboarding && !isAuth) {
      debugPrint('🚫 Redirecting unauthenticated user to onboarding');
      return '/onboarding';
    }

    // If user is signed in and trying to access auth/onboarding
    if (user != null && (isOnboarding || isAuth)) {
      debugPrint('✅ Redirecting authenticated user to home');
      return '/home';
    }

    // No redirect needed
    debugPrint('✅ No redirect needed');
    return null;
  },
  errorBuilder: (context, state) {
    debugPrint('Navigation error: ${state.error}');
    debugPrint('Current location: ${state.uri.path}');
    debugPrint('Matched location: ${state.matchedLocation}');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Navigation Error'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/home'),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Navigation Error',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Error: ${state.error}',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/home'),
              child: const Text('Go to Dashboard'),
            ),
          ],
        ),
      ),
    );
  },
  routes: [
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(path: '/auth', builder: (context, state) => const AuthScreen()),
    // Primary screens with bottom navigation (inside ShellRoute)
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
      ],
    ),

    // Secondary screens without bottom navigation (standalone)
    GoRoute(
      path: '/home/income/edit/:id',
      builder: (context, state) {
        final incomeId = int.parse(state.pathParameters['id']!);
        return EditIncomeScreen(incomeId: incomeId);
      },
    ),
    GoRoute(
      path: '/home/expenses/edit/:id',
      builder: (context, state) {
        final expenseId = int.parse(state.pathParameters['id']!);
        return EditExpenseScreen(expenseId: expenseId);
      },
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
    GoRoute(
      path: '/home/business',
      builder: (context, state) => const BusinessManagementScreen(),
    ),
    GoRoute(
      path: '/home/exported-files',
      builder: (context, state) => const ExportedFilesScreen(),
    ),
  ],
);
