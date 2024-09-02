part of 'contact_report_bloc.dart';

@immutable
abstract class ContactReportEvent {}

class ContactReportLoadingEvent extends ContactReportEvent {
  final String contactReportId;
  ContactReportLoadingEvent({required this.contactReportId});
}

class ContactReportUpdateEvent extends ContactReportEvent {
  final ContactReport contactReport;
  ContactReportUpdateEvent({required this.contactReport});
}

class ContactReportAddEvent extends ContactReportEvent {
  final ContactReport contactReport;
  ContactReportAddEvent({required this.contactReport});
}

class ContactReportLoadedEvent extends ContactReportEvent {
  final ContactReport contactReport;
  ContactReportLoadedEvent({required this.contactReport});
}

class ContactReportInitialEvent extends ContactReportEvent {
  ContactReportInitialEvent();
}
