import 'package:digipath_ircs/Design/ColorFillContainer.dart';
import 'package:digipath_ircs/Design/GlobalAppBar.dart';
import 'package:digipath_ircs/Global/Colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/route_manager.dart';
import '../../Design/TopPageTextViews.dart';
import '../../Global/SearchAPI.dart';
import '../../Global/Toast.dart';
import '../../Global/global.dart';
import '../../ModalClass/PathologyPackageModal.dart';
import '../../ModalClass/PathologyServiceModal.dart';
import 'FixTimeSlotPage.dart';
import 'PackagesPage.dart';
import 'ServicePage.dart';

class PathologyServicePage extends StatefulWidget {
  const PathologyServicePage({Key? key}) : super(key: key);

  @override
  State<PathologyServicePage> createState() => _PathologyServicePageState();
}

class _PathologyServicePageState extends State<PathologyServicePage> {

  bool addPckage = false;

  @override
  void initState() {
    super.initState();
    EasyLoading.show(status: 'Loading...');
    getServiceList();
  }

  void getServiceList() async{

    trueServiceList.clear();
    serviceList.clear();

    dynamic status = await searchAPI(false ,'$urlForIN/getServiceListWithPriceByServiceCategoryForAndroid.do?serviceCategoryID=9&careProviderID=4286',
        {},{}, 35);

    print(' status after responce: $status');

    if(status.toString() != 'Sorry !!! Server Error' && status.toString().isNotEmpty && status.toString() != 'Sorry !!!  Connectivity issue! Try again'){
      String statusinfo = status['Status'].toString();
      if (statusinfo == "Ok") {

        List<dynamic> serviceListStastus = status['ServiceList'];
        for(int i=0; i<serviceListStastus.length; i++){

          int amount = serviceListStastus[i]['amount'];
          String name = serviceListStastus[i]['name'].toString();
          String id = serviceListStastus[i]['id'].toString();
          String servicemapid = serviceListStastus[i]['servicemapid'].toString();
          String isSelected = serviceListStastus[i]['isSelected'].toString();
          String isPackage = serviceListStastus[i]['isPackage'].toString();

          if(isPackage == 'false'){
            serviceList.add(PathologyServiceModal(amount: amount, name: name, id: id, servicemapid: servicemapid, isSelected: isSelected, isPackage: isPackage,));
          }else{
            trueServiceList.add(PathologyServiceModal(amount: amount, name: name, id: id, servicemapid: servicemapid, isSelected: isSelected, isPackage: isPackage,));
          }

        }

         setState(() {
           getPackageList();
          });
      }
      else{

      }
    }
    else if(status.toString() == 'Sorry !!!  Connectivity issue! Try again'){
      showToast('Sorry !!!  Poor Internet Connectivity ! Try again');
      // getServiceList();
    }
    else{
      if(mounted){
        showToast('Sorry !!! Server Error');
      }
    }
  }

  void getPackageList() async {

    totalPackageList.clear();

    List<dynamic> status = await searchAPI(false ,'$urlForIN/getAllPackageServiceFacilityList.do?careProviderID=4286',
        {},{}, 35);

    print(' status after responce: $status');
    EasyLoading.dismiss();

    if(status.toString() != 'Sorry !!! Server Error' && status.toString().isNotEmpty && status.toString() != 'Sorry !!!  Connectivity issue! Try again'){

      for(int i=0; i<status.length; i++){

        String packageIDP = status[i]['packageIDP'].toString();
        String packageName = status[i]['packageName'].toString();
        String packageType = status[i]['packageType'].toString();
        String serviceIDF = status[i]['serviceIDF'].toString();
        String serviceName = status[i]['serviceName'].toString();
        String facilityName = status[i]['facilityName'].toString();
        String serviceDisplayName = status[i]['serviceDisplayName'].toString();
        String facilitys = status[i]['facilitys'].toString();
        String id = status[i]['id'].toString();
        String amount = status[i]['amount'].toString();

        totalPackageList.add(PathologyPackageModal(packageIDP: packageIDP, packageName: packageName, packageType: packageType, serviceIDF: serviceIDF, serviceName: serviceName,
            facilityName: facilityName, serviceDisplayName: serviceDisplayName, facilitys: facilitys, id: id, amount: amount));

      }

      setState(() {

      });
    }
  }

  @override
  void dispose() {
    EasyLoading.dismiss();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GlobalAppBar(context,'Service & package'),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.indigo.shade100,
        child: Column(
          children: [
            TopPageTextViews('Select service & package here'),
            Expanded(
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                padding: const EdgeInsets.all(15),
                decoration: ColorFillContainer(Colors.white),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap : () async{
                              addPckage = false;
                              for(int i=0; i<trueServiceList.length; i++){
                                if(trueServiceList[i].isSelected == 'true'){
                                  addPckage = true;
                                }
                              }
                              if(selectedServiceList.isEmpty && addPckage == false){
                                showToast('Please Select Service or package');
                              }
                              else{
                                await Get.to(const FixTimeSlotPage());
                                setState(() {
                                });
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.only(left: 10,right: 10,top: 5,bottom: 5),
                              decoration: ColorFillContainer(globalOrange),
                              child: Row(
                                children: const [
                                  Text('NEXT',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500),),
                                  Icon(Icons.navigate_next_rounded,color: Colors.white,),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                      ServicePage(),
                      SizedBox(height: 5,),
                      PackagesPage(),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
