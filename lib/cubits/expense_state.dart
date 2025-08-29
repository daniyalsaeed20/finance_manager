part of 'expense_cubit.dart';

class ExpenseState extends Equatable {
  final bool loading;
  final List<ExpenseCategory> categories;
  final List<Expense> expenses;
  final int totalMinor;
  final DateTime rangeStart;
  final DateTime rangeEnd;

  ExpenseState({
    required this.loading,
    required this.categories,
    required this.expenses,
    required this.totalMinor,
    required this.rangeStart,
    required this.rangeEnd,
  });

  ExpenseState.initial()
      : loading = false,
        categories = const [],
        expenses = const [],
        totalMinor = 0,
        rangeStart = DateTime(2000, 1, 1),
        rangeEnd = DateTime(2099, 12, 31);

  ExpenseState copyWith({
    bool? loading,
    List<ExpenseCategory>? categories,
    List<Expense>? expenses,
    int? totalMinor,
    DateTime? rangeStart,
    DateTime? rangeEnd,
  }) {
    return ExpenseState(
      loading: loading ?? this.loading,
      categories: categories ?? this.categories,
      expenses: expenses ?? this.expenses,
      totalMinor: totalMinor ?? this.totalMinor,
      rangeStart: rangeStart ?? this.rangeStart,
      rangeEnd: rangeEnd ?? this.rangeEnd,
    );
  }

  @override
  List<Object?> get props => [loading, categories, expenses, totalMinor, rangeStart, rangeEnd];
}

