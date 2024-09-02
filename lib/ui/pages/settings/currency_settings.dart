import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paradigm_mex/generated/l10n.dart';
import 'package:paradigm_mex/service/general_services.dart';

import '../../../blocs/currency/currency_change_bloc.dart';

class CurrencySettings extends StatefulWidget {
  const CurrencySettings({Key? key}) : super(key: key);

  @override
  _currencySettingsState createState() => _currencySettingsState();
}

class _currencySettingsState extends State<CurrencySettings> {
  CurrencyOptions? _currency = GeneralServices.getCurrency() == "mxn"
      ? CurrencyOptions.mxn
      : CurrencyOptions.usd;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black, //modify arrow color from here..
          ),
          title: Text(S.of(context).currency),
          titleTextStyle: TextStyle().copyWith(
              fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black),
          elevation: 0,
          backgroundColor: Colors.white,
        ),
        body: BlocBuilder<CurrencyBloc, CurrencyState>(
          builder: (context, state) {
            return Column(
              children: <Widget>[
                RadioListTile<CurrencyOptions>(
                  controlAffinity: ListTileControlAffinity.trailing,
                  title: Text(S.of(context).mxn),
                  value: CurrencyOptions.mxn,
                  groupValue: _currency,
                  onChanged: (CurrencyOptions? value) {
                    BlocProvider.of<CurrencyBloc>(context)
                        .add(CurrencySelected(currency: value));
                    _changeCurrency(value);
                  },
                  activeColor: Color(0xff5cb8b5),
                ),
                RadioListTile<CurrencyOptions>(
                  controlAffinity: ListTileControlAffinity.trailing,
                  title: Text(S.of(context).usd),
                  value: CurrencyOptions.usd,
                  activeColor: Color(0xff5cb8b5),
                  groupValue: _currency,
                  onChanged: (CurrencyOptions? value) {
                    BlocProvider.of<CurrencyBloc>(context)
                        .add(CurrencySelected(currency: value));
                    _changeCurrency(value);
                  },
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.grey, width: 0.5),
                  ),
                ),
              ],
            );
          },
        ));
  }

  void _changeCurrency(CurrencyOptions? value) {
    setState(() {
      GeneralServices.setCurrency(value == CurrencyOptions.mxn ? 'mxn' : 'usd');
      _currency = value;
    });
  }
}
