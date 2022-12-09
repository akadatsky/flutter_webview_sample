import 'package:flutter/material.dart';

class SimpleDivider extends StatelessWidget implements PreferredSizeWidget {
  const SimpleDivider(
    this.color, {
    this.height = 1,
    this.padding,
    this.key,
  }) : super(key: key);

  @override
  final Key? key;
  final Color color;
  final double height;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.only(),
      child: Container(
        height: height,
        color: color,
      ),
    );
  }

  @override
  Size get preferredSize => Size(double.infinity, height);
}
