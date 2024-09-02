import 'package:flag/flag_enum.dart';
import 'package:flag/flag_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paradigm_mex/blocs/language/language_change_bloc.dart';
import 'package:paradigm_mex/generated/l10n.dart';
import 'package:paradigm_mex/service/general_services.dart';

class LanguageSettings extends StatefulWidget {
  const LanguageSettings({Key? key}) : super(key: key);

  @override
  _LanguageSettingsState createState() => _LanguageSettingsState();
}

class _LanguageSettingsState extends State<LanguageSettings> {
  LanguageOptions? _language = GeneralServices.getLocale() == "es"
      ? LanguageOptions.spanish
      : LanguageOptions.english;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: BlocBuilder<LanguageBloc, LanguageState>(
          builder: (context, state) {
            return Card(child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RadioListTile<LanguageOptions>(
                  controlAffinity: ListTileControlAffinity.trailing,
                  title: Row(children: [
                    Flag.fromCode(FlagsCode.US, height: 24, width: 24),
                    SizedBox(width: 8.0),
                    Text(S.of(context).english),
                  ]),
                  value: LanguageOptions.english,
                  groupValue: _language,
                  onChanged: (LanguageOptions? value) {
                    BlocProvider.of<LanguageBloc>(context)
                        .add(LanguageSelected(language: value));
                    _changeLanguage(value);
                  },
                  activeColor: Color(0xff5cb8b5),
                ),
                RadioListTile<LanguageOptions>(
                  controlAffinity: ListTileControlAffinity.trailing,
                  title: Row(children: [
                    Flag.fromCode(FlagsCode.MX, height: 24, width: 24),
                    SizedBox(width: 8.0),
                    Text(S.of(context).spanish),
                  ]),
                  value: LanguageOptions.spanish,
                  activeColor: Color(0xff5cb8b5),
                  groupValue: _language,
                  onChanged: (LanguageOptions? value) {
                    BlocProvider.of<LanguageBloc>(context)
                        .add(LanguageSelected(language: value));
                    _changeLanguage(value);
                  },

                ),
              ],
            ));
          },
        ));
  }

  void _changeLanguage(LanguageOptions? value) {
    setState(() {
      S.load(Locale(value == LanguageOptions.spanish ? 'es' : 'en'));
      GeneralServices.setLocale(value == LanguageOptions.spanish ? 'es' : 'en');
      _language = value;
    });
  }
}
