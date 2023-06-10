import 'package:badges/badges.dart';
import 'package:digipath_ircs/Design/GlobalAppBar.dart';
import 'package:digipath_ircs/Global/Toast.dart';
import 'package:digipath_ircs/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/route_manager.dart';
import '../../Design/ColorFillContainer.dart';
import '../../Design/ContainerDecoration.dart';
import '../../Global/SearchAPI.dart';
import '../../Global/global.dart';
import '../../ModalClass/PathologyServiceModal.dart';
import 'EditPackagesPage.dart';
import 'EditServicePage.dart';
import 'WebViewPage.dart';

class ConfirmTimeSlotPage extends StatefulWidget {

  final String startTime;
  final String endTime;
  final String current_date;

   ConfirmTimeSlotPage({Key? key, required this.startTime, required this.endTime,required this.current_date}) : super(key: key);

  @override
  State<ConfirmTimeSlotPage> createState() => _ConfirmTimeSlotPageState(startTime,endTime,current_date);
}

class _ConfirmTimeSlotPageState extends State<ConfirmTimeSlotPage> {

  late String startTime;
  late String endTime;
  late String current_date;

  _ConfirmTimeSlotPageState( this.startTime,this.endTime,this.current_date);

  bool addPckage = false;
  int totalCost = 0;
  String paymentText ='Pay Online';
  List<PathologyServiceModal> tempPackageList = <PathologyServiceModal>[];
  List<PathologyServiceModal> tempServiceList = <PathologyServiceModal>[];

  @override
  void initState() {
     super.initState();
     finalSelectedPackageList = [];
     trueServiceList.forEach((val){
       finalSelectedPackageList.add(PathologyServiceModal(amount: val.amount, name: val.name, id: val.id, servicemapid: val.servicemapid, isSelected: val.isSelected, isPackage: val.isPackage));
     });
     checkCost();
  }

  void checkCost(){

    for(int i=0; i<finalSelectedPackageList.length; i++){
      if(finalSelectedPackageList[i].isSelected == 'true'){
        addPckage = true;
      }
    }

    totalCost = 0;
    for(int i=0; i< selectedServiceList.length; i++){
      totalCost = totalCost  + selectedServiceList[i].amount;
    }

    for(int i=0; i<finalSelectedPackageList.length; i++){
      if(finalSelectedPackageList[i].isSelected == 'true'){
       totalCost = totalCost + finalSelectedPackageList[i].amount;
      }
    }

    setState(() {
      print('Total Cost is :: $totalCost');
    });

  }

  void submitData() async{

    EasyLoading.show(status: 'Loading...');
    List finalserviceList = [];

    for(int i=0; i< selectedServiceList.length; i++){
      finalserviceList.add(selectedServiceList[i].id);
    }

    for(int i=0; i<finalSelectedPackageList.length; i++){
      if(finalSelectedPackageList[i].isSelected == 'true'){
        finalserviceList.add(finalSelectedPackageList[i].id);
      }
    }

    String demo = finalserviceList.toString();
    String removedBrackets = demo.substring(1, demo.length - 1);
    removedBrackets =  removedBrackets.replaceAll(' ', '');
    print(removedBrackets);

    late int collectionInt;

    if(collectionType == 'Home Collection'){
      collectionInt = 1;
    }
    else{
      collectionInt = 2;
    }

    late String slotStartTime;
    late String slotEndTime;
    late String collectionTime = current_date;

    if(startTime.contains('PM')){
      slotStartTime = startTime.replaceAll('PM', 'P.M.');
    }else {
      slotStartTime = startTime.replaceAll('AM', 'A.M.');
    }
    print('Start Date...$slotStartTime');

    if(endTime.contains('PM')){
      slotEndTime = endTime.replaceAll('PM', 'P.M.');
    }else {
      slotEndTime = endTime.replaceAll('AM', 'A.M.');
    }
    print('Start Date...$slotEndTime');

    dynamic status = await searchAPI(true ,'$urlForIN/insertAllInOnePathologyRegistrationForAndroid.do?patientProfileIDF&citizenIDF=$localCitizenIDP&'
        'CareProviderIDP=$careProviderID&UserLoginIDP=$localUserLoginIDP&ReferenceDoctorIDP&TreatingDoctorIDP=$TreatingDoctorIDP&Remarks&'
        'serviceIDP=$removedBrackets&collectionType=$collectionInt&slotStartTime=$slotStartTime&slotEndTime=$slotEndTime&collectionTime=$collectionTime',
        {},{}, 35);

      print(' status after responce: $status');
      EasyLoading.dismiss();

      if(status.toString() != 'Sorry !!! Server Error' && status.toString().isNotEmpty && status.toString() != 'Sorry !!!  Connectivity issue! Try again'){

        String satusInfo = status['status'].toString();
        if(satusInfo == 'true'){

          String encounterID = status['encounterID'].toString();
          String generateVoucher = status['generateVoucher'].toString();

          if(generateVoucher == 'false'){
            if(paymentText == 'Pay At Visit'){
              showToast('Test Booked Successfully');
              Get.offAll(HomePage());
            }
            else{
              String url = 'https://medicodb.in/CCAvenuePopUp_Android.do?encounterid=$encounterID&callFrom=android&APIFor=redcross&mobileNo=$localMobileNum';
              print( 'url is :::: $url ');
              Get.to(WebViewPage(url: url));
            }
          }
          else if(generateVoucher == 'true'){
            showToast('Test Booked Successfully');
            Get.offAll(HomePage());
          }
        }else{
          showToast('Sorry !!! Please Try Again...');
        }

      }

  }

