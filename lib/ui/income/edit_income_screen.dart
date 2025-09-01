import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../strings.dart';

import '../../cubits/income_cubit.dart';
import '../../models/income_models.dart';
import '../../utils/formatting.dart';
import '../../utils/amount_input_formatter.dart';
import '../../services/user_manager.dart';

class EditIncomeScreen extends StatefulWidget {
  final int incomeId;

  const EditIncomeScreen({super.key, required this.incomeId});

  @override
  State<EditIncomeScreen> createState() => _EditIncomeScreenState();
}

class _EditIncomeScreenState extends State<EditIncomeScreen> {
  IncomeRecord? _record;
  late DateTime _selectedDate;
  late final TextEditingController _tipController;
  late final TextEditingController _noteController;
  late final Map<String, int> _serviceCounts;

  @override
  void initState() {
    super.initState();
    _tipController = TextEditingController();
    _noteController = TextEditingController();
    _serviceCounts = {};
    _loadIncome();
  }

  Future<void> _loadIncome() async {
    // Load the income data from the cubit state
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = context.read<IncomeCubit>().state;
      final record = state.incomeRecords.firstWhere(
        (r) => r.id == widget.incomeId,
        orElse: () => IncomeRecord(),
      );

      if (record.id != 0) {
        setState(() {
          _record = record;
          _selectedDate = record.date;
          _tipController.text = (record.tipMinor / 100).toString();
          _noteController.text = record.note ?? '';

          // Initialize service counts from the record
          _serviceCounts.clear();
          for (final service in record.services) {
            _serviceCounts[service.serviceName] = service.count;
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _tipController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_record == null) {
      return Scaffold(
        appBar: AppBar(title: Text(kEditIncomeLabel)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(kEditIncomeLabel)),
      body: BlocBuilder<IncomeCubit, IncomeState>(
        builder: (context, state) {
          final activeTemplates = state.templates
              .where((t) => t.active)
              .toList();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Date picker
                ListTile(
                  title: Text(kDateLabel),
                  subtitle: Text(formatShortDate(_selectedDate)),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () => _selectDate(),
                ),

                const SizedBox(height: 16),

                // Service selection with counts
                Text(
                  'Services',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                if (activeTemplates.isEmpty)
                  const Card(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'No services available. Please add services in the Services section.',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  )
                else
                  Wrap(
                    spacing: 8.0,
                    children: activeTemplates.map((template) {
                      final count = _serviceCounts[template.name] ?? 0;
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text(
                                template.name,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              Text(
                                formatCurrencyMinor(template.defaultPriceMinor),
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    onPressed: count > 0
                                        ? () {
                                            setState(() {
                                              _serviceCounts[template.name] =
                                                  count - 1;
                                            });
                                          }
                                        : null,
                                    icon: const Icon(
                                      Icons.remove_circle_outline,
                                    ),
                                    iconSize: 20,
                                  ),
                                  Text(
                                    count.toString(),
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleMedium,
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _serviceCounts[template.name] =
                                            count + 1;
                                      });
                                    },
                                    icon: const Icon(Icons.add_circle_outline),
                                    iconSize: 20,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                const SizedBox(height: 16),

                // Total calculation
                if (_serviceCounts.isNotEmpty)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total Calculation',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          ..._serviceCounts.entries
                              .where((e) => e.value > 0)
                              .map((entry) {
                                final template = context
                                    .read<IncomeCubit>()
                                    .state
                                    .templates
                                    .firstWhere(
                                      (t) => t.name == entry.key,
                                      orElse: () => ServiceTemplate()
                                        ..name = entry.key
                                        ..defaultPriceMinor = 0,
                                    );
                                final serviceTotal =
                                    template.defaultPriceMinor * entry.value;
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 2.0,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('${entry.key} x${entry.value}'),
                                      Text(formatCurrencyMinor(serviceTotal)),
                                    ],
                                  ),
                                );
                              }),
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Total Services:'),
                              FutureBuilder<String>(
                                future: formatCurrency(
                                  _calculateServicesTotal(),
                                ),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return Text(
                                      snapshot.data!,
                                      style: TextStyle(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    );
                                  }
                                  return const Text('Loading...');
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                const SizedBox(height: 16),

                // Tip input
                TextField(
                  controller: _tipController,
                  decoration: const InputDecoration(
                    labelText: 'Tip (e.g., 5.00)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [AmountInputFormatter()],
                  textInputAction: TextInputAction.done,
                ),

                const SizedBox(height: 8),

                // Note input
                TextField(
                  controller: _noteController,
                  decoration: const InputDecoration(
                    labelText: 'Note (optional)',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                  textInputAction: TextInputAction.done,
                ),

                const SizedBox(height: 32),

                // Save button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _canSubmit() ? _saveIncome : null,
                    child: const Text('Save Changes'),
                  ),
                ),

                const SizedBox(height: 16),

                // Delete button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: _deleteIncome,
                    child: const Text('Delete Income'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  bool _canSubmit() {
    final canSubmit =
        _serviceCounts.isNotEmpty &&
        _serviceCounts.values.any((count) => count > 0);

    return canSubmit;
  }

  int _calculateServicesTotal() {
    int total = 0;
    for (final entry in _serviceCounts.entries) {
      if (entry.value > 0) {
        final template = context.read<IncomeCubit>().state.templates.firstWhere(
          (t) => t.name == entry.key,
          orElse: () => ServiceTemplate()
            ..name = entry.key
            ..defaultPriceMinor = 0,
        );
        total += template.defaultPriceMinor * entry.value;
      }
    }
    return total;
  }

  Future<void> _saveIncome() async {
    if (!_canSubmit()) return;

    final tip = double.tryParse(_tipController.text) ?? 0;
    final tipMinor = (tip * 100).round();

    final services = <IncomeServiceCount>[];
    for (final entry in _serviceCounts.entries) {
      if (entry.value > 0) {
        final template = context.read<IncomeCubit>().state.templates.firstWhere(
          (t) => t.name == entry.key,
          orElse: () => ServiceTemplate()
            ..name = entry.key
            ..defaultPriceMinor = 0,
        );
        services.add(
          IncomeServiceCount()
            ..serviceName = entry.key
            ..priceMinor = template.defaultPriceMinor
            ..count = entry.value,
        );
      }
    }

    if (_record == null) return;

    final updatedRecord = _record!
      ..date = _selectedDate
      ..services = services
      ..tipMinor = tipMinor
      ..note = _noteController.text.isEmpty ? null : _noteController.text;

    try {
      context.read<IncomeCubit>().updateIncome(updatedRecord);

      // Navigate back with result to trigger refresh
      context.pop(true);
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating income: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _deleteIncome() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Income'),
        content: const Text(
          'Are you sure you want to delete this income record? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop(); // Close dialog
              if (_record != null) {
                try {
                  final userId = UserManager.instance.currentUserId;
                  context.read<IncomeCubit>().deleteIncome(_record!.id, userId);

                  // Navigate back with result to trigger refresh
                  context.pop(true);
                } catch (e) {
                  // Show error message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error deleting income: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }
}
