import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubits/income_cubit.dart';
import '../../models/income_models.dart';
import '../../repositories/income_repository.dart';
import '../../utils/formatting.dart';

class IncomeScreen extends StatelessWidget {
  const IncomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => IncomeCubit(IncomeRepository())
        ..loadTemplates()
        ..refreshRange(DateTime.now().subtract(const Duration(days: 6)), DateTime.now()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Income'),
          actions: [
            IconButton(
              onPressed: () => _showServiceTemplatesDialog(context),
              icon: const Icon(Icons.settings),
              tooltip: 'Manage Services',
            ),
          ],
        ),
        floatingActionButton: const _AddIncomeButton(),
        body: BlocBuilder<IncomeCubit, IncomeState>(
          builder: (context, state) {
            if (state.loading) return const Center(child: CircularProgressIndicator());
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text('This Week Total: ${formatCurrencyMinor(state.totalMinor)}'),
                const SizedBox(height: 12),
                for (final r in state.incomeRecords)
                  Card(
                    child: ListTile(
                      title: Text(formatShortDate(r.date)),
                      subtitle: Text('${r.services.length} services, tip ${formatCurrencyMinor(r.tipMinor)}'),
                      trailing: Text(formatCurrencyMinor(r.totalMinor)),
                    ),
                  ),
                const SizedBox(height: 100),
              ],
            );
          },
        ),
      ),
    );
  }

  void _showServiceTemplatesDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => const _ServiceTemplatesDialog(),
    );
  }
}

class _ServiceTemplatesDialog extends StatefulWidget {
  const _ServiceTemplatesDialog();

  @override
  State<_ServiceTemplatesDialog> createState() => _ServiceTemplatesDialogState();
}

class _ServiceTemplatesDialogState extends State<_ServiceTemplatesDialog> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  int _sortOrder = 0;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Service Templates', style: Theme.of(context).textTheme.titleLarge),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Add new service form
            Text('Add New Service', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Service Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _priceController,
              decoration: const InputDecoration(
                labelText: 'Default Price (e.g., 25.00)',
                border: OutlineInputBorder(),
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 8),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Sort Order (optional)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) => _sortOrder = int.tryParse(value) ?? 0,
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final name = _nameController.text.trim();
                  final price = double.tryParse(_priceController.text) ?? 0.0;
                  if (name.isNotEmpty && price > 0) {
                    final template = ServiceTemplate()
                      ..name = name
                      ..defaultPriceMinor = (price * 100).round()
                      ..sortOrder = _sortOrder
                      ..active = true;
                    
                    context.read<IncomeCubit>().addOrUpdateTemplate(template);
                    _nameController.clear();
                    _priceController.clear();
                    _sortOrder = 0;
                  }
                },
                child: const Text('Add Service'),
              ),
            ),
            const SizedBox(height: 24),
            
            // Existing services list
            Text('Existing Services', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            BlocBuilder<IncomeCubit, IncomeState>(
              builder: (context, state) {
                return Column(
                  children: [
                    for (final template in state.templates)
                      Card(
                        child: ListTile(
                          title: Text(template.name),
                          subtitle: Text('${formatCurrencyMinor(template.defaultPriceMinor)} • Order: ${template.sortOrder}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Switch(
                                value: template.active,
                                onChanged: (value) {
                                  final updated = template..active = value;
                                  context.read<IncomeCubit>().addOrUpdateTemplate(updated);
                                },
                              ),
                              IconButton(
                                onPressed: () => context.read<IncomeCubit>().removeTemplate(template.id),
                                icon: const Icon(Icons.delete_outline),
                                color: Colors.red,
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }
}

class _AddIncomeButton extends StatelessWidget {
  const _AddIncomeButton();

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () async {
        final cubit = context.read<IncomeCubit>();
        await showDialog(
          context: context,
          builder: (_) => _IncomeDialog(templates: cubit.state.templates),
        );
      },
      icon: const Icon(Icons.add),
      label: const Text('Add Income'),
    );
  }
}

class _IncomeDialog extends StatefulWidget {
  const _IncomeDialog({required this.templates});

  final List<ServiceTemplate> templates;

  @override
  State<_IncomeDialog> createState() => _IncomeDialogState();
}

class _IncomeDialogState extends State<_IncomeDialog> {
  DateTime _date = DateTime.now();
  int _tipMinor = 0;
  // Removed unused field; client count captured from text field directly when saving
  final List<IncomeServiceItem> _selected = [];
  final _tipController = TextEditingController();
  final _clientController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('New Income'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextButton(
              onPressed: () async {
                final d = await showDatePicker(
                  context: context,
                  initialDate: _date,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2100),
                );
                if (d != null) setState(() => _date = d);
              },
              child: Text('Date: ${formatShortDate(_date)}'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _clientController,
              decoration: const InputDecoration(labelText: 'Client count (optional)'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 8),
            Text('Services', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                for (final t in widget.templates.where((t) => t.active))
                  FilterChip(
                    label: Text('${t.name} (${formatCurrencyMinor(t.defaultPriceMinor)})'),
                    selected: _selected.any((s) => s.serviceName == t.name && s.priceMinor == t.defaultPriceMinor),
                    onSelected: (sel) {
                      setState(() {
                        final existingIndex = _selected.indexWhere((s) => s.serviceName == t.name && s.priceMinor == t.defaultPriceMinor);
                        if (sel && existingIndex == -1) {
                          _selected.add(IncomeServiceItem()
                            ..serviceName = t.name
                            ..priceMinor = t.defaultPriceMinor);
                        } else if (!sel && existingIndex != -1) {
                          _selected.removeAt(existingIndex);
                        }
                      });
                    },
                  ),
              ],
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _tipController,
              decoration: const InputDecoration(labelText: 'Tip (e.g., 5.00)'),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              onChanged: (v) {
                final parsed = double.tryParse(v) ?? 0;
                _tipMinor = (parsed * 100).round();
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () async {
            final cubit = context.read<IncomeCubit>();
            final record = IncomeRecord()
              ..date = _date
              ..clientCount = int.tryParse(_clientController.text)
              ..services = _selected
              ..tipMinor = _tipMinor
              ..note = null;
            await cubit.addIncome(record);
            if (mounted) Navigator.pop(context);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}

