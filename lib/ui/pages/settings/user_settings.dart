import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paradigm_mex/generated/l10n.dart';
import 'package:validators/validators.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../../blocs/language/language_change_bloc.dart';
import '../../../blocs/user/user_settings_bloc.dart';
import '../../../models/user.dart';
import '../../../service/analytics_service.dart';

class UserSettings extends StatefulWidget {
  const UserSettings({Key? key}) : super(key: key);

  @override
  _UserSettingsState createState() => _UserSettingsState();
}

class _UserSettingsState extends State<UserSettings> {
  AnalyticsServices analytics = AnalyticsServices();
  
  bool phoneIsValid(String phone) {
    return RegExp(r"^\s*(?:\+\d\d?\d?)?\s*(?:\(\d\d?\d?\))?\s*[\d\s-]{5,12}\s*$")
        .hasMatch(phone);
  }

bool toggle(bool value) {
  // returns the opposite
  return !value;
}


  final kTextFieldDecoration = InputDecoration(
      hintStyle: TextStyle(color: Colors.black87, fontStyle: FontStyle.italic),
      contentPadding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey, width: 1.0),
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red, width: 2.0),
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red, width: 1.0),
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide:
        BorderSide(color: Color.fromRGBO(98, 0, 238, 1.0), width: 2.0),
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
      ));

  @override
  Widget build(BuildContext context) {
    User? user = null;
    return BlocBuilder<LanguageBloc, LanguageState>(
        builder: (context, state) {
      return Container(child: BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {

        if (state is UserLoadedSuccess) {
          user = state.user;
        } else if (state is UserUpdatedSuccess) {
          user = state.user;
        }
         if(user != null) return Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
        Padding(
        padding: EdgeInsets.only(left: 4),
        child: Text(S.of(context).user_settings_title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
            Padding(
                padding: EdgeInsets.only(left: 4, right: 8.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(S.of(context).name, style: TextStyle(fontSize: 16)),
                      Container(
                          width: MediaQuery.of(context).size.width - 120,
                          child: TextFormField(
                            decoration: kTextFieldDecoration,
                            style: TextStyle(fontSize: 16),
                            textAlignVertical: TextAlignVertical.center,
                            initialValue: user!.name,
                            onChanged: (String value) => {
                              user!.name = value,
                              analytics.logScreen((UserSettings).toString(),
                                  'User name: ${value}'),
                              BlocProvider.of<UserBloc>(context)
                                  .add(UserUpdateEvent(user!))
                            },
                            keyboardType: TextInputType.text,
                          ))
                    ])),
            SizedBox(height: 4),
            Padding(
                padding: EdgeInsets.only(left: 4, right: 8.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.ideographic,
                    children: [
                      Text(S.of(context).phone, style: TextStyle(fontSize: 16)),
                      Container(
                          width: MediaQuery.of(context).size.width - 120,
                          child: TextFormField(
                            decoration: kTextFieldDecoration,
                            style: TextStyle(fontSize: 16),
                            textAlignVertical: TextAlignVertical.center,
                            initialValue: user!.phone,
                            validator: (val) =>
                                !phoneIsValid(val!)
                                    ? "Invalid Phone"
                                    : null,
                            autovalidateMode: AutovalidateMode.always,
                            onChanged: (String value) => {
                              user!.phone = value,
                              analytics.logScreen((UserSettings).toString(),
                                  'User phone: ${value}'),
                              BlocProvider.of<UserBloc>(context)
                                  .add(UserUpdateEvent(user!))
                            },
                            keyboardType: TextInputType.phone,
                          ))
                    ])),
            SizedBox(height: 4),
            Padding(
                padding: EdgeInsets.only(left: 4, right: 8.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(S.of(context).email, style: TextStyle(fontSize: 16)),
                      Container(

                          width: MediaQuery.of(context).size.width - 120,
                          child: TextFormField(
                            decoration: kTextFieldDecoration,
                            style: TextStyle(fontSize: 16),

                            textAlignVertical: TextAlignVertical.center,
                            initialValue: user!.email.isNotEmptyAndNotNull ? user!.email : '',
                            validator: (val) =>
                                !isEmail(val!) ? 'Invalid email' : null,
                            autovalidateMode: AutovalidateMode.always,
                            onChanged: (String value) => {
                              user!.email = value,
                              analytics.logScreen((UserSettings).toString(),
                                  'User email: ${value}'),
                              BlocProvider.of<UserBloc>(context)
                                  .add(UserUpdateEvent(user!))
                            },
                            keyboardType: TextInputType.emailAddress,
                          ))
                    ]))
          ],
        );
         else return Text('Huh');
      },
    ));});
  }
}
