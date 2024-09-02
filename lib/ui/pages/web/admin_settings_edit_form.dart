import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_draggable_gridview/flutter_draggable_gridview.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../blocs/ads/ad_bloc.dart';
import '../../../blocs/settings/settings_bloc.dart';
import '../../../models/ad.dart';
import '../../../models/settings.dart';
import '../../../service/database_service.dart';
import '../../../service/image_storage_service.dart';
import '../../widgets/property/property_list.dart';

String getExtension(String path) {
  return path.substring(path.lastIndexOf(".") + 1);
}

const kTextFieldDecoration = InputDecoration(
    hintStyle: TextStyle(color: Colors.black87, fontStyle: FontStyle.italic),
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

var buttonStyle = OutlinedButton.styleFrom(
    minimumSize: Size(220, 48),
    backgroundColor: Colors.white,
    primary: Color.fromRGBO(0, 99, 152, 1.0),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(5)),
    ));

var headerStyle =
    TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700, fontFamily: 'Inter');

var header700 = TextStyle(
    fontSize: 32,
    color: Colors.black,
    fontFamily: 'Inter',
    fontWeight: FontWeight.w700);

class AdminSettingsEditForm extends StatefulWidget {
  final List<AppSettings> settings;

  AdminSettingsEditForm({Key? key, required this.settings}) : super(key: key) {}

  @override
  State createState() => _AdminAdEditFormState(settings);
}

class _AdminAdEditFormState extends State {
  late List<AppSettings>? settings;

  _AdminAdEditFormState(this.settings) {}

  final _formKey = GlobalKey<FormState>();
  bool isLoggedIn = false;

  @override
  Widget build(BuildContext context) {
    double fullWidth = MediaQuery.of(context).size.width - 32;
    double horizontalSpace = 18;
    double verticalSpace = 24.0;
    double padding = 24.0;
    double columnWidth =
        (fullWidth - (2 * horizontalSpace) - (2.0 * padding) - (2.0 * 18)) / 3;
    return Dialog(
        insetPadding: EdgeInsets.all(16),
        child:
        Container(
      child: Column(
      mainAxisSize: MainAxisSize.min,
          children:[ Padding(
                  padding: EdgeInsets.all(padding),
                  child: Center(child: SingleChildScrollView(child:
                      BlocBuilder<SettingsBloc, SettingsState>(
                          builder: (context, state) {
                    if (state is SettingsLoadSuccessState) {
                      settings = state.allSettings!;
                      List<Widget> rows = [];
                      for (AppSettings setting in settings!) {
                        rows.add(Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(setting.label),
                              SizedBox(
                                width: horizontalSpace,
                              ),
                              SizedBox(
                                  width: columnWidth,
                                  child: TextFormField(
                                    initialValue: setting.value,
                                    decoration: kTextFieldDecoration.copyWith(
                                      hintText: setting.label,
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter ${setting.label}';
                                      }
                                      return null;
                                    },
                                    onChanged: (Object? value) {
                                      setState(() {
                                        setting.value = value.toString();
                                      });
                                    },
                                  )),
                              SizedBox(
                                height: verticalSpace,
                              ),
                            ]));
                      }

                      rows.add(SizedBox(
                        height: verticalSpace,
                      ),);
                      rows.add( Row(children: [
                        OutlinedButton(
                          onPressed: () async {
                            BlocProvider.of<SettingsBloc>(context).add(
                                SettingsUpdateEvent(settings: settings!));
                            Navigator.pop(context);
                          },
                          style: OutlinedButton.styleFrom(
                              minimumSize: Size(220, 48),
                              backgroundColor:
                              Color.fromRGBO(0, 99, 152, 1.0),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(5)),
                              )),
                          child: const Text('SAVE & CLOSE',
                              style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Inter')),
                        ),
                      ]));
                      return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24.0),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                    width: fullWidth,
                                    alignment: Alignment.topCenter,
                                    child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Column(children: [
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: IconButton(
                                              splashColor: Colors.black,
                                              icon: const Icon(Icons.close),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text('Edit Settings',
                                                textAlign: TextAlign.left,
                                                style: header700),
                                          ),
                                          Form(
                                            key: _formKey,
                                            onChanged: () => {},
                                            child: Column(children: rows),
                                          )
                                        ]))),
                              ]));
                    } else if (state is SettingsLoadFailureState){
                      return Text('Error getting settings: ${state.error}');
                    }
                    else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }))))])),
          );
  }

  @override
  void initState() {
    isLoggedIn = false;
    BlocProvider.of<SettingsBloc>(context)
        .add(SettingsInitialEvent());
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        isLoggedIn = true;
      });
    }

    super.initState();
  }
}
