import 'package:date_field/date_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../blocs/ads/ad_list_bloc.dart';
import '../../../blocs/reports/contact_report_list_bloc.dart';
import '../../../generated/l10n.dart';
import '../../../models/ad.dart';
import '../../../models/contact_report.dart';
import '../../../service/database_service.dart';
import '../../widgets/property/property_list.dart';

class AdminReportList extends StatefulWidget {
  const AdminReportList({Key? key}) : super(key: key);

  @override
  State createState() => _AdminReportListState();
}

enum ActionType { all, user, click }

class _AdminReportListState extends State {
  late DatabaseService _databaseService = DatabaseService();
  late ActionType actionType = ActionType.all;

  Ad? selectedAd = null;
  DateTime now = DateTime.now();
  // default to this month
  DateTime startTime = DateTime(DateTime.now().year, DateTime.now().month, 1);
  DateTime endTime = DateTime.now();
  List<ContactReport> reports = [];

  bool isLoggedIn = false;
  @override
  Widget build(BuildContext context) {
    List<DataColumn> columns = [
      DataColumn(
        label: const Text('Date'),
        numeric: false,
        tooltip: 'Date of the report entry',
      ),
      DataColumn(
        label: const Text('Ad'),
        numeric: false,
        tooltip: 'Report entry ad',
      ),
      DataColumn(
        label: const Text('Action'),
        numeric: false,
        tooltip: 'Action of the report entry',
      ),
      DataColumn(
        label: const Text('User'),
        numeric: false,
        tooltip: 'user',
      ),
    ];

    double fullWidth = MediaQuery.of(context).size.width - 32;
    double horizontalSpace = 18;
    double verticalSpace = 24.0;
    double padding = 24.0;
    double columnWidth =
        (fullWidth - (2 * horizontalSpace) - (2.0 * padding) - (2.0 * 18)) / 3;
    const kTextFieldDecoration = InputDecoration(
        hintStyle:
            TextStyle(color: Colors.black87, fontStyle: FontStyle.italic),
        contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 1.0),
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: Color.fromRGBO(98, 0, 238, 1.0), width: 2.0),
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
        ));


    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                BlocProvider(
                  create: (context) =>
                      ReportListBloc(databaseService: _databaseService)
                        ..add(ReportListInitialEvent(startTime: startTime)),
                  child: BlocBuilder<AdListBloc, AdListState>(
                      builder: (context, state) {
                    List<DropdownMenuItem<Ad>> adList = [];
                    if (state is AdListLoadSuccessState) {
                      List<Ad> ads = state.adList.list;
                      adList = ads.map((ad) {
                        return DropdownMenuItem(
                            child: Text(ad.name), value: ad);
                      }).toList();
                      adList.add(DropdownMenuItem(
                          child: Text("All Ads"), value: null));
                    }

                    return Container(
                        alignment: Alignment.topCenter,
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 30),
                                child: Column(children: [
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              Text('All Reports',
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    fontSize: 24,
                                                    color: Colors.black,
                                                    fontFamily: 'Inter',
                                                  )),
                                            ]),
                                        IconButton(
                                          style: IconButton.styleFrom(
                                              backgroundColor:
                                                  Color.fromRGBO(0, 99, 152, 1),
                                              shape: CircleBorder(
                                                  side: BorderSide(
                                                width: 40,
                                                color: Colors.white,
                                              ))),
                                          onPressed: () => {
                                            setState(() {
                                              reports = [];
                                            }),
                                            BlocProvider.of<ReportListBloc>(
                                                    context)
                                                .add(ReportListInitialEvent(
                                                    startTime: startTime))
                                          },
                                          icon: const Icon(
                                              Icons.refresh_outlined),
                                        ),
                                      ]),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Radio<ActionType>(
                                          value: ActionType.user,
                                          groupValue: actionType,
                                          onChanged: (ActionType? value) {
                                            setState(() {
                                              actionType = value!;
                                            });
                                          },
                                        ),
                                        Text("User Sign-up Event"),
                                        Radio<ActionType>(
                                          value: ActionType.click,
                                          groupValue: actionType,
                                          onChanged: (ActionType? value) {
                                            setState(() {
                                              actionType = value!;
                                            });
                                          },
                                        ),
                                        Text("Ad Click Event"),
                                        Radio<ActionType>(
                                          value: ActionType.all,
                                          groupValue: actionType,
                                          onChanged: (ActionType? value) {
                                            setState(() {
                                              actionType = value!;
                                            });
                                          },
                                        ),
                                        Text("All Events"),
                                        SizedBox(
                                          width: horizontalSpace,
                                        ),
                                        SizedBox(
                                            width: columnWidth,
                                            child: DropdownButtonFormField(
                                              value: selectedAd,
                                              decoration:
                                                  kTextFieldDecoration.copyWith(
                                                hintText: "AD ID",
                                              ),
                                              items: adList,
                                              onChanged:
                                                  actionType == ActionType.user
                                                      ? null
                                                      : (Object? value) {
                                                          setState(() {
                                                            selectedAd = value == null ? null :
                                                                value as Ad;
                                                          });
                                                        },
                                            )),
                                        SizedBox(
                                          width: horizontalSpace,
                                        ),

                                        SizedBox(
                                            width: columnWidth * 0.4,
                                            child: DateTimeFormField(
                                                onDateSelected:
                                                    (DateTime value) {
                                                  setState(() {
                                                    startTime = value;
                                                  });
                                                },
                                                initialValue: startTime,
                                                decoration:
                                                kTextFieldDecoration.copyWith(
                                                  hintText: "From",
                                                ),
                                                dateFormat: DateFormat.yMd(),
                                                lastDate: endTime.add(Duration(days: -1)),
                                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                                mode: DateTimeFieldPickerMode
                                                    .date)),
                                        SizedBox(
                                          width: horizontalSpace * .5,
                                        ), SizedBox(
                                            width: columnWidth * 0.4,
                                            child: DateTimeFormField(
                                                onDateSelected:
                                                    (DateTime value) {
                                                  setState(() {
                                                    DateTime endOfDay = value.add(Duration(days: 1));
                                                    endTime = endOfDay;
                                                  });
                                                },
                                                initialValue: endTime,
                                                decoration:
                                                kTextFieldDecoration.copyWith(
                                                  hintText: "To",
                                                ),
                                                dateFormat: DateFormat.yMd(),
                                                firstDate: startTime,
                                                autovalidateMode: AutovalidateMode.always,
                                                mode: DateTimeFieldPickerMode
                                                    .date)),
                                      ]),
                                  ConstrainedBox(
                                      constraints: BoxConstraints.expand(
                                          height: MediaQuery.of(context)
                                              .size
                                              .height),
                                      child: SingleChildScrollView(child:
                                          BlocBuilder<ReportListBloc,
                                                  ReportListState>(
                                              builder: (context, state) {
                                        if (state
                                            is ReportListLoadSuccessState) {
                                          ContactReportList reportList =
                                              state.reportList;
                                          reports =
                                              reportList.list.where((report) {
                                            return (actionType ==
                                                        ActionType.all ||
                                                    report.action ==
                                                        actionType.name) &&
                                                (selectedAd == null ||
                                                    actionType ==
                                                        ActionType.user ||
                                                    report.adId ==
                                                        selectedAd!.id) &&
                                                (report.date!.isAfter(startTime) && report.date!.isBefore(endTime));
                                          }).toList();

                                          List<DataRow> reportRows = reports
                                              .map((report) => DataRow(cells: [
                                                    DataCell(TableCell(
                                                        content: report.date !=
                                                                null
                                                            ? DateFormat.yMd()
                                                                .add_jm()
                                                                .format(report
                                                                    .date!)
                                                            : '')),
                                                    DataCell(TableCell(
                                                        content:
                                                            report.adName)),
                                                    DataCell(TableCell(
                                                        content:
                                                            report.action)),
                                                    DataCell(Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(report.userName),
                                                          Text(report.email),
                                                          Text(report.phone),
                                                        ])),
                                                  ]))
                                              .toList();
                                          return DataTable(
                                            showCheckboxColumn: false,
                                            rows: reportRows,
                                            columns: columns,

                                            // other arguments
                                          );
                                        } else if (state
                                            is ReportListLoadFailureState) {
                                          return Text(
                                              'Error loading reports: ${state.err}');
                                        } else {
                                          return Center(
                                            child: LoadingIndicator(
                                              key: UniqueKey(),
                                            ),
                                          );
                                        }
                                      })))
                                ]))));
                  }),
                ),
              ]),
        )));
  }

  @override
  void initState() {
    isLoggedIn = false;
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // print('We gots user: ${user.displayName}');
      setState(() {
        isLoggedIn = true;
      });
    }
    super.initState();
  }
}

class TableCell extends StatelessWidget {
  final String content;

  TableCell({required this.content}) : super() {}

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
        child: Align(
            alignment: Alignment.topLeft,
            child: Text(
              content,
              overflow: TextOverflow.visible,
              softWrap: true,
            )));
  }
}
