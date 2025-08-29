import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key, required this.child});
  final Widget child;

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  void _onTap(int idx) {
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
      case 4:
        context.go('/home/settings');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: _onTap,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard_outlined), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.attach_money_outlined), label: 'Income'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long_outlined), label: 'Expenses'),
          BottomNavigationBarItem(icon: Icon(Icons.picture_as_pdf_outlined), label: 'Reports'),
          BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), label: 'Settings'),
        ],
      ),
    );
  }
}

