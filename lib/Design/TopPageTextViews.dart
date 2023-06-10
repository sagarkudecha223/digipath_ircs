import 'package:flutter/material.dart';

class TopPageTextViews extends Container{

  final String topText;
  final String bottomText;

  TopPageTextViews(this.topText,this.bottomText) : super(
    child: Column(
      children: [
        Text(topText.toUpperCase(), style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.indigo[900]),),
        Visibility(
          visible: bottomText != '',
          child: Padding(
            padding: const EdgeInsets.only(top: 2.0, bottom: 1),
            child: Text(bottomText,style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.indigo[900])),
          ),
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