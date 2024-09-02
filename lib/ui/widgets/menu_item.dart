import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class MenuItem extends StatefulWidget {
  final String title;
  final Widget? child;
  final bool divider;
  final bool topDivider;
  final Widget? suffix;
  final VoidCallback onPressed;
  final bool selected;

  const MenuItem({
    this.title = "",
    this.child,
    this.divider = true,
    this.topDivider = false,
    this.suffix,
    required this.onPressed,
    this.selected = false,
    Key? key,
  }) : super(key: key);

  @override
  _MenuItem createState() => _MenuItem(this.title, this.child, this.divider,
      this.topDivider, this.suffix, this.onPressed, this.selected, this.key);
}

class _MenuItem extends State<MenuItem> {
  final String title;
  final Widget? child;
  final bool divider;
  final bool topDivider;
  final Widget? suffix;
  final VoidCallback onPressed;
  final bool selected;

  final Color highlightColor = Color.fromRGBO(100, 100, 100, .5);

  _MenuItem(
    this.title,
    this.child,
    this.divider,
    this.topDivider,
    this.suffix,
    this.onPressed,
    this.selected,
    Key? key,
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return VStack(
      [
        //
        topDivider
            ? const Divider(
                height: 1,
                thickness: 2,
              )
            : const SizedBox.shrink(),

        //
        Container(
            color: this.selected ? Colors.grey : Colors.white,
            child: HStack(
              [
                //
                (child ?? title.text.lg.light.make()).expand(),
                suffix ??
                    const Icon(
                      Icons.chevron_right,
                      size: 16,
                    ),
                //
              ],
            ).py12().px8()),

        //
        divider
            ? const Divider(
                height: 1,
                thickness: 2,
              )
            : const SizedBox.shrink(),
      ],
    ).onInkTap(onPressed);
  }
}
