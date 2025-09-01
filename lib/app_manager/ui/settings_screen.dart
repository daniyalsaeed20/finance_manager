import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../strings.dart';

import '../../services/user_manager.dart';
import '../../services/currency_service.dart';
import '../app_theme.dart';
import '../theme_cubit/theme_cubit.dart';
import '../../utils/branding.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(kSettingsLabel),
        actions: [
          IconButton(
            onPressed: _showLogoutDialog,
            icon: const Icon(Icons.logout),
            tooltip: kLogoutLabel,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // App Logo Section
          Card(
            child: Branding.logo(width: 200.w, height: 200.h, context: context),
          ),

          const SizedBox(height: 16),

          // Theme Settings
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    kAppearanceLabel,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  BlocBuilder<ThemeCubit, AppThemeType>(
                    builder: (context, state) {
                      return Column(
                        children: [
                          ListTile(
                            title: Text(kLightThemeLabel),
                            leading: Radio<AppThemeType>(
                              value: AppThemeType.light,
                              groupValue: state,
                              onChanged: (value) {
                                if (value != null) {
                                  context.read<ThemeCubit>().setTheme(value);
                                }
                              },
                            ),
                          ),
                          ListTile(
                            title: Text(kDarkThemeLabel),
                            leading: Radio<AppThemeType>(
                              value: AppThemeType.dark,
                              groupValue: state,
                              onChanged: (value) {
                                if (value != null) {
                                  context.read<ThemeCubit>().setTheme(value);
                                }
                              },
                            ),
                          ),
                          ListTile(
                            title: Text(kSystemThemeLabel),
                            leading: Radio<AppThemeType>(
                              value: AppThemeType.system,
                              groupValue: state,
                              onChanged: (value) {
                                if (value != null) {
                                  context.read<ThemeCubit>().setTheme(value);
                                }
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Currency Settings
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    kCurrencyLabel,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    kChooseCurrencyLabel,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 16),
                  StreamBuilder<Currency>(
                    stream: CurrencyService.currencyStream,
                    builder: (context, snapshot) {
                      return FutureBuilder<Currency>(
                        future: CurrencyService.getUserCurrency(),
                        builder: (context, asyncSnapshot) {
                          final currentCurrency =
                              snapshot.data ?? asyncSnapshot.data;
                          if (currentCurrency != null) {
                            return ListTile(
                              title: Text(kCurrentCurrencyLabel),
                              subtitle: Text(
                                '${currentCurrency.name} (${currentCurrency.symbol})',
                              ),
                              trailing: const Icon(Icons.currency_exchange),
                              onTap: () => _showCurrencySelector(),
                            );
                          }
                          return ListTile(
                            title: Text(kCurrentCurrencyLabel),
                            subtitle: const Text('Loading...'),
                            trailing: const Icon(Icons.currency_exchange),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // About Section
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    kAboutLabel,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    title: Text(kVersionLabel),
                    subtitle: Text(kAppVersion),
                    leading: const Icon(Icons.info_outline),
                  ),
                  ListTile(
                    title: Text(kDeveloperLabel),
                    subtitle: Text(kDeveloperName),
                    leading: const Icon(Icons.person_outline),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(kLogoutLabel),
        content: Text(kLogoutConfirmLabel),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(kCancelLabel2),
          ),
          ElevatedButton(
            onPressed: () async {
              final navigator = Navigator.of(context);
              final router = GoRouter.of(context);
              await UserManager.instance.signOut();
              if (mounted) {
                navigator.pop(); // Close dialog
                router.go('/auth'); // Navigate to auth screen
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            child: Text(kLogoutLabel),
          ),
        ],
      ),
    );
  }

  void _showCurrencySelector() {
    showDialog(
      context: context,
      builder: (context) => const _CurrencySelectorDialog(),
    );
  }
}

class _CurrencySelectorDialog extends StatefulWidget {
  const _CurrencySelectorDialog();

  @override
  State<_CurrencySelectorDialog> createState() =>
      _CurrencySelectorDialogState();
}

class _CurrencySelectorDialogState extends State<_CurrencySelectorDialog> {
  final TextEditingController _searchController = TextEditingController();
  List<Currency> _filteredCurrencies = CurrencyService.allCurrencies;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
      _filteredCurrencies = CurrencyService.searchCurrencies(_searchQuery);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: double.maxFinite,
        height: MediaQuery.of(context).size.height * 0.8,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  kSelectCurrencyLabel,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search currencies...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _filteredCurrencies.length,
                itemBuilder: (context, index) {
                  final currency = _filteredCurrencies[index];
                  return ListTile(
                    title: Text(currency.name),
                    subtitle: Text('${currency.code} - ${currency.symbol}'),
                    trailing: Text(
                      currency.symbol,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    onTap: () async {
                      final navigator = Navigator.of(context);
                      await CurrencyService.setUserCurrency(currency.code);
                      if (mounted) {
                        navigator.pop();
                        setState(() {}); // Refresh the settings screen
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
