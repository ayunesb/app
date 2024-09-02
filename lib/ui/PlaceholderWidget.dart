import 'package:flutter/material.dart';

class PlaceholderWidget extends StatelessWidget {
  final int page;

  const PlaceholderWidget(this.page, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Text("Page $page")
      ),
    );
  }
}
