import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../models/ad.dart';
import '../../models/contact_report.dart';
import '../../models/property.dart';
import '../../service/database_service.dart';

part 'contact_report_list_event.dart';
part 'contact_report_list_state.dart';

class ReportListBloc extends Bloc<ReportListEvent, ReportListState> {
  final DatabaseService databaseService;

  ReportListBloc({required this.databaseService})
      : super(ReportListInitialState()) {
    on<ReportListEvent>(_mapEventToState);
  }

  Future<void> _mapEventToState(
      ReportListEvent event, Emitter<ReportListState> emit) async {
    if (event is ReportListInitialEvent) {
      String adId = event.adId;
      DateTime? startTime = event.startTime;
      DateTime? endTime = event.endTime;
      try {
        ContactReportList reports =
            await databaseService.getContactReportSummaries(
                startTime: startTime,
                adId: adId,
                endTime: endTime);

        for (ContactReport report in reports.list) {
          if (report.adId.isNotEmpty) {
            try {
              Ad ad = await databaseService.getAdById(
                  adId: report.adId);
              report.adName = ad.name;
            } catch (err) {
              print(err);
            }
          }
        }
        emit(ReportListLoadSuccessState(reports));
      } catch (err) {
        print(err);
        emit(ReportListLoadFailureState(err.toString()));
      }
    } else if (event is ReportListLoadedEvent) {
      emit(ReportListInitialState());
    }
  }
}
