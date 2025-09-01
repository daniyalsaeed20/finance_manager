import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../strings.dart';
import '../../utils/branding.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key, required this.child});
  final Widget child;

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _wasDrawerOpen = false;

  @override
  void initState() {
    super.initState();

    // Restore drawer state after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _restoreDrawerState();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Update index from route after dependencies are available
    _updateIndexFromRoute();
  }

  void _restoreDrawerState() {
    if (_wasDrawerOpen && _scaffoldKey.currentState != null) {
      // Small delay to ensure scaffold is ready
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted && _wasDrawerOpen) {
          _scaffoldKey.currentState!.openDrawer();
        }
      });
    }
  }

  void _updateIndexFromRoute() {
    try {
      final location = GoRouterState.of(context).uri.path;
      switch (location) {
        case '/home':
        case '/home/dashboard':
          if (_index != 0) setState(() => _index = 0);
          break;
        case '/home/income':
          if (_index != 1) setState(() => _index = 1);
          break;
        case '/home/expenses':
          if (_index != 2) setState(() => _index = 2);
          break;
        case '/home/reports':
          if (_index != 3) setState(() => _index = 3);
          break;
      }
    } catch (e) {
      // If GoRouterState is not available yet, just skip the update
      debugPrint('⚠️ Route update skipped: $e');
    }
  }

  void _onTap(int idx) {
    if (_index == idx) return; // Prevent unnecessary navigation

    setState(() => _index = idx);
    switch (idx) {
      case 0:
        context.go('/home/dashboard');
        break;
      case 1:
        context.go('/home/income');
        break;
      case 2:
        context.go('/home/expenses');
        break;
      case 3:
        context.go('/home/reports');
        break;
    }
  }

  String _getAppBarTitle() {
    try {
      final location = GoRouterState.of(context).uri.path;
      switch (location) {
        case '/home':
        case '/home/dashboard':
          return kDashboardLabel;
        case '/home/income':
          return kIncomeLabel;
        case '/home/expenses':
          return kExpensesLabel;
        case '/home/reports':
          return kReportsLabel;
        default:
          return kAppName;
      }
    } catch (e) {
      // If GoRouterState is not available yet, return default title
      debugPrint('⚠️ AppBar title update skipped: $e');
      return kAppName;
    }
  }

  bool _shouldShowBottomNavigation() {
    try {
      final location = GoRouterState.of(context).uri.path;
      // Only show bottom navigation on primary screens
      return location == '/home' ||
          location == '/home/dashboard' ||
          location == '/home/income' ||
          location == '/home/expenses' ||
          location == '/home/reports';
    } catch (e) {
      // If GoRouterState is not available yet, show bottom navigation by default
      debugPrint('⚠️ Bottom navigation check skipped: $e');
      return true;
    }
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
            ),
            child: Branding.logo(context: context),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard_outlined),
            title: Text(kDashboardLabel),
            onTap: () {
              Navigator.pop(context);
              context.go('/home/dashboard');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.flag_outlined),
            title: Text(kGoalsLabel),
            onTap: () {
              debugPrint('🎯 Drawer: Navigating to Goals');
              // Track that drawer was open when navigating
              _wasDrawerOpen = true;
              Navigator.pop(context);
              // Use push to maintain navigation stack
              context.push('/home/goals');
            },
          ),
          ListTile(
            leading: const Icon(Icons.business_outlined),
            title: const Text(kBusinessManagerLabel),
            onTap: () {
              debugPrint('🏢 Drawer: Navigating to Business Manager');
              // Track that drawer was open when navigating
              _wasDrawerOpen = true;
              Navigator.pop(context);
              // Use push to maintain navigation stack
              context.push('/home/business');
            },
          ),
          ListTile(
            leading: const Icon(Icons.calculate_outlined),
            title: const Text(kTaxesLabel),
            onTap: () {
              debugPrint('🧮 Drawer: Navigating to Taxes');
              // Track that drawer was open when navigating
              _wasDrawerOpen = true;
              Navigator.pop(context);
              // Use push to maintain navigation stack
              context.push('/home/taxes');
            },
          ),
          ListTile(
            leading: const Icon(Icons.folder_open_outlined),
            title: const Text(kExportedFilesLabel),
            onTap: () {
              debugPrint('📁 Drawer: Navigating to Exported Files');
              // Track that drawer was open when navigating
              _wasDrawerOpen = true;
              Navigator.pop(context);
              // Use push to maintain navigation stack
              context.push('/home/exported-files');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: const Text(kSettingsLabel),
            onTap: () {
              debugPrint('⚙️ Drawer: Navigating to Settings');
              // Track that drawer was open when navigating
              _wasDrawerOpen = true;
              Navigator.pop(context);
              // Use push to maintain navigation stack
              context.push('/home/settings');
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text(_getAppBarTitle())),
      drawer: _buildDrawer(),
      onDrawerChanged: (isOpened) {
        // Track when drawer is manually opened/closed
        if (!isOpened) {
          _wasDrawerOpen = false;
        }
      },
      body: widget.child,
      bottomNavigationBar: _shouldShowBottomNavigation()
          ? BottomNavigationBar(
              currentIndex: _index,
              onTap: _onTap,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.dashboard_outlined),
                  label: kDashboardLabel,
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.attach_money_outlined),
                  label: kIncomeLabel,
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.receipt_long_outlined),
                  label: kExpensesLabel,
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.assessment_outlined),
                  label: kReportsLabel,
                ),
              ],
            )
          : null,
    );
  }
}
