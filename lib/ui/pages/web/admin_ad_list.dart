import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/ads/ad_bloc.dart';
import '../../../blocs/ads/ad_list_bloc.dart';
import '../../../models/ad.dart';
import '../../../service/ad_service.dart';
import '../../widgets/property/property_list.dart';
import 'admin_ad_detail.dart';
import 'admin_ad_edit_form.dart';

class AdminAdList extends StatefulWidget {
  const AdminAdList({Key? key}) : super(key: key);

  @override
  State createState() => _AdminAdListState();
}

class _AdminAdListState extends State {
  bool active = true;
  bool isLoggedIn = false;
  @override
  Widget build(BuildContext context) {
    List<DataColumn> columns = [
      DataColumn(
        label: const Text('Name'),
        numeric: false,
        tooltip: 'Name of the ad',
      ),
      DataColumn(
        label: const Text('Image'),
        numeric: false,
        tooltip: 'Ad image',
      ),
      DataColumn(
        label: const Text('Link URL'),
        numeric: false,
        tooltip: 'Link to go to when user clicks on ad',
      ),
      DataColumn(
        label: const Text('Size/Type'),
        numeric: false,
        tooltip: 'Size and type of the ad',
      ),
      DataColumn(
        label: const Text('Active'),
        numeric: false,
        tooltip: 'Whether ad is active',
      ),
      DataColumn(
        label: const Text('Modified'),
        numeric: false,
        tooltip: 'When last modified',
      ),
      DataColumn(
        label: const Text(''),
      ),
    ];

    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Text('All Ads',
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                fontSize: 24,
                                                color: Colors.black,
                                                fontFamily: 'Inter',
                                              )),
                                        ]),
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          OutlinedButton(
                                              onPressed: () {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title:
                                                          const Text('FILTERS'),
                                                      content: new Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                          InkWell(
                                                              highlightColor:
                                                                  Color
                                                                      .fromRGBO(
                                                                          0,
                                                                          99,
                                                                          152,
                                                                          1),
                                                              onTap: () {
                                                                setState(() {
                                                                  active = true;
                                                                });
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                              child: Text(
                                                                  "Active")),
                                                          InkWell(
                                                              highlightColor:
                                                                  Color
                                                                      .fromRGBO(
                                                                          0,
                                                                          99,
                                                                          152,
                                                                          1),
                                                              onTap: () {
                                                                setState(() {
                                                                  active =
                                                                      false;
                                                                });
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                              child: Text(
                                                                  "Inactive")),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                );
                                              },
                                              child: Text("FILTER")),
                                          ElevatedButton(
                                            onPressed: () => {
                                              showDialog(
                                                context: context,
                                                barrierDismissible: false,
                                                builder:
                                                    (BuildContext context) {
                                                  return AdminAdEditForm(
                                                      adId: "", add: true);
                                                },
                                              ).whenComplete(() {
                                                setState(() {});
                                              })
                                            },
                                            style: ElevatedButton.styleFrom(
                                                fixedSize: Size(40, 40),
                                                primary: Color.fromRGBO(
                                                    0, 99, 152, 1),
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
                                      height:
                                          MediaQuery.of(context).size.height),
                                  child: SingleChildScrollView(
                                    child: BlocBuilder<AdListBloc, AdListState>(
                                        builder: (context, state) {
                                      if (state is AdListLoadSuccessState) {
                                        AdList adList = state.adList;
                                        List<Ad> ads = adList.list;

                                        List<DataRow> adRows = [];
                                        for (Ad ad in ads) {
                                          if (ad.active == active) {
                                            adRows.add(createAdDataRow(ad));
                                          }
                                        }
                                        return DataTable(
                                          dataRowHeight: 200,
                                          showCheckboxColumn: false,
                                          rows: adRows,
                                          columns: columns,
                                        );
                                      } else if (state
                                          is AdListLoadFailureState) {
                                        return Text(
                                            'Error loading ads: ${state.err}');
                                      } else {
                                        return Center(
                                          child: LoadingIndicator(
                                            key: UniqueKey(),
                                          ),
                                        );
                                      }
                                    }),
                                  ))
                            ])))),
              ]),
        )));
  }

  DataRow createAdDataRow(Ad ad) {
    double imageHeight = 180;
    double imageWidth = 300;

    switch (ad.size) {
      case AdSize.small:
        imageHeight = 50;
        break;
      case AdSize.medium:
        {
          print('createAdDataRow:medium');
          imageHeight = 100;
          break;
        }
      case AdSize.large:
        imageHeight = 250;
        imageWidth = 250;
        break;
    }

    return DataRow(
        onSelectChanged: (bool? isSelected) {
          if (isSelected != null) {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AdminAdDetail(adId: ad.id, add: false),
                ));
          }
        },
        cells: [
          DataCell(TableCell(
              content: Text(
            ad.name,
            overflow: TextOverflow.visible,
            softWrap: true,
          ))),
          DataCell(TableCell(
              content: Container(
                  height: imageHeight,
                  width: imageWidth,
                  //margin: EdgeInsets. all(10),
                  child: InkWell(
                    onTap: () => {},
                    child: Stack(children: [
                      Image.network(
                        ad.url,
                        fit: BoxFit.fitHeight,
                        height: imageHeight,
                        width: imageWidth,
                        errorBuilder: (context, error, stackTrace) {
                          return Center(
                            child: Text(
                                'Error loading image: ${error.toString()}'),
                          ); //do something
                        },
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                      ),
                    ]),
                  )))),
          DataCell(TableCell(
              content: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.2,
                  child: Text(
                    ad.to,
                    overflow: TextOverflow.visible,
                    softWrap: true,
                  )))),
          DataCell(TableCell(
              content: Text(
            ad.type.name + " / " + ad.size.name,
            overflow: TextOverflow.ellipsis,
            softWrap: true,
          ))),
          DataCell(TableCell(
              content: Text(
            ad.active ? 'Active' : 'Inactive',
            overflow: TextOverflow.visible,
            softWrap: true,
          ))),
          DataCell(TableCell(
              content: Text(
            ad.updatedAt.toString(),
            overflow: TextOverflow.visible,
            softWrap: true,
          ))),
          DataCell(IconButton(
            icon: Icon(Icons.more_horiz),
            onPressed: () {
              showActionsDialog(ad);
            },
          )),
        ]);
  }

  void showActionsDialog(Ad ad) {
    double verticalSpace = 16;
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
                        return AdminAdEditForm(adId: ad.id, add: false);
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
                        return AdminAdEditForm(adId: ad.id, add: true);
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
                                "Are you sure you want to delete this ad?",
                                style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.black,
                                  fontFamily: 'Inter',
                                )),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(
                                  height: verticalSpace,
                                ),
                                Text(ad.name),
                              ],
                            ),
                            actions: [MultiBlocProvider(providers: [BlocProvider(
                          lazy: false,
                              create: (context) => AdBloc()),
                              BlocProvider(
                                  lazy: false,
                                  create: (context) => AdListBloc(adService: AdService()))], child:
        BlocBuilder<AdBloc, AdState>(
        builder: (context, state) {
        return OutlinedButton(
                                  onPressed: () async {
                                    bool oldStatus = ad.active;
                                    ad.active = false;
                                    print('DELETE:0.a');
                                    BlocProvider.of<AdBloc>(context)
                                        .add(AdDeleteEvent(ad: ad));
                                    print('DELETE:0.b');
                                    setState(() {});
                                    try {
                                      print('DELETE:1');
                                      BlocProvider.of<AdListBloc>(context)
                                          .add(AdListInitialEvent(active: true));
                                    } catch (e) {
                                      print('DELETE:2');
                                      print(e);
                                    }
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("DELETE"));})),
                              OutlinedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("CANCEL")),
                            ],
                          );
                        });
                  },
                  child: Text("Delete")),
            ],
          ),
        );
      },
    );
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
  final Widget content;

  TableCell({required this.content}) : super() {}

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
        child: Align(alignment: Alignment.topLeft, child: content));
  }
}
