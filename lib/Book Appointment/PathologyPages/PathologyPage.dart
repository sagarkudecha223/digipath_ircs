import 'package:digipath_ircs/Design/GlobalAppBar.dart';
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
      appBar: GlobalAppBar(context),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.indigo.shade100,
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
              decoration: ColorFillContainer(Colors.white),
              margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Column(
                children: [
                  RadioListTile(
                    title: Text("Home Collection",textScaleFactor: 1.0,style: TextStyle(fontSize: 16,color: Colors.indigo.shade800,fontWeight: FontWeight.w600),),
                    value: "Home Collection",
                    activeColor: Colors.red,
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
                    activeColor: Colors.red,
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
                      decoration: ColorFillContainer(Colors.green.shade500),
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
