import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'app_manager/app_theme.dart';
import 'app_manager/theme_cubit/theme_cubit.dart';
import 'app_routes.dart';
import 'cubits/dashboard_cubit.dart';
import 'cubits/expense_cubit.dart';
import 'cubits/goal_cubit.dart';
import 'cubits/income_cubit.dart';
import 'cubits/tax_cubit.dart';
import 'repositories/auth_repository.dart';
import 'repositories/expense_repository.dart';
import 'repositories/goal_repository.dart';
import 'repositories/income_repository.dart';
import 'repositories/tax_repository.dart';
import 'services/isar_service.dart';
import 'services/user_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // Initialize local DB
  await IsarService.instance.db;

  runApp(const AppRoot());
}

class AppRoot extends StatefulWidget {
  const AppRoot({super.key});

  @override
  State<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  bool _isLoading = true;
  String? _initialRoute;

  @override
  void initState() {
    super.initState();
    _checkAuthState();
  }

  Future<void> _checkAuthState() async {
    try {
      // Check initial auth state
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        UserManager.instance.setCurrentUserId(user.uid);
        setState(() {
          _initialRoute = '/home';
          _isLoading = false;
        });
      } else {
        setState(() {
          _initialRoute = '/onboarding';
          _isLoading = false;
        });
      }

      // Listen to future auth state changes
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        if (user != null) {
          UserManager.instance.setCurrentUserId(user.uid);
          if (mounted && _initialRoute != '/home') {
            setState(() {
              _initialRoute = '/home';
            });
          }
        } else {
          UserManager.instance.setCurrentUserId('');
          if (mounted && _initialRoute != '/onboarding') {
            setState(() {
              _initialRoute = '/onboarding';
            });
          }
        }
      });
    } catch (e) {
      debugPrint('Error checking auth state: $e');
      setState(() {
        _initialRoute = '/onboarding';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || _initialRoute == null) {
      return const MaterialApp(
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeCubit()),
        // Global repositories
        RepositoryProvider<IncomeRepository>(create: (_) => IncomeRepository()),
        RepositoryProvider<ExpenseRepository>(
          create: (_) => ExpenseRepository(),
        ),
        RepositoryProvider<GoalRepository>(create: (_) => GoalRepository()),
        RepositoryProvider<TaxRepository>(create: (_) => TaxRepository()),
        // Global BLoCs
        BlocProvider<DashboardCubit>(
          create: (context) => DashboardCubit(
            incomeRepo: context.read<IncomeRepository>(),
            expenseRepo: context.read<ExpenseRepository>(),
            goalRepo: context.read<GoalRepository>(),
          ),
        ),
        BlocProvider<IncomeCubit>(
          create: (context) => IncomeCubit(context.read<IncomeRepository>()),
        ),
        BlocProvider<ExpenseCubit>(
          create: (context) => ExpenseCubit(context.read<ExpenseRepository>()),
        ),
        BlocProvider<GoalCubit>(
          create: (context) => GoalCubit(context.read<GoalRepository>()),
        ),
        BlocProvider<TaxCubit>(
          create: (context) => TaxCubit(context.read<TaxRepository>()),
        ),
      ],
      child: MyApp(initialRoute: _initialRoute!),
    );
  }
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(414, 896),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return BlocBuilder<ThemeCubit, AppThemeType>(
          builder: (context, appThemeType) {
            final themeData = AppTheme.getTheme(appThemeType);

            return RepositoryProvider(
              create: (context) => AuthRepository(),
              child: MaterialApp.router(
                title: 'Finance Manager',
                theme: themeData,
                darkTheme: ThemeData.dark(),
                themeMode: ThemeMode.light,
                routerConfig: appRouter,
                debugShowCheckedModeBanner: false,
              ),
            );
          },
        );
      },
    );
  }
}
