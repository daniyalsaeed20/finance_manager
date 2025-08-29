import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../services/app_lock_manager.dart';
import '../../services/notification_service.dart';
import '../app_theme.dart';
import '../theme_cubit/theme_cubit.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeCubit = context.watch<ThemeCubit>();
    final currentTheme = themeCubit.state;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          const ListTile(title: Text('Theme')),
          ...AppThemeType.values.map((themeType) {
            return RadioListTile<AppThemeType>(
              title: Text(themeType.name),
              value: themeType,
              groupValue: currentTheme,
              onChanged: (selected) {
                if (selected != null) {
                  themeCubit.setTheme(selected);
                }
              },
            );
          }),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.flag_outlined),
            title: const Text('Monthly Goal'),
            onTap: () => context.go('/home/goals'),
          ),
          ListTile(
            leading: const Icon(Icons.account_balance_outlined),
            title: const Text('Tax Planning'),
            onTap: () => context.go('/home/taxes'),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.lock_outline),
            title: const Text('Enable App Lock (Biometrics)'),
            onTap: () async {
              final enabled = await AppLockManager.instance.isEnabled();
              await AppLockManager.instance.setEnabled(!enabled);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(!enabled ? 'App lock enabled' : 'App lock disabled')),
                );
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.notifications_active_outlined),
            title: const Text('Schedule Daily Reminder'),
            onTap: () async {
              final now = TimeOfDay.now();
              final picked = await showTimePicker(context: context, initialTime: now);
              if (picked != null) {
                await NotificationService.instance.scheduleDailyReminder(hour: picked.hour, minute: picked.minute);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Reminder set for ${picked.format(context)}')),
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
