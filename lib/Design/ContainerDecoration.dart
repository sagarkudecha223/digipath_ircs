import 'package:flutter/material.dart';

class ContainerDecoration extends BoxDecoration{

  final double radius;

  ContainerDecoration(this.radius):super(
    color: Colors.white,
    borderRadius: BorderRadius.circular(radius),
    border: Border.all(
        width: 1.5,
        color: Colors.grey
    ),
    // color: Colors.transparent,
    boxShadow: const [
      BoxShadow(
          color: Colors.grey,
          blurRadius: 4,
          blurStyle: BlurStyle.outer,
          spreadRadius: 0,
          offset: Offset(0, 0)
      ),
    ],
  );

}
