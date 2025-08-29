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

  Future<void> load() async {
    emit(state.copyWith(loading: true));
    final plans = await repository.getPlans();
    final payments = await repository.getPayments();
    emit(state.copyWith(loading: false, plans: plans, payments: payments));
  }

  Future<void> upsertPlan(TaxPlan p) async {
    await repository.upsertPlan(p);
    await load();
  }

  Future<void> deletePlan(int id) async {
    await repository.deletePlan(id);
    await load();
  }

  Future<void> addPayment(TaxPayment payment) async {
    await repository.addPayment(payment);
    await load();
  }

  Future<void> deletePayment(int id) async {
    await repository.deletePayment(id);
    await load();
  }
}

