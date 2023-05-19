import 'package:flutter/material.dart';

class EditTextBorder extends InputDecoration{

  final String hintText;
  late Icon icon;

  EditTextBorder(this.hintText, this.icon) : super(
    filled: true,
    fillColor: Colors.white60,
    prefixIcon: icon,
    hintText: hintText,
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(
        color: Colors.grey,
        width: 1,
      ),
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(
          color: Colors.grey
      ),
    )
  );

}