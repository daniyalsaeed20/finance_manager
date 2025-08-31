import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubits/income_cubit.dart';
import '../../models/income_models.dart';
import '../../services/user_manager.dart';

class ServiceTemplateManagerScreen extends StatefulWidget {
  const ServiceTemplateManagerScreen({super.key});

  @override
  State<ServiceTemplateManagerScreen> createState() =>
      _ServiceTemplateManagerScreenState();
}

class _ServiceTemplateManagerScreenState
    extends State<ServiceTemplateManagerScreen> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  int _sortOrder = 0;

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<IncomeCubit, IncomeState>(
        builder: (context, state) {
          if (state.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              // Add new service form
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Add New Service',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 16),
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
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          decoration: const InputDecoration(
                            labelText: 'Sort Order',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            _sortOrder = int.tryParse(value) ?? 0;
                          },
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => _addService(),
                            child: const Text('Add Service'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Existing services list
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: state.templates.length,
                  itemBuilder: (context, index) {
                    final template = state.templates[index];
                    return Card(
                      child: ListTile(
                        title: Text(template.name),
                        subtitle: Text(
                          '\$${(template.defaultPriceMinor / 100).toStringAsFixed(2)} • Order: ${template.sortOrder}',
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Switch(
                              value: template.active,
                              onChanged: (value) {
                                final updated = template..active = value;
                                context.read<IncomeCubit>().addOrUpdateTemplate(
                                  updated,
                                );
                              },
                            ),
                            IconButton(
                              onPressed: () => _editService(template),
                              icon: const Icon(Icons.edit),
                            ),
                            IconButton(
                              onPressed: () => _deleteService(template),
                              icon: const Icon(Icons.delete_outline),
                              color: Colors.red,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _addService() {
    if (_nameController.text.isEmpty || _priceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    final price = double.tryParse(_priceController.text);
    if (price == null || price <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid price')),
      );
      return;
    }

    // Get current user ID from UserManager
    final userId = UserManager.instance.currentUserId;

    final template = ServiceTemplate()
      ..name = _nameController.text
      ..defaultPriceMinor = (price * 100).round()
      ..sortOrder = _sortOrder
      ..active = true
      ..userId = userId;

    context.read<IncomeCubit>().addOrUpdateTemplate(template);

    _nameController.clear();
    _priceController.clear();
    _sortOrder = 0;
  }

  void _editService(ServiceTemplate template) {
    _nameController.text = template.name;
    _priceController.text = (template.defaultPriceMinor / 100).toStringAsFixed(
      2,
    );
    _sortOrder = template.sortOrder;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Service'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Service Name'),
            ),
            TextField(
              controller: _priceController,
              decoration: const InputDecoration(labelText: 'Default Price'),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Sort Order'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                _sortOrder = int.tryParse(value) ?? 0;
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final price = double.tryParse(_priceController.text);
              if (price != null && price > 0) {
                final updated = template
                  ..name = _nameController.text
                  ..defaultPriceMinor = (price * 100).round()
                  ..sortOrder = _sortOrder;
                context.read<IncomeCubit>().addOrUpdateTemplate(updated);
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _deleteService(ServiceTemplate template) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Service'),
        content: Text('Are you sure you want to delete "${template.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<IncomeCubit>().removeTemplate(template.id);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
