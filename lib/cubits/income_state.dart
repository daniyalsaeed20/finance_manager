part of 'income_cubit.dart';

class IncomeState extends Equatable {
  final bool loading;
  final List<ServiceTemplate> templates;
  final List<IncomeRecord> incomeRecords;
  final int totalMinor;
  final DateTime rangeStart;
  final DateTime rangeEnd;

  IncomeState({
    required this.loading,
    required this.templates,
    required this.incomeRecords,
    required this.totalMinor,
    required this.rangeStart,
    required this.rangeEnd,
  });

  IncomeState.initial()
      : loading = false,
        templates = const [],
        incomeRecords = const [],
        totalMinor = 0,
        rangeStart = DateTime(2000, 1, 1),
        rangeEnd = DateTime(2099, 12, 31);

  IncomeState copyWith({
    bool? loading,
    List<ServiceTemplate>? templates,
    List<IncomeRecord>? incomeRecords,
    int? totalMinor,
    DateTime? rangeStart,
    DateTime? rangeEnd,
  }) {
    return IncomeState(
      loading: loading ?? this.loading,
      templates: templates ?? this.templates,
      incomeRecords: incomeRecords ?? this.incomeRecords,
      totalMinor: totalMinor ?? this.totalMinor,
      rangeStart: rangeStart ?? this.rangeStart,
      rangeEnd: rangeEnd ?? this.rangeEnd,
    );
  }

  @override
  List<Object?> get props => [loading, templates, incomeRecords, totalMinor, rangeStart, rangeEnd];
}

