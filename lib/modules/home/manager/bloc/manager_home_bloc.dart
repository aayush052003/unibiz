import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import '../repo/manager_home_repo.dart';

part 'manager_home_event.dart';
part 'manager_home_state.dart';

class ManagerHomeBloc extends Bloc<ManagerHomeEvent, ManagerHomeState> {
  final ManagerHomeRepo repo;

  ManagerHomeBloc({required this.repo}) : super(const ManagerHomeState()) {
    on<FetchManagerBusinessRequested>(_onFetchBusiness);
  }

  Future<void> _onFetchBusiness(
    FetchManagerBusinessRequested event,
    Emitter<ManagerHomeState> emit,
  ) async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      final businessId = await repo.fetchManagerBusinessId(event.userId);
      emit(state.copyWith(
        status: FormzSubmissionStatus.success,
        businessId: businessId,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: FormzSubmissionStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}
