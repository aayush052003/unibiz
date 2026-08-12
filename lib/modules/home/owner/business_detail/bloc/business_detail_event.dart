part of 'business_detail_bloc.dart';

@immutable
sealed class BusinessDetailEvent {
  const BusinessDetailEvent();
}

class InitialBusinessNameSet extends BusinessDetailEvent {
  final String name;
  const InitialBusinessNameSet(this.name);
}

class BusinessNameChanged extends BusinessDetailEvent {
  final String name;
  const BusinessNameChanged(this.name);
}

class FetchBusinessDetailRequested extends BusinessDetailEvent {
  const FetchBusinessDetailRequested();
}

class ManagerAssigned extends BusinessDetailEvent {
  final MemberProfileModel manager;
  const ManagerAssigned(this.manager);
}

class ManagerRemoved extends BusinessDetailEvent {
  const ManagerRemoved();
}

class EmployeesUpdated extends BusinessDetailEvent {
  final List<MemberProfileModel> employees;
  const EmployeesUpdated(this.employees);
}

class EmployeeRemoved extends BusinessDetailEvent {
  final String employeeId;
  const EmployeeRemoved(this.employeeId);
}

class SaveChangesRequested extends BusinessDetailEvent {
  const SaveChangesRequested();
}

