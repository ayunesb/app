import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paradigm_mex/generated/l10n.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../blocs/language/language_change_bloc.dart';
import '../../../blocs/terms_and_conditions/terms_settings_bloc.dart';

class TermsSettings extends StatefulWidget {
  const TermsSettings({Key? key}) : super(key: key);

  @override
  _TermsSettingsState createState() => _TermsSettingsState();
}

class _TermsSettingsState extends State<TermsSettings> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageBloc, LanguageState>(builder: (context, state) {
      return BlocBuilder<TermsBloc, TermsState>(builder: (context, state) {
        bool accepted = false;
        if (state is TermsLoadedSuccess) {
          accepted = state.accepted;
        } else if (state is TermsUpdatedSuccess) {
          accepted = state.accepted;
        }
        return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
        Padding(
        padding: EdgeInsets.only(left: 4),
        child: Text(S.of(context).terms_settings_title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
              Padding(
                  padding: EdgeInsets.only(left: 0, right: 8.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Checkbox(
                          splashRadius: 15,
                          visualDensity: VisualDensity.compact,
                          value: accepted,
                          onChanged: (bool? value) {
                            setState(() {
                              BlocProvider.of<TermsBloc>(context)
                                  .add(TermsUpdateEvent(value!));
                            });
                          },
                        ),
                        Container(
                            width: MediaQuery.of(context).size.width - 120,
                            child: RichText(
                                text: TextSpan(children: [
                              TextSpan(
                                text: S.of(context).terms_pre_msg + ' ',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.black87),
                              ),
                              TextSpan(
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.blueAccent,
                                      decoration: TextDecoration.underline),
                                  text: S.of(context).terms_post_msg,
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () async {
                                      Uri url = Uri.parse(
                                          "https://paradigm-mx-development.web.app/privacy.html");
                                      if (await canLaunchUrl(url)) {
                                        await launchUrl(url);
                                      } else {
                                        throw 'Could not launch $url';
                                      }
                                    }),
                            ])))
                      ]))
            ]);
      });
    });
  }
}
