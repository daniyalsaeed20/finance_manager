// income_cubit.dart
// Holds state and business logic for income entry and weekly/monthly summaries

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../models/income_models.dart';
import '../repositories/income_repository.dart';

part 'income_state.dart';

class IncomeCubit extends Cubit<IncomeState> {
  final IncomeRepository repository;
  IncomeCubit(this.repository) : super(IncomeState.initial());

  Future<void> loadTemplates() async {
    emit(state.copyWith(loading: true));
    final templates = await repository.getServiceTemplates();
    emit(state.copyWith(loading: false, templates: templates));
  }

  Future<void> addOrUpdateTemplate(ServiceTemplate t) async {
    await repository.upsertServiceTemplate(t);
    await loadTemplates();
  }

  Future<void> removeTemplate(int id) async {
    await repository.deleteServiceTemplate(id);
    await loadTemplates();
  }

  Future<void> addIncome(IncomeRecord record) async {
    await repository.addIncomeRecord(record);
    await refreshRange(state.rangeStart, state.rangeEnd);
  }

  Future<void> updateIncome(IncomeRecord record) async {
    await repository.updateIncomeRecord(record);
    await refreshRange(state.rangeStart, state.rangeEnd);
  }

  Future<void> deleteIncome(int id) async {
    await repository.deleteIncomeRecord(id);
    await refreshRange(state.rangeStart, state.rangeEnd);
  }

  Future<void> refreshRange(DateTime start, DateTime end) async {
    emit(state.copyWith(loading: true, rangeStart: start, rangeEnd: end));
    final items = await repository.getIncomeForDateRange(start, end);
    final totalMinor = items.fold<int>(0, (sum, r) => sum + r.totalMinor);
    emit(state.copyWith(loading: false, incomeRecords: items, totalMinor: totalMinor));
  }
}

