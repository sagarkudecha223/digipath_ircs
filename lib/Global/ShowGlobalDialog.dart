import 'dart:ui';
import 'package:flutter/material.dart';

Future<void> showGlobalDialog(BuildContext context, child,bool dismissible){
   return showDialog<void>(
     context: context,
     barrierDismissible: dismissible,
     builder: ( BuildContext context ){
       return TweenAnimationBuilder(
         tween: Tween<double>(begin: 0, end: 1),
         duration: const Duration(milliseconds: 500),
         builder: (BuildContext context, double value, Widget? child) {
           return Opacity(opacity: value,
             child: Padding(
               padding: EdgeInsets.only(top: value * 5),
               child: child,
             ),
           );
         },
         child: BackdropFilter(
           filter: ImageFilter.blur(sigmaX: 7.0, sigmaY: 7.0),
           child: Container(
             margin: const EdgeInsets.all(10),
             child: Dialog(
               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
               insetPadding: const EdgeInsets.all(20),
               elevation: 16,
               child: child
             ),
           ),
         ),
       );
     }
   );
}