  Text firstText(String text1) {
    return Text(text1,style:  TextStyle(color: Colors.grey.shade700,fontWeight: FontWeight.bold,fontSize: 12),);
  }

  Text secondText(String text1) {
    return Text(text1, style:  TextStyle(color: Colors.blue.shade900,fontWeight: FontWeight.bold,fontSize: 15));
  }

  Text mainText(String text1) {
    return Text(text1, style:  TextStyle(color: Colors.grey.shade800,fontWeight: FontWeight.w600,fontSize: 14));
  }

  Padding divider(){
    return const Padding(
      padding: EdgeInsets.only(top: 8.0,bottom: 8.0),
      child: Divider(
        thickness: 0.5,
        color: Colors.grey,
        ),
    );
  }

  @override
  void dispose() {
    EasyLoading.dismiss();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GlobalAppBar(context),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.indigo.shade100,
        child: Container(
          padding: const EdgeInsets.only(bottom: 10,top: 10,right: 20,left: 20),
          margin: const EdgeInsets.only(bottom: 10,top: 5,right: 20,left: 20),
          decoration: ContainerDecoration(15),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    firstText(' VISIT TYPE :'),
                    InkWell(
                      onTap: (){
                           showDialog<String>(
                            context: context,
                            builder: (context) =>TweenAnimationBuilder(
                              tween: Tween<double>(begin: 0, end: 1),
                              duration: Duration(milliseconds: 500),
                              builder: (BuildContext context, double value, Widget? child) {
                                return Opacity(opacity: value,
                                  child: Padding(
                                    padding: EdgeInsets.only(top: value * 1),
                                    child: child,
                                  ),
                                );
                              },
                              child: Dialog(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                insetPadding: EdgeInsets.all(30),
                                elevation: 16,
                                child: Container(
                                  decoration: ColorFillContainer(Colors.white.withOpacity(0.8)),
                                  margin: EdgeInsets.all(20),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          InkWell(
                                            onTap : (){
                                            Navigator.pop(context);
                                            },
                                              child: Icon(Icons.cancel_rounded,size: 30,))
                                        ],
                                      ),
                                      InkWell(
                                        onTap: (){
                                          setState(() {
                                            collectionType = 'Home Collection';
                                            Navigator.pop(context);
                                          });
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(top: 10),
                                          width: double.infinity,
                                          decoration: ColorFillContainer(Colors.indigo.shade50),
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: mainText('Home Collection'),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      InkWell(
                                        onTap: (){
                                          setState(() {
                                            collectionType = 'Center Visit';
                                            Navigator.pop(context);
                                          });
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(top: 5),
                                          width: double.infinity,
                                          decoration: ColorFillContainer(Colors.indigo.shade50),
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: mainText('Center Visit'),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            )
                        );
                      },
                      child: secondText('EDIT ')
                    ),
                  ],
                ),
                Container(
                  width: double.infinity,
                  decoration: ColorFillContainer(Colors.indigo.shade50),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: mainText(collectionType),
                  ),
                ),
                divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    firstText(' PATHOLOGY SERVICE :'),
                    InkWell(
                      onTap: () async{
                        tempServiceList = [];
                        selectedServiceList.forEach((val) {
                          tempServiceList.add(PathologyServiceModal(amount: val.amount, name: val.name, id: val.id, servicemapid: val.servicemapid, isSelected: val.isSelected, isPackage: val.isPackage));
                        });
                        var change = await Get.to(const EditServicePage());
                        if(change != 'false' && change != null){
                          selectedServiceList=[];
                          change.forEach((val){
                            selectedServiceList.add(PathologyServiceModal(amount: val.amount, name: val.name, id: val.id, servicemapid: val.servicemapid, isSelected: val.isSelected, isPackage: val.isPackage));
                          });
                          checkCost();
                        }
                        else{
                          selectedServiceList=[];
                          tempServiceList.forEach((val){
                            selectedServiceList.add(PathologyServiceModal(amount: val.amount, name: val.name, id: val.id, servicemapid: val.servicemapid, isSelected: val.isSelected, isPackage: val.isPackage));
                          });
                          checkCost();
                        }
                      },
                      child: secondText(selectedServiceList.isEmpty?'ADD' : 'EDIT ')
                    ),
                  ],
                ),
                Container(
                  width: double.infinity,
                  decoration: ColorFillContainer(Colors.indigo.shade50),
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: selectedServiceList.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index){
                        return ListTile(
                          visualDensity: VisualDensity(vertical: -4),
                          contentPadding :EdgeInsets.zero,
                          title: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(child: Text(selectedServiceList[index].name, style: TextStyle(fontWeight: FontWeight.w600,color: Colors.grey.shade800,fontSize: 14),)),
                                  SizedBox(width: 10,),
                                  Text('${selectedServiceList[index].amount} RS.', style: TextStyle(fontWeight: FontWeight.w600,color: Colors.grey.shade800,fontSize: 14),)
                                ],
                              )),
                        );
                      },
                    )
                  ),
                ),
                divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    firstText(' PATHOLOGY PACKAGES :'),
                    InkWell(
                        onTap: () async{
                          tempPackageList = [];
                          finalSelectedPackageList.forEach((val){
                            tempPackageList.add(PathologyServiceModal(amount: val.amount, name: val.name, id: val.id, servicemapid: val.servicemapid, isSelected: val.isSelected, isPackage: val.isPackage));
                          });
                          var change = await Get.to(EditPackagesPage());
                          addPckage = false;
                          if(change != 'false' && change != null){
                            finalSelectedPackageList=[];
                            change.forEach((val){
                              finalSelectedPackageList.add(PathologyServiceModal(amount: val.amount, name: val.name, id: val.id, servicemapid: val.servicemapid, isSelected: val.isSelected, isPackage: val.isPackage));
                            });
                              checkCost();
                          }else{
                            finalSelectedPackageList=[];
                            tempPackageList.forEach((val){
                              finalSelectedPackageList.add(PathologyServiceModal(amount: val.amount, name: val.name, id: val.id, servicemapid: val.servicemapid, isSelected: val.isSelected, isPackage: val.isPackage));
                            });
                              checkCost();
                          }
                        },
                        child: secondText(addPckage == true?'EDIT ' : 'ADD ')
                    ),
                  ],
                ),
                Container(
                  width: double.infinity,
                  decoration: ColorFillContainer(Colors.indigo.shade50),
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: ListView.builder(
                        itemCount:finalSelectedPackageList.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index){
                          int itemCount = 0;
                          for(int i=0; i<totalPackageList.length; i++){
                            if(trueServiceList[index].servicemapid == totalPackageList[i].serviceIDF){
                              itemCount = itemCount + 1;
                            }
                          }
                          trueServiceList[index].itemCount = itemCount;
                          return finalSelectedPackageList[index].isSelected == 'true'? Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),),
                            margin: EdgeInsets.only(top: 3,bottom: 3,left: 3,right: 3),
                            padding: EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(child: Text(finalSelectedPackageList[index].name,style: TextStyle(fontWeight: FontWeight.w600,color: Colors.grey.shade800,fontSize: 14),)),
                                SizedBox(width: 10,),
                                Row(
                                  children: [
                                    Badge(
                                      badgeStyle: BadgeStyle(
                                        shape: BadgeShape.circle,
                                        borderRadius: BorderRadius.circular(5),
                                        padding: EdgeInsets.all(3),
                                        badgeGradient: BadgeGradient.linear(
                                          colors: [
                                            Colors.indigo.shade500,
                                            Colors.blue,
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                      ),
                                      position: BadgePosition.topEnd(top: -10),
                                      badgeContent: Text(trueServiceList[index].itemCount<9?'0${trueServiceList[index].itemCount}' : '${trueServiceList[index].itemCount}', style: TextStyle(color: Colors.white,fontSize: 10),
                                      ),
                                      child: SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: Image.asset('assets/images/pathologyI_con.png')),
                                    ),
                                    SizedBox(width: 15,),
                                    Text('${finalSelectedPackageList[index].amount} RS.',style: TextStyle(fontSize: 14,color: Colors.grey.shade800,fontWeight: FontWeight.w600),),
                                  ],
                                ),
                              ],
                            ),
                          ) : Container(
                            height: 0,
                          );
                        },
                      ),
                  ),
                ),
                divider(),
                Container(
                  width: double.infinity,
                  decoration: ColorFillContainer(Colors.indigo.shade50),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        mainText('TOTAL COST : '),
                        mainText('$totalCost RS. ')
                      ],
                    ),
                  ),
                ),
                divider(),
                Row(
                  children: [
                    firstText(' DATE & TIME : '),
                  ],
                ),
                Container(
                  width: double.infinity,
                  decoration: ColorFillContainer(Colors.indigo.shade50),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        mainText(current_date),
                        mainText('$startTime To $endTime')
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                InkWell(
                  onTap: (){
                    if(addPckage == true || selectedServiceList.isNotEmpty){
                      showDialog<String>(
                          context: context,
                          builder: (context) =>StatefulBuilder(
                              builder: (context, StateSetter setState){
                                return Dialog(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  insetPadding: EdgeInsets.all(30),
                                  elevation: 16,
                                  child: Container(
                                    padding: const EdgeInsets.only(left: 25,right: 25,top: 15,bottom: 20),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            InkWell(
                                                onTap : (){
                                                  Navigator.pop(context);
                                                },
                                                child: Icon(Icons.cancel_rounded,size: 30,))
                                          ],
                                        ),
                                        RadioListTile(
                                          activeColor: Colors.green,
                                          visualDensity: const VisualDensity(
                                            horizontal: VisualDensity.minimumDensity,
                                            vertical: VisualDensity.minimumDensity,
                                          ),
                                          title: const Text('Pay Online'),
                                          value: "Pay Online",
                                          groupValue: paymentText,
                                          onChanged: (value){
                                            setState(() {
                                              paymentText = value.toString();
                                            }
                                            );
                                          },
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.only(left: 10.0, right: 10),
                                          child: Divider(
                                            thickness: 1,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        RadioListTile(
                                          activeColor: Colors.green,
                                          visualDensity: const VisualDensity(
                                            horizontal: VisualDensity.minimumDensity,
                                            vertical: VisualDensity.minimumDensity,
                                          ),
                                          title: const Text('Pay At Visit'),
                                          value: "Pay At Visit",
                                          groupValue: paymentText,
                                          onChanged: (value){
                                            setState(() {
                                              paymentText = value.toString();
                                            }
                                            );
                                          },
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        InkWell(
                                          onTap: (){
                                            Navigator.pop(context);
                                            submitData();
                                          },
                                          child: Container(
                                            width: double.infinity,
                                            decoration: ColorFillContainer(Colors.green),
                                            child: const Padding(
                                              padding: EdgeInsets.all(10.0),
                                              child: Text('Submit',textAlign: TextAlign.center,style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              }
                          )
                      );
                    }else{
                      showToast('Please select Service or Package');
                    }

                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: ColorFillContainer(Colors.green.shade500),
                    child: const Center(
                      child: Text('Proceed To Pay',style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.w500),),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
