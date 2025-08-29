part of 'dashboard_cubit.dart';

class DashboardState extends Equatable {
  final bool loading;
  final DateTime rangeStart;
  final DateTime rangeEnd;
  final int totalIncomeMinor;
  final int totalExpenseMinor;
  final int netMinor;

  DashboardState({
    required this.loading,
    required this.rangeStart,
    required this.rangeEnd,
    required this.totalIncomeMinor,
    required this.totalExpenseMinor,
    required this.netMinor,
  });

  DashboardState.initial()
    : loading = false,
      rangeStart = DateTime(2000, 1, 1),
      rangeEnd = DateTime(2099, 12, 31),
      totalIncomeMinor = 0,
      totalExpenseMinor = 0,
      netMinor = 0;

  DashboardState copyWith({
    bool? loading,
    DateTime? rangeStart,
    DateTime? rangeEnd,
    int? totalIncomeMinor,
    int? totalExpenseMinor,
    int? netMinor,
  }) {
    return DashboardState(
      loading: loading ?? this.loading,
      rangeStart: rangeStart ?? this.rangeStart,
      rangeEnd: rangeEnd ?? this.rangeEnd,
      totalIncomeMinor: totalIncomeMinor ?? this.totalIncomeMinor,
      totalExpenseMinor: totalExpenseMinor ?? this.totalExpenseMinor,
      netMinor: netMinor ?? this.netMinor,
    );
  }

  @override
  List<Object?> get props => [
    loading,
    rangeStart,
    rangeEnd,
    totalIncomeMinor,
    totalExpenseMinor,
    netMinor,
  ];
}
