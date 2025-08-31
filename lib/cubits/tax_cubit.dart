// tax_cubit.dart
// State for tax rate, plans and payments

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../models/tax_models.dart';
import '../repositories/tax_repository.dart';

part 'tax_state.dart';

class TaxCubit extends Cubit<TaxState> {
  final TaxRepository repository;
  TaxCubit(this.repository) : super(const TaxState.initial());

  Future<void> load(String userId) async {
    emit(state.copyWith(loading: true));
    final plans = await repository.getPlans(userId);
    final payments = await repository.getPayments(userId);
    emit(state.copyWith(loading: false, plans: plans, payments: payments));
  }

  Future<void> upsertPlan(TaxPlan p) async {
    await repository.upsertPlan(p);
    await load(p.userId);
  }

  Future<void> deletePlan(int id) async {
    await repository.deletePlan(id);
    // Note: We need userId to reload data, but we don't have it here
    // This will be handled by the UI layer
  }

  Future<void> addPayment(TaxPayment payment) async {
    await repository.addPayment(payment);
    await load(payment.userId);
  }

  Future<void> deletePayment(int id) async {
    await repository.deletePayment(id);
    // Note: We need userId to reload data, but we don't have it here
    // This will be handled by the UI layer
  }
}
