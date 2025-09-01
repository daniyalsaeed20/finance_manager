import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../strings.dart';

import '../../cubits/income_cubit.dart';
import '../../models/income_models.dart';
import '../../utils/formatting.dart';
import '../../utils/amount_input_formatter.dart';
import '../../services/user_manager.dart';

class IncomeScreen extends StatefulWidget {
  const IncomeScreen({super.key});

  @override
  State<IncomeScreen> createState() => _IncomeScreenState();
}

class _IncomeScreenState extends State<IncomeScreen> {
  DateTime _selectedMonth = DateTime.now();
  bool _isAddExpanded = false;

  @override
  void initState() {
    super.initState();
    // Load initial data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = UserManager.instance.currentUserId;
      context.read<IncomeCubit>()
        ..loadTemplates(userId)
        ..refreshRange(
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      setState(() {
                        _selectedMonth = DateTime(
                          _selectedMonth.year,
                          _selectedMonth.month - 1,
                        );
                      });
                      final userId = UserManager.instance.currentUserId;
                      context.read<IncomeCubit>().refreshRange(
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
                            setState(() {
                              _selectedMonth = DateTime(
                                _selectedMonth.year,
                                _selectedMonth.month + 1,
                              );
                            });
                            final userId = UserManager.instance.currentUserId;
                            context.read<IncomeCubit>().refreshRange(
                              DateTime(
                                _selectedMonth.year,
                                _selectedMonth.month,
                                1,
                              ),
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
                onPressed: () => context.push('/home/business'),
                icon: const Icon(Icons.work, size: 18),
                label: Text(kManageServicesLabel),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                ),
              ),
            ),

            // Add Income Expandable Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Card(
                child: ExpansionTile(
                  title: const Text('Add Income'),
                  leading: const Icon(Icons.add),
                  initiallyExpanded: _isAddExpanded,
                  onExpansionChanged: (expanded) {
                    setState(() {
                      _isAddExpanded = expanded;
                    });
                  },
                  children: [
                    _AddIncomeForm(
                      key: ValueKey(
                        '${_selectedMonth.year}-${_selectedMonth.month}',
                      ),
                      onSubmitted: () {
                        setState(() {
                          _isAddExpanded = false;
                        });
                      },
                      selectedMonth: _selectedMonth,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Income Records List
            BlocBuilder<IncomeCubit, IncomeState>(
              builder: (context, state) {
                if (state.loading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state.incomeRecords.isEmpty) {
                  return const Center(child: Text(kNoIncomeRecordsLabel));
                }

                return Column(
                  children: state.incomeRecords
                      .map(
                        (record) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: _IncomeRecordTile(
                            record: record,
                            onTap: () => _editIncomeRecord(record),
                          ),
                        ),
                      )
                      .toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectMonth() async {
    final picked = await showDatePicker(
      context: context,
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
      context.read<IncomeCubit>().refreshRange(
        DateTime(_selectedMonth.year, _selectedMonth.month, 1),
        DateTime(_selectedMonth.year, _selectedMonth.month + 1, 0, 23, 59, 59),
        userId,
      );
    }
  }

  Future<void> _editIncomeRecord(IncomeRecord record) async {
    final result = await context.push('/home/income/edit/${record.id}');
    if (result == true && mounted) {
      // Refresh data when returning from edit screen
      final userId = UserManager.instance.currentUserId;
      context.read<IncomeCubit>().refreshRange(
        DateTime(_selectedMonth.year, _selectedMonth.month, 1),
        DateTime(_selectedMonth.year, _selectedMonth.month + 1, 0, 23, 59, 59),
        userId,
      );
    }
  }
}

class _AddIncomeForm extends StatefulWidget {
  final VoidCallback onSubmitted;
  final DateTime selectedMonth;

  const _AddIncomeForm({
    super.key,
    required this.onSubmitted,
    required this.selectedMonth,
  });

  @override
  State<_AddIncomeForm> createState() => _AddIncomeFormState();
}

class _AddIncomeFormState extends State<_AddIncomeForm> {
  final _tipController = TextEditingController();
  final _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  final Map<String, int> _serviceCounts = {};

  @override
  void initState() {
    super.initState();
    // Set default date based on current month selection
    _updateDefaultDate();
  }

  void _updateDefaultDate() {
    final currentMonth = DateTime.now();
    final selectedMonth = widget.selectedMonth;

    debugPrint('_updateDefaultDate called');
    debugPrint('Current month: ${currentMonth.month}/${currentMonth.year}');
    debugPrint('Selected month: ${selectedMonth.month}/${selectedMonth.year}');
    debugPrint('Previous _selectedDate: $_selectedDate');

    if (selectedMonth.month == currentMonth.month &&
        selectedMonth.year == currentMonth.year) {
      // If viewing current month, use current date
      _selectedDate = DateTime.now();
      debugPrint('Using current date: $_selectedDate');
    } else {
      // If viewing different month, use first day of that month
      _selectedDate = DateTime(selectedMonth.year, selectedMonth.month, 1);
      debugPrint('Using first day of selected month: $_selectedDate');
    }

    debugPrint('New _selectedDate: $_selectedDate');

    // Reset service counts when month changes - but do it after a frame to ensure templates are loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _resetServiceCounts();
    });
  }

  void _resetServiceCounts() {
    debugPrint('_resetServiceCounts called');
    debugPrint('Previous _serviceCounts: $_serviceCounts');

    _serviceCounts.clear();
    // Reinitialize with current templates
    final state = context.read<IncomeCubit>().state;
    final activeTemplates = state.templates.where((t) => t.active).toList();

    debugPrint(
      'Active templates: ${activeTemplates.map((t) => t.name).toList()}',
    );

    for (final template in activeTemplates) {
      _serviceCounts[template.name] = 0;
    }

    debugPrint('New _serviceCounts: $_serviceCounts');
    setState(() {});
  }

  void _initializeServiceCounts(List<ServiceTemplate> templates) {
    debugPrint(
      '_initializeServiceCounts called with ${templates.length} templates',
    );
    if (_serviceCounts.isEmpty) {
      for (final template in templates) {
        _serviceCounts[template.name] = 0;
      }
      debugPrint('Initialized _serviceCounts: $_serviceCounts');
      setState(() {});
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    debugPrint(
      'didChangeDependencies called for month: ${widget.selectedMonth.month}/${widget.selectedMonth.year}',
    );
    // Update date when dependencies change (e.g., month navigation)
    _updateDefaultDate();
  }

  @override
  void dispose() {
    _tipController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IncomeCubit, IncomeState>(
      builder: (context, state) {
        final activeTemplates = state.templates.where((t) => t.active).toList();

        // Ensure service counts are initialized when templates become available
        if (activeTemplates.isNotEmpty && _serviceCounts.isEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              _initializeServiceCounts(activeTemplates);
            }
          });
        }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Date picker
              ListTile(
                title: const Text('Date'),
                subtitle: Text(formatShortDate(_selectedDate)),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDate(),
              ),

              const SizedBox(height: 16),

              // Service selection with counts
              Text('Services', style: Theme.of(context).textTheme.titleMedium),
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
                              formatCurrencySync(template.defaultPriceMinor),
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
                                  icon: const Icon(Icons.remove_circle_outline),
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
                                      _serviceCounts[template.name] = count + 1;
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
                        ..._serviceCounts.entries.where((e) => e.value > 0).map(
                          (entry) {
                            final template = context
                                .read<IncomeCubit>()
                                .state
                                .templates
                                .firstWhere((t) => t.name == entry.key);
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
                                  Text(formatCurrencySync(serviceTotal)),
                                ],
                              ),
                            );
                          },
                        ),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(kTotalServicesLabel),
                            Text(
                              formatCurrencySync(_calculateServicesTotal()),
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
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
                onSubmitted: (_) => _addIncome(),
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
                onSubmitted: (_) => _addIncome(),
              ),

              const SizedBox(height: 16),

              // Add button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _canSubmit() ? () => _addIncome() : null,
                  child: const Text('Add Income'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  bool _canSubmit() {
    final canSubmit =
        _serviceCounts.isNotEmpty &&
        _serviceCounts.values.any((count) => count > 0);

    // Debug information
    debugPrint('_canSubmit: $canSubmit');
    debugPrint('_serviceCounts: $_serviceCounts');
    debugPrint('_serviceCounts.isEmpty: ${_serviceCounts.isEmpty}');
    debugPrint(
      '_serviceCounts.values.any((count) => count > 0): ${_serviceCounts.values.any((count) => count > 0)}',
    );

    return canSubmit;
  }

  int _calculateServicesTotal() {
    int total = 0;
    for (final entry in _serviceCounts.entries) {
      if (entry.value > 0) {
        final template = context.read<IncomeCubit>().state.templates.firstWhere(
          (t) => t.name == entry.key,
        );
        total += template.defaultPriceMinor * entry.value;
      }
    }
    return total;
  }

  void _addIncome() {
    debugPrint('_addIncome called');
    debugPrint('_serviceCounts: $_serviceCounts');
    debugPrint('_selectedDate: $_selectedDate');
    debugPrint('Can submit: ${_canSubmit()}');

    final tip = double.tryParse(_tipController.text) ?? 0;
    final tipMinor = (tip * 100).round();

    final services = <IncomeServiceCount>[];
    for (final entry in _serviceCounts.entries) {
      if (entry.value > 0) {
        final template = context.read<IncomeCubit>().state.templates.firstWhere(
          (t) => t.name == entry.key,
        );
        services.add(
          IncomeServiceCount()
            ..serviceName = entry.key
            ..priceMinor = template.defaultPriceMinor
            ..count = entry.value,
        );
      }
    }

    final userId = UserManager.instance.currentUserId;
    final currentState = context.read<IncomeCubit>().state;

    // Check if there's already an income record for the same date
    IncomeRecord? existingRecord;
    try {
      existingRecord = currentState.incomeRecords.firstWhere(
        (record) =>
            record.date.year == _selectedDate.year &&
            record.date.month == _selectedDate.month &&
            record.date.day == _selectedDate.day &&
            record.userId == userId,
      );
    } catch (e) {
      // No existing record found
      existingRecord = null;
    }

    if (existingRecord != null) {
      // Merge with existing record
      final mergedServices = <IncomeServiceCount>[];

      // Create a map of existing services
      final existingServicesMap = <String, IncomeServiceCount>{};
      for (final service in existingRecord.services) {
        existingServicesMap[service.serviceName] = service;
      }

      // Add new services or update existing ones
      for (final newService in services) {
        if (existingServicesMap.containsKey(newService.serviceName)) {
          // Update existing service count
          final existingService = existingServicesMap[newService.serviceName]!;
          existingService.count += newService.count;
          mergedServices.add(existingService);
        } else {
          // Add new service
          mergedServices.add(newService);
        }
      }

      // Add remaining existing services that weren't updated
      for (final existingService in existingServicesMap.values) {
        if (!mergedServices.any(
          (s) => s.serviceName == existingService.serviceName,
        )) {
          mergedServices.add(existingService);
        }
      }

      // Create merged record
      final mergedRecord = existingRecord
        ..services = mergedServices
        ..tipMinor += tipMinor
        ..note = _noteController.text.isEmpty
            ? existingRecord.note
            : '${existingRecord.note ?? ''}${existingRecord.note != null ? ' | ' : ''}${_tipController.text}';

      // Update the existing record
      debugPrint('Updating existing income record:');
      debugPrint('  ID: ${mergedRecord.id}');
      debugPrint('  Date: ${mergedRecord.date}');
      debugPrint('  Services count: ${mergedRecord.services.length}');
      debugPrint('  Tip: ${mergedRecord.tipMinor}');
      debugPrint('  Note: ${mergedRecord.note}');
      debugPrint('  UserId: ${mergedRecord.userId}');

      debugPrint('Calling cubit.updateIncome...');
      context.read<IncomeCubit>().updateIncome(mergedRecord);
      debugPrint('cubit.updateIncome called successfully');
    } else {
      // Create new record
      final record = IncomeRecord()
        ..date = _selectedDate
        ..services = services
        ..tipMinor = tipMinor
        ..note = _noteController.text.isEmpty ? null : _noteController.text
        ..userId = userId;

      debugPrint('Creating new income record:');
      debugPrint('  Date: ${record.date}');
      debugPrint('  Services count: ${record.services.length}');
      debugPrint('  Tip: ${record.tipMinor}');
      debugPrint('  Note: ${record.note}');
      debugPrint('  UserId: ${record.userId}');

      debugPrint('Calling cubit.addIncome...');
      context.read<IncomeCubit>().addIncome(record);
      debugPrint('cubit.addIncome called successfully');
    }

    // Reset form
    _tipController.clear();
    _noteController.clear();
    for (final key in _serviceCounts.keys) {
      _serviceCounts[key] = 0;
    }
    setState(() {});

    // Collapse the expansion tile after successful submission
    widget.onSubmitted();

    // Close keyboard
    FocusScope.of(context).unfocus();
  }

  Future<void> _selectDate() async {
    // Allow selecting dates in the selected month, not just up to current date
    final lastDate = DateTime(
      widget.selectedMonth.year,
      widget.selectedMonth.month + 1,
      0,
    );
    final firstDate = DateTime(
      widget.selectedMonth.year,
      widget.selectedMonth.month,
      1,
    );

    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }
}

class _IncomeRecordTile extends StatelessWidget {
  final IncomeRecord record;
  final VoidCallback onTap;

  const _IncomeRecordTile({required this.record, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onTap,
        title: Text(formatShortDate(record.date)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Services list with proper alignment
            ...record.services.map(
              (service) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        '${service.serviceName} x${service.count}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    Text(
                      formatCurrencySync(service.priceMinor * service.count),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Tip (if any) - shown in services section
            if (record.tipMinor > 0) ...[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      kTipLabel2,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Text(
                      formatCurrencySync(record.tipMinor),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // Divider before total
            if (record.services.isNotEmpty) ...[
              const Divider(height: 16, thickness: 1),
            ],

            // Total amount
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total:',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  formatCurrencySync(record.totalMinor),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            // Note (if any)
            if (record.note != null) ...[
              const SizedBox(height: 8),
              Text(
                '$kNoteLabel2${record.note}',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
