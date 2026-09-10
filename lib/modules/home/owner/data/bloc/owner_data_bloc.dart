import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import '../model/owner_data_model.dart';
import '../repo/owner_data_repo.dart';

part 'owner_data_event.dart';
part 'owner_data_state.dart';

class OwnerDataBloc extends Bloc<OwnerDataEvent, OwnerDataState> {
  final OwnerDataRepo _repo;

  OwnerDataBloc({required OwnerDataRepo repo})
      : _repo = repo,
        super(OwnerDataState.initial()) {
    on<OwnerDataInitialLoadRequested>(_onInitialLoadRequested);
    on<OwnerDataPeriodTypeChanged>(_onPeriodTypeChanged);
    on<OwnerDataDateChanged>(_onDateChanged);
    on<OwnerDataMonthYearChanged>(_onMonthYearChanged);
    on<OwnerDataYearChanged>(_onYearChanged);
    on<OwnerDataRefreshRequested>(_onRefreshRequested);
  }

  Future<void> _onInitialLoadRequested(
    OwnerDataInitialLoadRequested event,
    Emitter<OwnerDataState> emit,
  ) async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      // 1. Fetch top summary (current year across all businesses)
      final topSummary = await _repo.fetchCurrentYearTopSummary(event.ownerId);

      // 2. Fetch businesses for initial filter (today)
      final businesses = await _repo.fetchBusinessReports(
        ownerId: event.ownerId,
        periodType: state.periodType,
        selectedDate: state.selectedDate,
        selectedMonth: state.selectedMonth,
        selectedYear: state.selectedYear,
      );

      emit(state.copyWith(
        status: FormzSubmissionStatus.success,
        topSummary: topSummary,
        businesses: businesses,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: FormzSubmissionStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onPeriodTypeChanged(
    OwnerDataPeriodTypeChanged event,
    Emitter<OwnerDataState> emit,
  ) async {
    if (state.periodType == event.periodType) return;

    emit(state.copyWith(
      periodType: event.periodType,
      status: FormzSubmissionStatus.inProgress,
    ));

    try {
      final businesses = await _repo.fetchBusinessReports(
        ownerId: event.ownerId,
        periodType: event.periodType,
        selectedDate: state.selectedDate,
        selectedMonth: state.selectedMonth,
        selectedYear: state.selectedYear,
      );

      emit(state.copyWith(
        status: FormzSubmissionStatus.success,
        businesses: businesses,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: FormzSubmissionStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onDateChanged(
    OwnerDataDateChanged event,
    Emitter<OwnerDataState> emit,
  ) async {
    emit(state.copyWith(
      selectedDate: event.date,
      status: FormzSubmissionStatus.inProgress,
    ));

    try {
      final businesses = await _repo.fetchBusinessReports(
        ownerId: event.ownerId,
        periodType: state.periodType,
        selectedDate: event.date,
        selectedMonth: state.selectedMonth,
        selectedYear: state.selectedYear,
      );

      emit(state.copyWith(
        status: FormzSubmissionStatus.success,
        businesses: businesses,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: FormzSubmissionStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onMonthYearChanged(
    OwnerDataMonthYearChanged event,
    Emitter<OwnerDataState> emit,
  ) async {
    emit(state.copyWith(
      selectedMonth: event.month,
      selectedYear: event.year,
      status: FormzSubmissionStatus.inProgress,
    ));

    try {
      final businesses = await _repo.fetchBusinessReports(
        ownerId: event.ownerId,
        periodType: state.periodType,
        selectedDate: state.selectedDate,
        selectedMonth: event.month,
        selectedYear: event.year,
      );

      emit(state.copyWith(
        status: FormzSubmissionStatus.success,
        businesses: businesses,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: FormzSubmissionStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onYearChanged(
    OwnerDataYearChanged event,
    Emitter<OwnerDataState> emit,
  ) async {
    emit(state.copyWith(
      selectedYear: event.year,
      status: FormzSubmissionStatus.inProgress,
    ));

    try {
      final businesses = await _repo.fetchBusinessReports(
        ownerId: event.ownerId,
        periodType: state.periodType,
        selectedDate: state.selectedDate,
        selectedMonth: state.selectedMonth,
        selectedYear: event.year,
      );

      emit(state.copyWith(
        status: FormzSubmissionStatus.success,
        businesses: businesses,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: FormzSubmissionStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onRefreshRequested(
    OwnerDataRefreshRequested event,
    Emitter<OwnerDataState> emit,
  ) async {
    try {
      final topSummary = await _repo.fetchCurrentYearTopSummary(event.ownerId);
      final businesses = await _repo.fetchBusinessReports(
        ownerId: event.ownerId,
        periodType: state.periodType,
        selectedDate: state.selectedDate,
        selectedMonth: state.selectedMonth,
        selectedYear: state.selectedYear,
      );

      emit(state.copyWith(
        status: FormzSubmissionStatus.success,
        topSummary: topSummary,
        businesses: businesses,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: FormzSubmissionStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}
