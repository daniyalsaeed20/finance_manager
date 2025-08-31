import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../cubits/income_cubit.dart';
import '../../cubits/expense_cubit.dart';
import '../../cubits/goal_cubit.dart';
import '../../models/income_models.dart';
import '../../models/expense_models.dart';
import '../../models/goal_models.dart';
import '../../services/user_manager.dart';
import '../../utils/formatting.dart';
import '../../utils/amount_input_formatter.dart';

class BusinessManagementScreen extends StatefulWidget {
  const BusinessManagementScreen({super.key});

  @override
  State<BusinessManagementScreen> createState() =>
      _BusinessManagementScreenState();
}

class _BusinessManagementScreenState extends State<BusinessManagementScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Load initial data after dependencies are available
    final userId = UserManager.instance.currentUserId;
    context.read<IncomeCubit>().loadTemplates(userId);
    context.read<ExpenseCubit>().loadCategories(userId);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        debugPrint('🏢 Business: WillPopScope triggered');
        // Always allow popping back to previous screen
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              debugPrint('🏢 Business: Navigating back');
              // Simply pop back to previous screen
              context.pop();
            },
          ),
          title: const Text('Business Management'),
          backgroundColor: Theme.of(context).colorScheme.surface,
          foregroundColor: Theme.of(context).colorScheme.onSurface,
          elevation: 0,
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Services', icon: Icon(Icons.work)),
              Tab(text: 'Categories', icon: Icon(Icons.category)),
              Tab(text: 'Monthly Goals', icon: Icon(Icons.flag)),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [_ServicesTab(), _CategoriesTab(), _MonthlyGoalsTab()],
        ),
      ),
    );
  }
}

class _ServicesTab extends StatefulWidget {
  const _ServicesTab();

  @override
  State<_ServicesTab> createState() => _ServicesTabState();
}

