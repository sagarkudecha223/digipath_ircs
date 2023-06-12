import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import '../HomePage.dart';

class GlobalAppBar extends AppBar{

  final String titleText;

  GlobalAppBar(BuildContext context, this.titleText) : super(
    elevation: 0.0,
    backgroundColor: const Color(0xFF254D99),
    leading: InkWell(
        onTap: (){
          FocusManager.instance.primaryFocus?.unfocus();
          Navigator.pop(context);
        },
        child: const Icon(Icons.arrow_back_rounded,color: Colors.white)
    ),
    title: Text(titleText.toUpperCase()),
    centerTitle: true,
    titleTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
    actions: [
      IconButton(
        icon: const Icon(
          Icons.home,
          color: Colors.white,
        ),
        onPressed: () {
          Get.offAll(
            HomePage(),
          );
        },
      )
    ],
 );
}