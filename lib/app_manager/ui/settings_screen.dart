import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../services/user_manager.dart';
import '../../services/currency_service.dart';
import '../app_theme.dart';
import '../theme_cubit/theme_cubit.dart';

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
        title: const Text('Settings'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _showLogoutDialog,
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Theme Settings
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Appearance',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  BlocBuilder<ThemeCubit, AppThemeType>(
                    builder: (context, state) {
                      return Column(
                        children: [
                          ListTile(
                            title: const Text('Light Theme'),
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
                            title: const Text('Dark Theme'),
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
                            title: const Text('System Theme'),
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
                    'Currency',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Choose your preferred currency for displaying amounts throughout the app.',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  StreamBuilder<Currency>(
                    stream: CurrencyService.currencyStream,
                    builder: (context, snapshot) {
                      return FutureBuilder<Currency>(
                        future: CurrencyService.getUserCurrency(),
                        builder: (context, asyncSnapshot) {
                          final currentCurrency = snapshot.data ?? asyncSnapshot.data;
                          if (currentCurrency != null) {
                            return ListTile(
                              title: const Text('Current Currency'),
                              subtitle: Text(
                                '${currentCurrency.name} (${currentCurrency.symbol})',
                              ),
                              trailing: const Icon(Icons.currency_exchange),
                              onTap: () => _showCurrencySelector(),
                            );
                          }
                          return const ListTile(
                            title: Text('Current Currency'),
                            subtitle: Text('Loading...'),
                            trailing: Icon(Icons.currency_exchange),
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
                  Text('About', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 16),
                  ListTile(
                    title: const Text('Version'),
                    subtitle: const Text('1.0.0'),
                    leading: const Icon(Icons.info_outline),
                  ),
                  ListTile(
                    title: const Text('Developer'),
                    subtitle: const Text('Finance Manager'),
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
        title: const Text('Logout'),
        content: const Text(
          'Are you sure you want to logout? All data will remain on this device.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              await UserManager.instance.signOut();
              if (mounted) {
                Navigator.pop(context); // Close dialog
                context.go('/auth'); // Navigate to auth screen
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Logout'),
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
                  'Select Currency',
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
                      await CurrencyService.setUserCurrency(currency.code);
                      if (mounted) {
                        Navigator.pop(context);
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
