part of 'contact_report_bloc.dart';

abstract class ContactReportState {}

class ContactReportInitialState extends ContactReportState {}

class ContactReportLoadSuccessState extends ContactReportState {
  late ContactReport contactReport;
  ContactReportLoadSuccessState(this.contactReport) {}
}

class ContactReportUpdateSuccessState extends ContactReportState {
  late ContactReport contactReport;
  ContactReportUpdateSuccessState(this.contactReport) {}
}

class ContactReportAddSuccessState extends ContactReportState {
  late ContactReport contactReport;
  ContactReportAddSuccessState(this.contactReport) {}
}

class ContactReportLoadFailureState extends ContactReportState {
  late String err;
  ContactReportLoadFailureState(this.err) {}
}
