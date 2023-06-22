import 'package:digipath_ircs/Design/BorderContainer.dart';
import 'package:digipath_ircs/Design/GlobalAppBar.dart';
import 'package:digipath_ircs/Global/Colors.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import '../../Design/ColorFillContainer.dart';
import '../../Global/global.dart';
import 'PathologyService&PackagePage.dart';

class PathologyPage extends StatefulWidget {
  const PathologyPage({Key? key}) : super(key: key);

  @override
  State<PathologyPage> createState() => _PathologyPageState();
}

class _PathologyPageState extends State<PathologyPage> {

  @override
  void initState() {
    super.initState();

    collectionType = 'Home Collection';
    selectedServiceList.clear();
    finalSelectedPackageList.clear();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GlobalAppBar(context,'visit type'),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: globalPageBackgroundColor,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
              padding: EdgeInsets.all(20),
              decoration: const BoxDecoration(
                  image:DecorationImage(image : AssetImage('assets/images/book_test_screen2.png'),
              fit: BoxFit.fitHeight),
              ),
              height: MediaQuery.of(context).size.height*0.40,
            ),
            Container(
              decoration: BorderContainer(Colors.white,globalBlue),
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Column(
                children: [
                  RadioListTile(
                    title: Text("Home Collection",textScaleFactor: 1.0,style: TextStyle(fontSize: 16,color: Colors.indigo.shade800,fontWeight: FontWeight.w600),),
                    value: "Home Collection",
                    activeColor: globalBlue,
                    groupValue: collectionType,
                    onChanged: (value){
                      setState(() {
                        collectionType = value.toString();
                      });
                    },
                  ),
                  RadioListTile(
                    title: Text("Center Visit",textScaleFactor: 1.0 ,style: TextStyle(fontSize: 16,color: Colors.indigo.shade800,fontWeight: FontWeight.w600),),
                    value: "Center Visit",
                    groupValue: collectionType,
                    activeColor: globalBlue,
                    onChanged: (value){
                      setState(() {
                        collectionType = value.toString();
                      });
                    },
                  ),
                  InkWell(
                    onTap: (){
                      Get.to(PathologyServicePage());
                    },
                    child: Container(
                      width: double.infinity,
                      margin: EdgeInsets.all(15),
                      padding: EdgeInsets.all(5),
                      decoration: ColorFillContainer(globalOrange),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('NEXT',textAlign: TextAlign.center,style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700),),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
