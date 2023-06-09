import 'package:digipath_ircs/Design/GlobalAppBar.dart';
import 'package:digipath_ircs/Design/TopPageTextViews.dart';
import 'package:digipath_ircs/Global/Colors.dart';
import 'package:digipath_ircs/Global/global.dart';
import 'package:flutter/material.dart';
import '../../Design/ColorFillContainer.dart';
import '../../ModalClass/PathologyServiceModal.dart';
import 'PackagesPage.dart';

class EditPackagesPage extends StatefulWidget {
  const EditPackagesPage({Key? key}) : super(key: key);

  @override
  State<EditPackagesPage> createState() => _EditPackagesPageState();
}

class _EditPackagesPageState extends State<EditPackagesPage> {

  @override
  void initState() {
    super.initState();
    trueServiceList = [];
    finalSelectedPackageList.forEach((val){
      trueServiceList.add(PathologyServiceModal(amount: val.amount, name: val.name, id: val.id, servicemapid: val.servicemapid, isSelected: val.isSelected, isPackage: val.isPackage));
    });
  }

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.blue;
    }
    return Colors.blue;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GlobalAppBar(context, 'Pathology Packages'),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.indigo.shade100,
        child: Column(
          children: [
            TopPageTextViews('Edit Pathology Packages'),
            Flexible(
              child: Container(
                margin: EdgeInsets.only(left: 20,right: 20,bottom: 10,top: 5),
                padding: EdgeInsets.all(10),
                decoration: ColorFillContainer(Colors.white),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      PackagesPage(),
                      SizedBox(height: 5,),
                      InkWell(
                        onTap: (){
                          List<PathologyServiceModal> updatedItemList;
                          updatedItemList=[];
                          trueServiceList.forEach((val){
                            updatedItemList.add(PathologyServiceModal(amount: val.amount, name: val.name, id: val.id, servicemapid: val.servicemapid, isSelected: val.isSelected, isPackage: val.isPackage));
                          });
                          Navigator.pop(context,updatedItemList);
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
                )
              ),
            ),
          ],
        ),
      ),
    );
  }
}
