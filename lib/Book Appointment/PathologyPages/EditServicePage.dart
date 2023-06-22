import 'package:digipath_ircs/Design/GlobalAppBar.dart';
import 'package:digipath_ircs/Design/TopPageTextViews.dart';
import 'package:digipath_ircs/Global/Colors.dart';
import 'package:flutter/material.dart';
import '../../Design/BorderContainer.dart';
import '../../Design/ColorFillContainer.dart';
import '../../Global/global.dart';
import 'ServicePage.dart';

class EditServicePage extends StatefulWidget {
  const EditServicePage({Key? key}) : super(key: key);

  @override
  State<EditServicePage> createState() => _EditServicePageState();
}

class _EditServicePageState extends State<EditServicePage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GlobalAppBar(context, 'Pathology Services'),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: globalPageBackgroundColor,
        child: Column(
          children: [
            TopPageTextViews('Edit Pathology Services'),
            Flexible(
              child: Container(
                margin: EdgeInsets.only(left: 20,right: 20,bottom: 10,top: 5),
                padding: EdgeInsets.all(10),
                decoration: BorderContainer(Colors.white,globalBlue),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const ServicePage(),
                      SizedBox(height: 5),
                      InkWell(
                        onTap: (){
                           Navigator.pop(context,selectedServiceList);
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 20,bottom: 10),
                          width: double.infinity,
                          decoration: ColorFillContainer(globalOrange),
                          child: const Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text('OK',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500),textAlign: TextAlign.center,),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
