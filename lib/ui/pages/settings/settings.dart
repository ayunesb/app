import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paradigm_mex/blocs/language/language_change_bloc.dart';
import 'package:paradigm_mex/blocs/user/user_settings_bloc.dart';
import 'package:paradigm_mex/generated/l10n.dart';
import 'package:paradigm_mex/service/general_services.dart';
import 'package:paradigm_mex/ui/pages/settings/laguage_settings.dart';
import 'package:paradigm_mex/ui/pages/settings/units_settings.dart';
import 'package:paradigm_mex/ui/pages/settings/user_settings.dart';

import '../../../blocs/currency/currency_change_bloc.dart';
import '../../../blocs/units/units_change_bloc.dart';
import '../../../models/user.dart';
import 'currency_settings.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageBloc, LanguageState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text(S.of(context).settings),
            titleTextStyle: TextStyle().copyWith(
                fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black),
            elevation: 0,
            backgroundColor: Colors.white,
          ),
          body: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Row(
                    children: [
                      Text(
                        S.of(context).language,
                        style: TextStyle(
                            color: Color(0xff5cb8b5),
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Scaffold(
                        backgroundColor: Colors.white,
                        appBar: AppBar(
                          iconTheme: IconThemeData(
                            color: Colors.black, //modify arrow color from here..
                          ),
                          title: Text(S.of(context).language),
                          titleTextStyle: TextStyle().copyWith(
                              fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black),
                          elevation: 0,
                          backgroundColor: Colors.white,
                        ),
                        body:LanguageSettings())),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          //                   <--- left side
                          color: Colors.grey,
                          width: 0.2,
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 20.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 16.0, right: 20),
                            child: Icon(CupertinoIcons.globe),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                S.of(context).preferred_language,
                                style: TextStyle()
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                              Text(GeneralServices.getLocale() == 'es'
                                  ? S.of(context).spanish
                                  : S.of(context).english)
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Row(
                    children: [
                      Text(
                        S.of(context).units,
                        style: TextStyle(
                            color: Color(0xff5cb8b5),
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const UnitsSettings()),
                    );
                  },
                  child: BlocBuilder<UnitsBloc, UnitsState>(
                      builder: (context, state) {
                    return Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            //                   <--- left side
                            color: Colors.grey,
                            width: 0.2,
                          ),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10.0, bottom: 20.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 16.0, right: 20),
                              child: Icon(CupertinoIcons.number_circle),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  S.of(context).units,
                                  style: TextStyle()
                                      .copyWith(fontWeight: FontWeight.bold),
                                ),
                                Text(GeneralServices.getUnits() == 'metric'
                                    ? S.of(context).metric
                                    : S.of(context).imperial)
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  }),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Row(
                    children: [
                      Text(
                        S.of(context).currency,
                        style: TextStyle(
                            color: Color(0xff5cb8b5),
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CurrencySettings()),
                    );
                  },
                  child: BlocBuilder<CurrencyBloc, CurrencyState>(
                      builder: (context, state) {
                    return Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            //                   <--- left side
                            color: Colors.grey,
                            width: 0.2,
                          ),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10.0, bottom: 20.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 16.0, right: 20),
                              child: Icon(CupertinoIcons.money_dollar_circle),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  S.of(context).currency,
                                  style: TextStyle()
                                      .copyWith(fontWeight: FontWeight.bold),
                                ),
                                Text(GeneralServices.getCurrency() == 'mxn'
                                    ? S.of(context).mxn
                                    : S.of(context).usd)
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  }),
                ),



                SizedBox(height: 10),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Scaffold(
                        backgroundColor: Colors.white,
                        appBar: AppBar(
                          iconTheme: IconThemeData(
                            color: Colors.black, //modify arrow color from here..
                          ),
                          title: Text(S.of(context).user),
                          titleTextStyle: TextStyle().copyWith(
                              fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black),
                          elevation: 0,
                          backgroundColor: Colors.white,
                        ),
                        body: UserSettings())




                      ),
                    );
                  },
                  child: BlocBuilder<UserBloc, UserState>(
                      builder: (context, state) {
                        User user = User();
                        if (state is UserLoadedSuccess) {
                          user = state.user;
                        } else if (state is UserUpdatedSuccess) {
                          user = state.user;
                        }
                        return Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                //                   <--- left side
                                color: Colors.grey,
                                width: 0.2,
                              ),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10.0, bottom: 20.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding:
                                  const EdgeInsets.only(left: 16.0, right: 20),
                                  child: Icon(CupertinoIcons.person_circle),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      S.of(context).user,
                                      style: TextStyle()
                                          .copyWith(fontWeight: FontWeight.bold),
                                    ),
                                    Text(user.name),
                                    Text(user.phone),
                                    Text(user.email)
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      }),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