class _ServicesTabState extends State<_ServicesTab> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  ServiceTemplate? _editingTemplate; // Track which template is being edited

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IncomeCubit, IncomeState>(
      builder: (context, state) {
        // Safety check for state
        if (state == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Add new service form
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _editingTemplate != null
                            ? 'Edit Service'
                            : 'Add New Service',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Add the services you offer to your clients. These will appear when adding income records.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                          fontStyle: FontStyle.italic,
                        ),
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
                        inputFormatters: [AmountInputFormatter()],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          if (_editingTemplate != null) ...[
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () => _cancelEdit(),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey,
                                ),
                                child: const Text('Cancel'),
                              ),
                            ),
                            const SizedBox(width: 12),
                          ],
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => _editingTemplate != null
                                  ? _updateService()
                                  : _addService(),
                              child: Text(
                                _editingTemplate != null
                                    ? 'Update'
                                    : 'Add Service',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Services list
              Text(
                'Current Services',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              if (state.templates.isEmpty)
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(child: Text('No services added yet')),
                  ),
                )
              else
                ...state.templates
                    .map(
                      (template) => Card(
                        margin: const EdgeInsets.only(bottom: 8.0),
                        child: ListTile(
                          title: Text(template.name),
                          subtitle: FutureBuilder<String>(
                            future: formatCurrency(template.defaultPriceMinor),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Text('Price: ${snapshot.data}');
                              }
                              return const Text('Price: Loading...');
                            },
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Switch(
                                value: template.active,
                                onChanged: (value) =>
                                    _toggleService(template, value),
                              ),
                              IconButton(
                                onPressed: () => _editService(template),
                                icon: const Icon(Icons.edit),
                              ),
                              IconButton(
                                onPressed: () => _deleteService(template),
                                icon: const Icon(Icons.delete),
                                color: Colors.red,
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                    .toList(),
            ],
          ),
        );
      },
    );
  }

  void _addService() {
    if (_nameController.text.isEmpty || _priceController.text.isEmpty) return;

    final price = double.tryParse(_priceController.text) ?? 0;
    final priceMinor = (price * 100).round();

    // Get the next available sort order
    final nextSortOrder = context.read<IncomeCubit>().state.templates.isEmpty
        ? 0
        : context
                  .read<IncomeCubit>()
                  .state
                  .templates
                  .map((t) => t.sortOrder)
                  .reduce((a, b) => a > b ? a : b) +
              1;

    final template = ServiceTemplate()
      ..name = _nameController.text.trim()
      ..defaultPriceMinor = priceMinor
      ..sortOrder = nextSortOrder
      ..active = true
      ..userId = UserManager.instance.currentUserId;

    context.read<IncomeCubit>().addOrUpdateTemplate(template);

    // Reset form and editing state
    _editingTemplate = null;
    _nameController.clear();
    _priceController.clear();
  }

  void _toggleService(ServiceTemplate template, bool active) {
    final updatedTemplate = template..active = active;
    context.read<IncomeCubit>().addOrUpdateTemplate(updatedTemplate);
  }

  void _editService(ServiceTemplate template) {
    _nameController.text = template.name;
    _priceController.text = template.defaultPriceMinor.toString();
    _editingTemplate = template; // Set the tracking variable
    setState(() {});
  }

  void _cancelEdit() {
    _editingTemplate = null; // Clear the tracking variable
    _nameController.clear();
    _priceController.clear();
    setState(() {});
  }

  void _updateService() {
    if (_nameController.text.isEmpty || _priceController.text.isEmpty) return;

    final price = double.tryParse(_priceController.text) ?? 0;
    final priceMinor = (price * 100).round();

    final updatedTemplate = _editingTemplate!
      ..name = _nameController.text.trim()
      ..defaultPriceMinor = priceMinor;

    context.read<IncomeCubit>().addOrUpdateTemplate(updatedTemplate);

    // Reset form and tracking variable
    _editingTemplate = null;
    _nameController.clear();
    _priceController.clear();
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
            onPressed: () async {
              await context.read<IncomeCubit>().removeTemplate(template.id);
              // Reload templates to update the UI
              final userId = UserManager.instance.currentUserId;
              context.read<IncomeCubit>().loadTemplates(userId);
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

class _CategoriesTab extends StatefulWidget {
  const _CategoriesTab();

  @override
  State<_CategoriesTab> createState() => _CategoriesTabState();
}

class _CategoriesTabState extends State<_CategoriesTab> {
  final _nameController = TextEditingController();
  ExpenseCategory? _editingCategory; // Track which category is being edited

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExpenseCubit, ExpenseState>(
      builder: (context, state) {
        // Safety check for state
        if (state == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Add new category form
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _editingCategory != null
                            ? 'Edit Category'
                            : 'Add New Category',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Add expense categories to organize your business expenses. These will appear when adding expense records.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Category Name',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          if (_editingCategory != null) ...[
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () => _cancelEdit(),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey,
                                ),
                                child: const Text('Cancel'),
                              ),
                            ),
                            const SizedBox(width: 12),
                          ],
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => _editingCategory != null
                                  ? _updateCategory()
                                  : _addCategory(),
                              child: Text(
                                _editingCategory != null
                                    ? 'Update Category'
                                    : 'Add Category',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Categories list
              Text(
                'Current Categories',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              if (state.categories.isEmpty)
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(child: Text('No categories added yet')),
                  ),
                )
              else
                ...state.categories
                    .map(
                      (category) => Card(
                        margin: const EdgeInsets.only(bottom: 8.0),
                        child: ListTile(
                          title: Text(category.name),
                          subtitle: const Text(''),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () => _editCategory(category),
                                icon: const Icon(Icons.edit),
                              ),
                              IconButton(
                                onPressed: () => _deleteCategory(category),
                                icon: const Icon(Icons.delete),
                                color: Colors.red,
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                    .toList(),
            ],
          ),
        );
      },
    );
  }

  void _addCategory() {
    if (_nameController.text.isEmpty) return;

    // Get the next available sort order
    final nextSortOrder = context.read<ExpenseCubit>().state.categories.isEmpty
        ? 0
        : context
                  .read<ExpenseCubit>()
                  .state
                  .categories
                  .map((c) => c.sortOrder)
                  .reduce((a, b) => a > b ? a : b) +
              1;

    final category = ExpenseCategory()
      ..name = _nameController.text.trim()
      ..sortOrder = nextSortOrder
      ..userId = UserManager.instance.currentUserId;

    context.read<ExpenseCubit>().upsertCategory(category);

    // Reset form and editing state
    _editingCategory = null;
    _nameController.clear();
  }

  void _editCategory(ExpenseCategory category) {
    _nameController.text = category.name;
    _editingCategory = category; // Set the tracking variable
    setState(() {});
  }

  void _updateCategory() {
    if (_nameController.text.isEmpty) return;

    final category = _editingCategory!..name = _nameController.text.trim();

    context.read<ExpenseCubit>().upsertCategory(category);

    // Reset form and tracking variable
    _nameController.clear();
    _editingCategory = null;
  }

  void _cancelEdit() {
    _nameController.clear();
    _editingCategory = null;
    setState(() {});
  }

  void _deleteCategory(ExpenseCategory category) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Category'),
        content: Text('Are you sure you want to delete "${category.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              await context.read<ExpenseCubit>().deleteCategory(category.id);
              // Reload categories to update the UI
              final userId = UserManager.instance.currentUserId;
              context.read<ExpenseCubit>().loadCategories(userId);
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

class _MonthlyGoalsTab extends StatefulWidget {
  const _MonthlyGoalsTab();

  @override
  State<_MonthlyGoalsTab> createState() => _MonthlyGoalsTabState();
}

class _MonthlyGoalsTabState extends State<_MonthlyGoalsTab> {
  final _amountController = TextEditingController();
  final _strategyController = TextEditingController();
  final List<String> _strategies = [];
  MonthlyGoal? _editingGoal;
  DateTime _selectedMonth = DateTime.now();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Load the current month's goal when the tab is first displayed
    final userId = UserManager.instance.currentUserId;
    final monthKey =
        '${_selectedMonth.year}-${_selectedMonth.month.toString().padLeft(2, '0')}';
    context.read<GoalCubit>().loadForMonth(monthKey, userId);
  }

  @override
  void dispose() {
    _amountController.dispose();
    _strategyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GoalCubit, GoalState>(
      builder: (context, state) {
        // Debug information
        print(
          'GoalState: loading=${state.loading}, monthKey=${state.monthKey}, goal=${state.goal}',
        );

        // Safety check for state
        if (state == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Monthly Goal Management Form
              Card(
                color: _editingGoal != null
                    ? Theme.of(context).colorScheme.surface
                    : null,
                elevation: _editingGoal != null ? 2 : 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: _editingGoal != null
                      ? BorderSide(
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withValues(alpha: 0.3),
                          width: 1,
                        )
                      : BorderSide.none,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          if (_editingGoal != null) ...[
                            Icon(
                              Icons.edit,
                              color: Theme.of(context).colorScheme.primary,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                          ],
                          Text(
                            _editingGoal != null
                                ? 'Modify Monthly Goal'
                                : 'Set Monthly Goal',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Set a monthly savings goal that will apply to all future months. Once set, this goal will continue until modified.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Month Selector
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              setState(() {
                                _selectedMonth = DateTime(
                                  _selectedMonth.year,
                                  _selectedMonth.month - 1,
                                );
                              });
                            },
                            icon: const Icon(Icons.chevron_left),
                          ),
                          Expanded(
                            child: TextButton(
                              onPressed: () => _selectMonth(),
                              child: Text(_formatMonthYear(_selectedMonth)),
                            ),
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
                                  }
                                : null,
                            icon: const Icon(Icons.chevron_right),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Goal Amount Input
                      TextField(
                        controller: _amountController,
                        decoration: const InputDecoration(
                          labelText: 'Monthly Goal Amount',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.attach_money),
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [AmountInputFormatter()],
                      ),
                      const SizedBox(height: 16),

                      // Strategies Input
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _strategyController,
                              decoration: const InputDecoration(
                                labelText: 'Strategy',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.lightbulb_outline),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            onPressed: _addStrategy,
                            icon: const Icon(Icons.add),
                          ),
                        ],
                      ),

                      if (_strategies.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        ..._strategies.map(
                          (strategy) => ListTile(
                            leading: const Icon(Icons.check_circle),
                            title: Text(strategy),
                            trailing: IconButton(
                              icon: const Icon(Icons.remove_circle),
                              onPressed: () => _removeStrategy(strategy),
                            ),
                          ),
                        ),
                      ],

                      const SizedBox(height: 16),

                      // Action Buttons
                      Row(
                        children: [
                          if (_editingGoal != null) ...[
                            // Editing mode - show Update and Cancel
                            Expanded(
                              child: ElevatedButton(
                                onPressed: _updateGoal,
                                child: const Text('Update Goal'),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextButton(
                                onPressed: _cancelEdit,
                                child: const Text('Cancel'),
                              ),
                            ),
                          ] else if (state.goal == null) ...[
                            // No goal set - show Set Goal button
                            Expanded(
                              child: ElevatedButton(
                                onPressed: _saveGoal,
                                child: const Text('Set Goal'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(
                                    context,
                                  ).colorScheme.primary,
                                  foregroundColor: Theme.of(
                                    context,
                                  ).colorScheme.onPrimary,
                                ),
                              ),
                            ),
                          ] else ...[
                            // Goal exists but not editing - show Edit Goal button
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () => _startEditing(state.goal!),
                                child: const Text('Edit Goal'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(
                                    context,
                                  ).colorScheme.primary,
                                  foregroundColor: Theme.of(
                                    context,
                                  ).colorScheme.onPrimary,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Current Goal Display
              if (state.goal != null) ...[
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Current Monthly Goal',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Amount',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.labelMedium,
                                  ),
                                  const SizedBox(height: 4),
                                  FutureBuilder<String>(
                                    future: formatCurrency(
                                      state.goal!.targetAmountMinor,
                                    ),
                                    builder: (context, snapshot) {
                                      return Text(
                                        snapshot.data ?? 'Loading...',
                                        style: Theme.of(
                                          context,
                                        ).textTheme.titleLarge,
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Strategies',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.labelMedium,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${state.goal!.strategies.length} strategies',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleLarge,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        if (state.goal!.strategies.length > 0) ...[
                          Text(
                            'Strategy List:',
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                          const SizedBox(height: 8),
                          ...state.goal!.strategies.map(
                            (strategy) => ListTile(
                              leading: const Icon(
                                Icons.check_circle,
                                color: Colors.green,
                              ),
                              title: Text(strategy.title),
                              dense: true,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ] else ...[
                // Show message when no goal is set
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: Theme.of(context).colorScheme.primary,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'No Monthly Goal Set',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'You haven\'t set a monthly savings goal yet. Use the form above to set your first goal.',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Colors.grey[600],
                                fontStyle: FontStyle.italic,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  void _startEditing(MonthlyGoal goal) {
    print(
      'Starting to edit goal: ${goal.targetAmountMinor}, monthKey: ${goal.monthKey}',
    );
    setState(() {
      _editingGoal = goal;
      _amountController.text = (goal.targetAmountMinor / 100).toString();
      _strategies.clear();
      _strategies.addAll(goal.strategies.map((s) => s.title));
    });
    print(
      'Form populated: amount=${_amountController.text}, strategies=${_strategies}',
    );
  }

  void _addStrategy() {
    if (_strategyController.text.isNotEmpty) {
      setState(() {
        _strategies.add(_strategyController.text);
        _strategyController.clear();
      });
    }
  }

  void _removeStrategy(String strategy) {
    setState(() {
      _strategies.remove(strategy);
    });
  }

  void _saveGoal() {
    if (_amountController.text.isEmpty) return;

    final amount = int.tryParse(
      _amountController.text.replaceAll(RegExp(r'[^\d]'), ''),
    );
    if (amount == null || amount <= 0) return;

    final goal = MonthlyGoal()
      ..targetAmountMinor = amount
      ..strategies = _strategies
          .map((s) => GoalStrategyItem()..title = s)
          .toList()
      ..userId = UserManager.instance.currentUserId
      ..monthKey =
          '${_selectedMonth.year}-${_selectedMonth.month.toString().padLeft(2, '0')}';

    context.read<GoalCubit>().upsert(goal);

    // Reset form
    _amountController.clear();
    _strategies.clear();
    setState(() {});
  }

  void _updateGoal() {
    if (_amountController.text.isEmpty) return;

    final amount = int.tryParse(
      _amountController.text.replaceAll(RegExp(r'[^\d]'), ''),
    );
    if (amount == null || amount <= 0) return;

    print('Updating goal: amount=$amount, strategies=${_strategies}');
    print(
      'Original goal: ${_editingGoal!.targetAmountMinor}, monthKey: ${_editingGoal!.monthKey}',
    );

    final updatedGoal = _editingGoal!
      ..targetAmountMinor = amount
      ..strategies = _strategies
          .map((s) => GoalStrategyItem()..title = s)
          .toList();

    print(
      'Updated goal: ${updatedGoal.targetAmountMinor}, monthKey: ${updatedGoal.monthKey}',
    );

    context.read<GoalCubit>().upsert(updatedGoal);

    // Reset form and editing state
    _editingGoal = null;
    _amountController.clear();
    _strategies.clear();
    setState(() {});
  }

  void _cancelEdit() {
    _editingGoal = null;
    _amountController.clear();
    _strategies.clear();
    setState(() {});
  }

  void _selectMonth() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedMonth,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDatePickerMode: DatePickerMode.year,
    );

    if (picked != null) {
      setState(() {
        _selectedMonth = picked;
      });
    }
  }

  String _formatMonthYear(DateTime date) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${months[date.month - 1]} ${date.year}';
  }
}
