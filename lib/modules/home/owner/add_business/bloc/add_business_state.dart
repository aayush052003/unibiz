part of 'add_business_bloc.dart';

class AddBusinessState extends Equatable {
  final BusinessNameInput businessName;
  final List<StaffMemberModel> managers;
  final List<StaffMemberModel> employees;
  final String? selectedManagerId;
  final List<String> selectedEmployeeIds;
  final FormzSubmissionStatus loadStatus;
  final FormzSubmissionStatus submitStatus;
  final String? errorMessage;

  const AddBusinessState({
    this.businessName = const BusinessNameInput.pure(),
    this.managers = const [],
    this.employees = const [],
    this.selectedManagerId,
    this.selectedEmployeeIds = const [],
    this.loadStatus = FormzSubmissionStatus.initial,
    this.submitStatus = FormzSubmissionStatus.initial,
    this.errorMessage,
  });

  AddBusinessState copyWith({
    BusinessNameInput? businessName,
    List<StaffMemberModel>? managers,
    List<StaffMemberModel>? employees,
    String? selectedManagerId,
    bool clearSelectedManager = false,
    List<String>? selectedEmployeeIds,
    FormzSubmissionStatus? loadStatus,
    FormzSubmissionStatus? submitStatus,
    String? errorMessage,
  }) {
    return AddBusinessState(
      businessName: businessName ?? this.businessName,
      managers: managers ?? this.managers,
      employees: employees ?? this.employees,
      selectedManagerId: clearSelectedManager ? null : (selectedManagerId ?? this.selectedManagerId),
      selectedEmployeeIds: selectedEmployeeIds ?? this.selectedEmployeeIds,
      loadStatus: loadStatus ?? this.loadStatus,
      submitStatus: submitStatus ?? this.submitStatus,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        businessName,
        managers,
        employees,
        selectedManagerId,
        selectedEmployeeIds,
        loadStatus,
        submitStatus,
        errorMessage,
      ];
}
