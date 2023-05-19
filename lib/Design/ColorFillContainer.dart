import 'package:flutter/cupertino.dart';

class ColorFillContainer extends BoxDecoration{
  final Color color;

  ColorFillContainer(this.color) : super(
    borderRadius: BorderRadius.circular(10),
    color: color
  );

}