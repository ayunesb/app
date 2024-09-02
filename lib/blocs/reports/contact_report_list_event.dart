part of 'contact_report_list_bloc.dart';

@immutable
abstract class ReportListEvent {}

class ReportListInitialEvent extends ReportListEvent {
  final String adId;
  DateTime startTime;
  DateTime? endTime;
  ReportListInitialEvent(
      {this.adId = 'all',
      required this.startTime,
      this.endTime}) {
    this.startTime = this.startTime ?? DateTime(1970);
    this.endTime = this.endTime ?? null;
  }
}

class ReportListLoadRowEvent extends ReportListEvent {
  final ContactReport report;
  ReportListLoadRowEvent({required this.report});
}

class ReportListLoadedEvent extends ReportListEvent {
  final ContactReportList reportList;
  ReportListLoadedEvent({required this.reportList});
}
