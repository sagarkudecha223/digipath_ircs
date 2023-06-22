import 'package:digipath_ircs/Global/Colors.dart';
import 'package:flutter/material.dart';

class TopPageTextViews extends Container{

  final String bottomText;

  TopPageTextViews(this.bottomText) : super(
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
          child: Text(bottomText.toUpperCase(),style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: globalBlue,letterSpacing: 0.5)),
        )
      ],
    )
  );
}

class PageMainContainterDecoration extends BoxDecoration{

  PageMainContainterDecoration() : super(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15)
  );

}