part of 'business_detail_bloc.dart';

class BusinessDetailState extends Equatable {
  final FormzSubmissionStatus status;
  final FormzSubmissionStatus saveStatus;
  final String originalBusinessName;
  final BusinessNameInput businessNameInput;
  final MemberProfileModel? originalManager;
  final MemberProfileModel? pendingManager;
  final List<MemberProfileModel> originalEmployees;
  final List<MemberProfileModel> pendingEmployees;
  final String? errorMessage;

  const BusinessDetailState({
    this.status = FormzSubmissionStatus.initial,
    this.saveStatus = FormzSubmissionStatus.initial,
    this.originalBusinessName = '',
    this.businessNameInput = const BusinessNameInput.pure(),
    this.originalManager,
    this.pendingManager,
    this.originalEmployees = const [],
    this.pendingEmployees = const [],
    this.errorMessage,
  });

  bool get isBusinessNameChanged =>
      originalBusinessName != businessNameInput.value.trim();

  bool get isManagerChanged => originalManager?.id != pendingManager?.id;

  bool get areEmployeesChanged {
    if (originalEmployees.length != pendingEmployees.length) return true;
    final origIds = originalEmployees.map((e) => e.id).toSet();
    final pendIds = pendingEmployees.map((e) => e.id).toSet();
    return !setEquals(origIds, pendIds);
  }

  bool get hasPendingChanges =>
      isBusinessNameChanged || isManagerChanged || areEmployeesChanged;

  BusinessDetailState copyWith({
    FormzSubmissionStatus? status,
    FormzSubmissionStatus? saveStatus,
    String? originalBusinessName,
    BusinessNameInput? businessNameInput,
    MemberProfileModel? originalManager,
    MemberProfileModel? pendingManager,
    bool clearManager = false,
    bool hasManager = false,
    List<MemberProfileModel>? originalEmployees,
    List<MemberProfileModel>? pendingEmployees,
    String? errorMessage,
  }) {
    return BusinessDetailState(
      status: status ?? this.status,
      saveStatus: saveStatus ?? this.saveStatus,
      originalBusinessName:
          originalBusinessName ?? this.originalBusinessName,
      businessNameInput: businessNameInput ?? this.businessNameInput,
      originalManager: originalManager ?? this.originalManager,
      pendingManager: clearManager
          ? null
          : (hasManager
              ? pendingManager
              : (pendingManager ?? this.pendingManager)),
      originalEmployees: originalEmployees ?? this.originalEmployees,
      pendingEmployees: pendingEmployees ?? this.pendingEmployees,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        saveStatus,
        originalBusinessName,
        businessNameInput,
        originalManager,
        pendingManager,
        originalEmployees,
        pendingEmployees,
        errorMessage,
      ];
}


