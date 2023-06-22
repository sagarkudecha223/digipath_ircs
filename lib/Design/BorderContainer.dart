import 'package:flutter/cupertino.dart';

class BorderContainer extends BoxDecoration{
  final Color inColor;
  final Color borderColor;

  BorderContainer(this.inColor, this.borderColor) : super(
      borderRadius: BorderRadius.circular(12),
      color: inColor,
      border: Border.all(
          width: 1.5,
          color: borderColor
      ),
  );

}