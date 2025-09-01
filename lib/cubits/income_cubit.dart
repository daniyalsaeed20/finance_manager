// income_cubit.dart
// Holds state and business logic for income entry and weekly/monthly summaries

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import '../models/income_models.dart';
import '../repositories/income_repository.dart';

part 'income_state.dart';

class IncomeCubit extends Cubit<IncomeState> {
  final IncomeRepository repository;
  IncomeCubit(this.repository) : super(IncomeState.initial());

  Future<void> loadTemplates(String userId) async {
    emit(state.copyWith(loading: true));
    final templates = await repository.getServiceTemplates(userId);
    emit(state.copyWith(loading: false, templates: templates));
  }

  Future<void> addOrUpdateTemplate(ServiceTemplate t) async {
    await repository.upsertServiceTemplate(t);
    await loadTemplates(t.userId);
  }

  Future<void> removeTemplate(int id) async {
    await repository.deleteServiceTemplate(id);
    // Note: We need userId to reload templates, but we don't have it here
    // This will be handled by the UI layer
  }

  Future<void> addIncome(IncomeRecord record) async {
    debugPrint('IncomeCubit.addIncome called with record: ${record.id}');
    try {
      await repository.addIncomeRecord(record);
      debugPrint('IncomeCubit.addIncome: record saved successfully');
      await refreshRange(state.rangeStart, state.rangeEnd, record.userId);
      debugPrint('IncomeCubit.addIncome: range refreshed successfully');
    } catch (e) {
      debugPrint('IncomeCubit.addIncome error: $e');
      rethrow;
    }
  }

  Future<void> updateIncome(IncomeRecord record) async {
    debugPrint('IncomeCubit.updateIncome called with record: ${record.id}');
    try {
      await repository.updateIncomeRecord(record);
      debugPrint('IncomeCubit.updateIncome: record updated successfully');
      await refreshRange(state.rangeStart, state.rangeEnd, record.userId);
      debugPrint('IncomeCubit.updateIncome: range refreshed successfully');
    } catch (e) {
      debugPrint('IncomeCubit.updateIncome error: $e');
      rethrow;
    }
  }

  Future<void> deleteIncome(int id, String userId) async {
    await repository.deleteIncomeRecord(id);
    // Immediately remove from state and refresh range
    await refreshRange(state.rangeStart, state.rangeEnd, userId);
  }

  Future<void> refreshRange(DateTime start, DateTime end, String userId) async {
    debugPrint(
      'IncomeCubit.refreshRange called: ${start.toIso8601String()} to ${end.toIso8601String()}',
    );
    emit(state.copyWith(loading: true, rangeStart: start, rangeEnd: end));
    try {
      final items = await repository.getIncomeForDateRange(start, end, userId);
      debugPrint('IncomeCubit.refreshRange: got ${items.length} items');
      final totalMinor = items.fold<int>(0, (sum, r) => sum + r.totalMinor);
      emit(
        state.copyWith(
          loading: false,
          incomeRecords: items,
          totalMinor: totalMinor,
        ),
      );
      debugPrint('IncomeCubit.refreshRange: state updated successfully');
    } catch (e) {
      debugPrint('IncomeCubit.refreshRange error: $e');
      emit(state.copyWith(loading: false));
      rethrow;
    }
  }
}
