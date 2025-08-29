part of 'tax_cubit.dart';

class TaxState extends Equatable {
  final bool loading;
  final List<TaxPlan> plans;
  final List<TaxPayment> payments;

  const TaxState({required this.loading, required this.plans, required this.payments});

  const TaxState.initial() : loading = false, plans = const [], payments = const [];

  TaxState copyWith({bool? loading, List<TaxPlan>? plans, List<TaxPayment>? payments}) {
    return TaxState(
      loading: loading ?? this.loading,
      plans: plans ?? this.plans,
      payments: payments ?? this.payments,
    );
  }

  @override
  List<Object?> get props => [loading, plans, payments];
}

