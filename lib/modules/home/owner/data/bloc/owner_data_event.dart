part of 'owner_data_bloc.dart';

@immutable
sealed class OwnerDataEvent {
  const OwnerDataEvent();
}

final class OwnerDataInitialLoadRequested extends OwnerDataEvent {
  final String ownerId;

  const OwnerDataInitialLoadRequested(this.ownerId);
}

final class OwnerDataPeriodTypeChanged extends OwnerDataEvent {
  final PeriodType periodType;
  final String ownerId;

  const OwnerDataPeriodTypeChanged({
    required this.periodType,
    required this.ownerId,
  });
}

final class OwnerDataDateChanged extends OwnerDataEvent {
  final DateTime date;
  final String ownerId;

  const OwnerDataDateChanged({
    required this.date,
    required this.ownerId,
  });
}

final class OwnerDataMonthYearChanged extends OwnerDataEvent {
  final int month;
  final int year;
  final String ownerId;

  const OwnerDataMonthYearChanged({
    required this.month,
    required this.year,
    required this.ownerId,
  });
}

final class OwnerDataYearChanged extends OwnerDataEvent {
  final int year;
  final String ownerId;

  const OwnerDataYearChanged({
    required this.year,
    required this.ownerId,
  });
}

final class OwnerDataRefreshRequested extends OwnerDataEvent {
  final String ownerId;

  const OwnerDataRefreshRequested(this.ownerId);
}
