import 'package:flutter/material.dart';

class TextFieldDecoration extends InputDecoration{

  final Icon prefixIcon;
  final Icon suffixIcon;

  TextFieldDecoration(this.prefixIcon, this.suffixIcon) : super(
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
              width: 1, color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
              width: 1, color: Colors.grey),
        ),
        border: InputBorder.none
  );

}