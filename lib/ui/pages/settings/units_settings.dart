import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paradigm_mex/blocs/units/units_change_bloc.dart';
import 'package:paradigm_mex/generated/l10n.dart';
import 'package:paradigm_mex/service/general_services.dart';

class UnitsSettings extends StatefulWidget {
  const UnitsSettings({Key? key}) : super(key: key);

  @override
  _UnitsSettingsState createState() => _UnitsSettingsState();
}

class _UnitsSettingsState extends State<UnitsSettings> {
  UnitsOptions? _units = GeneralServices.getUnits() == "metric"
      ? UnitsOptions.metric
      : UnitsOptions.imperial;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black, //modify arrow color from here..
          ),
          title: Text(S.of(context).units),
          titleTextStyle: TextStyle().copyWith(
              fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black),
          elevation: 0,
          backgroundColor: Colors.white,
        ),
        body: BlocBuilder<UnitsBloc, UnitsState>(
          builder: (context, state) {
            return Column(
              children: <Widget>[
                RadioListTile<UnitsOptions>(
                  controlAffinity: ListTileControlAffinity.trailing,
                  title: Text(S.of(context).metric),
                  value: UnitsOptions.metric,
                  groupValue: _units,
                  onChanged: (UnitsOptions? value) {
                    BlocProvider.of<UnitsBloc>(context)
                        .add(UnitsSelected(units: value));
                    _changeUnits(value);
                  },
                  activeColor: Color(0xff5cb8b5),
                ),
                RadioListTile<UnitsOptions>(
                  controlAffinity: ListTileControlAffinity.trailing,
                  title: Text(S.of(context).imperial),
                  value: UnitsOptions.imperial,
                  activeColor: Color(0xff5cb8b5),
                  groupValue: _units,
                  onChanged: (UnitsOptions? value) {
                    BlocProvider.of<UnitsBloc>(context)
                        .add(UnitsSelected(units: value));
                    _changeUnits(value);
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

  void _changeUnits(UnitsOptions? value) {
    setState(() {
      GeneralServices.setUnits(
          value == UnitsOptions.metric ? 'metric' : 'imperial');
      _units = value;
    });
  }
}
