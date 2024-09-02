import 'package:flutter/material.dart';

class TitleAccordionWidget extends StatefulWidget {
  final Widget contain;
  final String title;
  final bool expanded;

  TitleAccordionWidget(
      {required this.contain, required this.title, this.expanded = true});

  @override
  _TitleAccordionState createState() => _TitleAccordionState(
      contain: this.contain, title: this.title, expanded: this.expanded);
}

class _TitleAccordionState extends State<TitleAccordionWidget> {
  final bool expanded;
  final Widget contain;
  final String title;

  _TitleAccordionState(
      {required this.contain, required this.title, this.expanded = true});

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
        initiallyExpanded: this.expanded,
        childrenPadding: EdgeInsets.only(left: 0),
        title: Transform.translate(
          offset: Offset(-14, 0),
          child: Text(this.title,
              style: TextStyle(
                  fontSize: 13,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.bold)),
        ),
        children: <Widget>[
          ListTile(
              visualDensity: VisualDensity.compact,
              title: Transform.translate(
                  offset: Offset(-14, 0), child: this.contain))
        ]);
  }
}
