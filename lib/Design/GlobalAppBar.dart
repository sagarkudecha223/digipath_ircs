import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import '../HomePage.dart';

class GlobalAppBar extends AppBar{

  GlobalAppBar(BuildContext context) : super(
      elevation: 0.0,
      backgroundColor: Colors.indigo[100],
      leading: InkWell(
        onTap: (){
          Navigator.pop(context);
        },
          child: Icon(Icons.arrow_back_rounded,color: Colors.indigo[900])),
      actions: [
        IconButton(
          icon: Icon(
            Icons.home,
            color: Colors.indigo[900],
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