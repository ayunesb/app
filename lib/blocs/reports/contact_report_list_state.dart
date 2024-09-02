part of 'contact_report_list_bloc.dart';

abstract class ReportListState {}

class ReportListInitialState extends ReportListState {}

class ReportListLoadSuccessState extends ReportListState {
  late ContactReportList reportList;
  ReportListLoadSuccessState(this.reportList) {}
}

class ReportListLoadedRowState extends ReportListState {
  late ContactReport report;
  ReportListLoadedRowState(this.report) {}
}

class ReportListLoadFailureState extends ReportListState {
  late String err;
  ReportListLoadFailureState(this.err) {}
}
