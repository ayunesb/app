
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/settings/settings_bloc.dart';
import '../../../models/ad.dart';
import '../../../models/settings.dart';
import '../../widgets/property/property_list.dart';
import 'admin_settings_edit_form.dart';
import 'admin_header_footer.dart';

class AdminSettingsDetail extends StatefulWidget {

  AdminSettingsDetail({Key? key})
      : super(key: key) {}

  @override
  State createState() => _AdminSettingsDetailState();
}

class _AdminSettingsDetailState extends State {
  late List<AppSettings> settings;

  _AdminSettingsDetailState();

  bool isLoggedIn = false;
  @override
  Widget build(BuildContext context) {
    var headerStyle = TextStyle(
        fontSize: 16.0, fontWeight: FontWeight.w700, fontFamily: 'Inter');
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(child:
            BlocBuilder<SettingsBloc, SettingsState>(builder: (context, state) {
          if (state is SettingsLoadSuccessState) {
            settings = state.allSettings!;
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.start, children: <
                      Widget>[
                AdminHeader(),
                Container(
                    width: 1090,
                    alignment: Alignment.topCenter,
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 170, vertical: 30),
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
                                          IconButton(
                                            splashColor: Colors.black,
                                            icon: const Icon(Icons.arrow_back),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                          Text('Settings',
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
                                              onPressed: () => {
                                                    showDialog(
                                                      context: context,
                                                      barrierDismissible: false,
                                                      builder: (BuildContext
                                                          context) {
                                                        return
                                                          BlocProvider(
                                                            create: (context) =>
                                                                SettingsBloc(),
                                                            child: AdminSettingsEditForm(
                                                                settings: settings),
                                                          );


                                                      },
                                                    ).whenComplete(() {
                                                      BlocProvider.of<
                                                                  SettingsBloc>(
                                                              context)
                                                          .add(
                                                              SettingsInitialEvent());
                                                      setState(() {});
                                                    })
                                                  },
                                              child: Text("EDIT")),
                                        ]),
                                  ]),
                              ConstrainedBox(
                                  constraints: BoxConstraints.expand(
                                      width: MediaQuery.of(context).size.width,
                                      height:
                                          MediaQuery.of(context).size.height),
                                  child: SingleChildScrollView(
                                      child: Column(children: [
                                    SizedBox(
                                      height: 24.0,
                                    ),
                                    Table(columnWidths: {
                                      0: FractionColumnWidth(.33),
                                      1: FractionColumnWidth(.66)
                                    }, children:
                                        settings.map((setting) {
                                  return _createRow(setting.label, setting.value);
                                  }).toList()
                                    ),
                                    SizedBox(
                                      height: 24.0,
                                    ),

                                  ])))
                            ])))),
              ]),
            );
          } else if (state is SettingsLoadFailureState) {
            return Text('Error loading Settings');
          } else {
            return Center(
              child: LoadingIndicator(
                key: UniqueKey(),
              ),
            );
          }
        })));
  }

  @override
  void initState() {
    BlocProvider.of<SettingsBloc>(context)
        .add(SettingsInitialEvent());
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

TableRow _createRow(final String label, final String value) {
  var textStyle = TextStyle(
      fontSize: 14.0, fontWeight: FontWeight.w400, fontFamily: 'Inter');
  return TableRow(children: [
    Padding(
        padding: EdgeInsets.symmetric(vertical: 15),
        child: Text(label + ':', style: textStyle)),
    Padding(
        padding: EdgeInsets.symmetric(vertical: 15),
        child: Text(value, style: textStyle))
  ]);
}

