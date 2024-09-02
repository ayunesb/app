import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../models/contact_report.dart';
import '../../service/database_service.dart';

part 'contact_report_event.dart';
part 'contact_report_state.dart';

class ContactReportBloc extends Bloc<ContactReportEvent, ContactReportState> {
  final DatabaseService databaseService;

  ContactReportBloc({required this.databaseService})
      : super(ContactReportInitialState()) {
    on<ContactReportEvent>(_mapEventToState);
  }

  Future<void> _mapEventToState(
      ContactReportEvent event, Emitter<ContactReportState> emit) async {
    if (event is ContactReportLoadingEvent) {
      String contactReportId = event.contactReportId;
      try {
        ContactReport contactReport = await databaseService.getContactReport(
            contactReportId: contactReportId);
        emit(ContactReportLoadSuccessState(contactReport));
      } catch (err) {
        emit(ContactReportLoadFailureState(err.toString()));
      }
    } else if (event is ContactReportUpdateEvent) {
      ContactReport contactReport = event.contactReport;
      try {
        bool success = await databaseService.updateContactReport(
            contactReport: contactReport);
        emit(ContactReportLoadSuccessState(contactReport));
      } catch (err) {
        emit(ContactReportLoadFailureState(err.toString()));
      }
    } else if (event is ContactReportAddEvent) {
      ContactReport contactReport = event.contactReport;
      try {
        String newId = await databaseService.addContactReport(
            contactReport: contactReport);
        emit(ContactReportAddSuccessState(contactReport));
      } catch (err) {
        emit(ContactReportLoadFailureState(err.toString()));
      }
    } else if (event is ContactReportInitialEvent) {
      emit(ContactReportInitialState());
    }
  }
}
