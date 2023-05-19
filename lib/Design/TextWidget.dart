import 'package:flutter/material.dart';

class TextWidget extends Text{

  final String text;
  final double size ;
  final FontWeight fontWeight;
  final Color textColor;

  TextWidget( this.text, this.size, this.fontWeight,this.textColor) : super(
      text,
      textScaleFactor: 1.0,
      style: TextStyle(
        color: textColor,
        fontSize: size,
        fontWeight: fontWeight
      )
  );
}