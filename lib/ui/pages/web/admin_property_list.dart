import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:paradigm_mex/models/property.dart';
import 'package:paradigm_mex/ui/widgets/property/property_list.dart';

import '../../../blocs/filters/filters_bloc.dart';
import '../../../blocs/property/property_list_bloc.dart';
import '../../../service/database_service.dart';
import '../../widgets/property/filters.dart';
import 'admin_property_detail.dart';
import 'admin_property_edit_form.dart';

class AdminPropertyList extends StatefulWidget {
  const AdminPropertyList({Key? key}) : super(key: key);

  @override
  State createState() => _AdminPropertyListState();
}

class _AdminPropertyListState extends State {
  final moneyFormatter =
      NumberFormat.currency(name: '', locale: 'es_mx', symbol: '\$');
  late DatabaseService _databaseService = DatabaseService();
  ActiveType actionTypeFilter = ActiveType.active;
  bool isLoggedIn = false;
  List<Property> properties = [];
  @override
  Widget build(BuildContext context) {
    List<DataColumn> columns = [
      DataColumn(
        label: const Text('Address'),
        numeric: false,
        tooltip: 'Address of Property',
      ),
      DataColumn(
        label: const Text('Price'),
        numeric: true,
        tooltip: 'Price of Property',
      ),
      DataColumn(
        label: const Text('Status'),
        numeric: false,
        tooltip: 'Status of the item',
      ),
      DataColumn(
        label: const Text(''),
        numeric: false,
      ),
    ];
    double verticalSpace = 16;
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            child: Padding(
          padding: EdgeInsets.all(48),
          child: Align(
              alignment: Alignment.centerLeft,
              child: Column(children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text('All Properties',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.black,
                                  fontFamily: 'Inter',
                                )),
                          ]),
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                        OutlinedButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('FILTERS'),
                                    content: new Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        InkWell(
                                            highlightColor:
                                                Color.fromRGBO(0, 99, 152, 1),
                                            onTap: () {
                                              setState(() {
                                                actionTypeFilter =
                                                    ActiveType.all;
                                              });
                                              Navigator.of(context).pop();
                                            },
                                            child: Text("All")),
                                        InkWell(
                                            highlightColor:
                                                Color.fromRGBO(0, 99, 152, 1),
                                            onTap: () {
                                              setState(() {
                                                actionTypeFilter =
                                                    ActiveType.in_progress;
                                              });
                                              Navigator.of(context).pop();
                                            },
                                            child: Text("In Progress")),
                                        InkWell(
                                            highlightColor:
                                                Color.fromRGBO(0, 99, 152, 1),
                                            onTap: () {
                                              setState(() {
                                                actionTypeFilter =
                                                    ActiveType.active;
                                              });
                                              Navigator.of(context).pop();
                                            },
                                            child: Text("Active")),
                                        InkWell(
                                            highlightColor:
                                                Color.fromRGBO(0, 99, 152, 1),
                                            onTap: () {
                                              setState(() {
                                                actionTypeFilter =
                                                    ActiveType.deleted;
                                              });
                                              Navigator.of(context).pop();
                                            },
                                            child: Text("Deleted")),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                            child: Text("FILTER")),
                        ElevatedButton(
                          onPressed: () async {
                          print('=================== ADD onPressed:images:0');
                          Property updatedProperty =  await showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return AdminPropertyEditForm(
                                property: Property(), add: true);
                          },
                        ).whenComplete(() {
                          setState(() {});
                        });
                setState(() {
        print('=================== ADD whenComplete:images:${updatedProperty.propertyImages?.list.length}');
        properties.add(updatedProperty);
        });



                          },
                          style: ElevatedButton.styleFrom(
                              fixedSize: Size(40, 40),
                              primary: Color.fromRGBO(0, 99, 152, 1),
                              shape: CircleBorder(
                                  side: BorderSide(
                                width: 40,
                                color: Colors.white,
                              ))),
                          child: const Icon(Icons.add),
                        ),
                      ]),
                    ]),
                ConstrainedBox(
                    constraints: BoxConstraints.expand(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height),
                    child: BlocBuilder<FiltersBloc, FiltersState>(
                        builder: (context, state) {
                      PropertyFilters filters = PropertyFilters();
                      if (state is FiltersLoadSuccessState) {
                        filters = state.propertyFilters;
                      } else if (state is FiltersChangedState) {
                        filters = state.propertyFilters;
                      }
                      return SingleChildScrollView(
                        child: BlocBuilder<PropertyListBloc, PropertyListState>(
                            builder: (context, state) {
                          if (state is PropertyListLoadSuccessState) {
                            PropertyList propertyList = state.propertyList;
                            properties = propertyList.list;

                            List<DataRow> propertyRows = [];
                            for (Property property in properties) {
                              if (actionTypeFilter == ActiveType.all ||
                                  property.dbStatus == actionTypeFilter.name &&
                                      (filterProperty(property, filters))) {
                                propertyRows.add(
                                    //createPropertyRow(p)
                                    DataRow(
                                        onSelectChanged: (bool? isSelected) {
                                          if (isSelected != null) {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      AdminPropertyDetail(
                                                          property: property,
                                                          add: false),
                                                ));
                                          }
                                        },
                                        cells: [
                                      DataCell(Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                property.propertyName.isNotEmpty
                                                    ? property.propertyName
                                                    : property.streetAddress,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Flexible(
                                                child:
                                                    Text(property.fullAddress)),
                                          ])),
                                      DataCell(Text(moneyFormatter
                                          .format(property.currentPrice))),
                                      DataCell(
                                        Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(property.dbStatus),
                                              Text(property.promoted!
                                                  ? "promoted"
                                                  : '')
                                            ]),
                                      ),
                                      DataCell(IconButton(
                                        icon: Icon(Icons.more_horiz),
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: const Text('ACTIONS'),
                                                content: new Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    InkWell(
                                                        highlightColor:
                                                            Color.fromRGBO(
                                                                0, 99, 152, 1),
                                                        onTap: () async {
                                                          Navigator.pop(
                                                              context, false);
                                                          print('=================== onPressed:images:${property.propertyImages?.list.length}');
                                                          Property updatedProperty =  await showDialog(
                                                            context: context,
                                                            barrierDismissible:
                                                                false,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return AdminPropertyEditForm(
                                                                  property:
                                                                      property,
                                                                  add: false);
                                                            },
                                                          ).whenComplete(() {
                                                            print('=================== whenComplete:images:${property.propertyImages?.list.length}');
                                                            setState(() {});
                                                          });
                                                        },
                                                        child: Text("Edit")),
                                                    InkWell(
                                                        highlightColor:
                                                            Color.fromRGBO(
                                                                0, 99, 152, 1),
                                                        onTap: () async {
                                                          Navigator.pop(
                                                              context, false);
                                                          print('=================== DUPLICATE onPressed:images:${property.propertyImages?.list.length}');
                                                          Property updatedProperty =  await showDialog(
                                                            context: context,
                                                            barrierDismissible:
                                                                false,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return AdminPropertyEditForm(
                                                                  property:
                                                                      Property(),
                                                                  add: true);
                                                            },
                                                          );
                                                          setState(() {
                                                            print('=================== DUPLICATE whenComplete:images:${property.propertyImages?.list.length}');
                                                            properties.add(updatedProperty);
                                                          });

                                                        },
                                                        child:
                                                            Text("Duplicate")),
                                                    InkWell(
                                                        highlightColor:
                                                            Color.fromRGBO(
                                                                0, 99, 152, 1),
                                                        onTap: () {
                                                          Navigator.pop(
                                                              context, false);

                                                          showDialog(
                                                              context: context,
                                                              barrierDismissible:
                                                                  false,
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return AlertDialog(
                                                                  title: const Text(
                                                                      "Are you sure you want to delete this property?",
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            24,
                                                                        color: Colors
                                                                            .black,
                                                                        fontFamily:
                                                                            'Inter',
                                                                      )),
                                                                  content:
                                                                      Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: <Widget>[
                                                                      SizedBox(
                                                                        height:
                                                                            verticalSpace,
                                                                      ),
                                                                      Text(property
                                                                          .fullAddress),
                                                                    ],
                                                                  ),
                                                                  actions: [
                                                                    OutlinedButton(
                                                                        onPressed:
                                                                            () async {
                                                                          String
                                                                              oldStatus =
                                                                              property.dbStatus;
                                                                          property.dbStatus = ActiveType
                                                                              .deleted
                                                                              .name;
                                                                          bool
                                                                              success =
                                                                              await _databaseService.updateProperty(property: property);
                                                                          if (!success) {
                                                                            property.dbStatus =
                                                                                oldStatus;
                                                                          }

                                                                          setState(
                                                                              () {});
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                        },
                                                                        child: Text(
                                                                            "DELETE")),
                                                                    OutlinedButton(
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                        },
                                                                        child: Text(
                                                                            "CANCEL")),
                                                                  ],
                                                                );
                                                              }).whenComplete(() {
                                                            try {
                                                              BlocProvider.of<
                                                                          PropertyListBloc>(
                                                                      context)
                                                                  .add(PropertyListInitialEvent(
                                                                      active: ActiveType
                                                                          .all));
                                                            } catch (e) {
                                                              print(e);
                                                            }
                                                          });
                                                        },
                                                        child: Text("Delete")),
                                                  ],
                                                ),
                                              );
                                            },
                                          );
                                        },
                                      )),
                                    ]));
                              }
                            }

                            return Column(children: [
                              if (filters != null)
                                Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey)),
                                    width: MediaQuery.of(context).size.width *
                                        0.55,
                                    child: Padding(
                                        padding: EdgeInsets.only(
                                            left: 4.0, bottom: 4.0),
                                        child: Container(
                                            height: 40.0,
                                            child: TextFormField(
                                              style: TextStyle(fontSize: 18),
                                              textAlignVertical:
                                                  TextAlignVertical.center,
                                              initialValue: filters.initialized
                                                  ? filters
                                                      .propertyName.values[0]
                                                  : '',
                                              onChanged: (String value) => {
                                                if (filters.initialized)
                                                  {
                                                    filters.propertyName
                                                        .values[0] = value
                                                  }
                                              },
                                              keyboardType: TextInputType.text,
                                              decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  suffixIcon: IconButton(
                                                    splashColor: Colors.black,
                                                    icon: const Icon(
                                                        Icons.search_outlined),
                                                    onPressed: () {
                                                      BlocProvider.of<
                                                                  FiltersBloc>(
                                                              context)
                                                          .add(FiltersChangedEvent(
                                                              propertyFilters:
                                                                  filters));
                                                    },
                                                  )),
                                            )))),
                              if (propertyRows.isNotEmpty)
                                DataTable(
                                  showCheckboxColumn: false,
                                  rows: propertyRows,
                                  columns: columns,
                                  // other arguments
                                )
                              else
                                Text('No results')
                            ]);
                          } else if (state is PropertyListLoadFailureState) {
                            return FailurePropertyList(
                                errorMsg: state.errorMsg,
                                stacktrace: state.stacktrace);
                          } else {
                            return Center(
                              child: LoadingIndicator(
                                key: UniqueKey(),
                              ),
                            );
                          }
                        }),
                      );
                    }))
              ])),
        )));
  }

  DataRow createPropertyRow(Property property) {
    double verticalSpace = 18;
    return DataRow(
        onSelectChanged: (bool? isSelected) {
          if (isSelected != null) {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      AdminPropertyDetail(property: property, add: false),
                ));
          }
        },
        cells: [
          DataCell(Flexible(child: Text(property.fullAddress))),
          DataCell(Text(moneyFormatter.format(property.currentPrice))),
          DataCell(Text(property.dbStatus)),
          DataCell(IconButton(
            icon: Icon(Icons.more_horiz),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('ACTIONS'),
                    content: new Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        InkWell(
                            highlightColor: Color.fromRGBO(0, 99, 152, 1),
                            onTap: () {
                              Navigator.pop(context, false);
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return AdminPropertyEditForm(
                                      property: property, add: false);
                                },
                              ).whenComplete(() {
                                setState(() {});
                              });
                            },
                            child: Text("Edit")),
                        InkWell(
                            highlightColor: Color.fromRGBO(0, 99, 152, 1),
                            onTap: () {
                              Navigator.pop(context, false);
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return AdminPropertyEditForm(
                                      property: Property(), add: true);
                                },
                              ).whenComplete(() {
                                setState(() {});
                              });
                            },
                            child: Text("Duplicate")),
                        InkWell(
                            highlightColor: Color.fromRGBO(0, 99, 152, 1),
                            onTap: () {
                              Navigator.pop(context, false);

                              showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text(
                                          "Are you sure you want to delete this property?",
                                          style: TextStyle(
                                            fontSize: 24,
                                            color: Colors.black,
                                            fontFamily: 'Inter',
                                          )),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          SizedBox(
                                            height: verticalSpace,
                                          ),
                                          Text(property.fullAddress),
                                        ],
                                      ),
                                      actions: [
                                        OutlinedButton(
                                            onPressed: () async {
                                              property.dbStatus =
                                                  ActiveType.deleted.name;
                                              bool success =
                                                  await _databaseService
                                                      .updateProperty(
                                                          property: property);
                                              BlocProvider.of<PropertyListBloc>(
                                                      context)
                                                  .add(PropertyListInitialEvent(
                                                      active: ActiveType.all));
                                              Navigator.of(context).pop();
                                            },
                                            child: Text("DELETE")),
                                        OutlinedButton(
                                            onPressed: () {
                                              BlocProvider.of<PropertyListBloc>(
                                                      context)
                                                  .add(PropertyListInitialEvent(
                                                      active: ActiveType.all));
                                              Navigator.of(context).pop();
                                            },
                                            child: Text("CANCEL")),
                                      ],
                                    );
                                  }).whenComplete(() {
                                setState(() {});
                              });
                            },
                            child: Text("Delete")),
                      ],
                    ),
                  );
                },
              );
            },
          )),
        ]);
  }

  @override
  void initState() {
    isLoggedIn = false;
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        isLoggedIn = true;
      });
    }

    super.initState();
  }
}
