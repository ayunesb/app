import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paradigm_mex/ui/widgets/menu_item.dart' as MenuTools;
import 'package:velocity_x/velocity_x.dart';

import '../../blocs/reports/contact_report_bloc.dart';
import '../../blocs/terms_and_conditions/terms_settings_bloc.dart';
import '../../blocs/user/user_settings_bloc.dart';
import '../../generated/l10n.dart';
import '../../models/contact_report.dart';
import '../../models/user.dart';
import '../../service/general_services.dart';
import '../pages/settings/laguage_settings.dart';
import '../pages/settings/terms_settings.dart';
import '../pages/settings/user_settings.dart';
import 'package:validators/validators.dart';

class AppLanguageSelector extends StatelessWidget {
  AppLanguageSelector({Key? key}) : super(key: key);

  final Function(String) onSelected = (code) async {
    S.load(Locale(code));
    GeneralServices.setLocale(code);
  };
  bool phoneIsValid(String phone) {
    return RegExp(
            r"^\s*(?:\+\d\d?\d?)?\s*(?:\(\d\d?\d?\))?\s*[\d\s-]{5,12}\s*$")
        .hasMatch(phone);
  }


  _reportContact(context, User user) async {
    ContactReport report = ContactReport();
    report.action = 'user';
    report.date = DateTime.now();
    report.adId = '';
    report.phone = user.phone;
    report.email = user.email;
    report.userName = user.name;


    BlocProvider.of<ContactReportBloc>(context)
        .add(ContactReportAddEvent(contactReport: report));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LanguageSettings(),
          SizedBox(height: 8),
          UserSettings(),
          SizedBox(height: 8),
          TermsSettings(),
          SizedBox(height: 8),
          SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 48,
              child:
                  BlocBuilder<UserBloc, UserState>(builder: (context, state) {
                User user = User();
                if (state is UserLoadedSuccess) {
                  user = state.user;
                } else if (state is UserUpdatedSuccess) {
                  user = state.user;
                }
                return BlocBuilder<TermsBloc, TermsState>(
                    builder: (context, state) {
                  bool accepted = false;
                  if (state is TermsLoadedSuccess) {
                    accepted = state.accepted;
                  } else if (state is TermsUpdatedSuccess) {
                    accepted = state.accepted;
                  }
                  return ElevatedButton(
                    onPressed: (
                        user.name.isEmptyOrNull ||
                            (user.phone.isEmptyOrNull ||
                                !phoneIsValid(user.phone)) ||
                            (user.email.isEmptyOrNull ||
                                !isEmail(user.email)) ||
                            GeneralServices.getLocale().isEmptyOrNull ||
                            !accepted)
                        ? null
                        : () {
                            _reportContact(context, user);
                            GeneralServices.firstTimeCompleted();
                            context.pop();
                          },
                    child: Text(S.of(context).continue_title),
                  );
                });
              }))
        ],
      ).scrollVertical(),
    ));
  }
}
