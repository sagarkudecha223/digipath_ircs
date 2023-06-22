import 'package:digipath_ircs/Global/Colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/route_manager.dart';
import '../Design/BorderContainer.dart';
import '../Design/ColorFillContainer.dart';
import '../Design/GlobalAppBar.dart';
import '../Design/TopPageTextViews.dart';
import '../Global/SearchAPI.dart';
import '../Global/Toast.dart';
import '../Global/global.dart';
import '../ModalClass/DoctorListModal.dart';
import 'TimeSlotPage.dart';

class DoctorListPage extends StatefulWidget {
  final String url;
  const DoctorListPage({Key? key, required this.url}) : super(key: key);

  @override
  State<DoctorListPage> createState() => _DoctorListPageState(url);
}

class _DoctorListPageState extends State<DoctorListPage> {

  late String url;
  _DoctorListPageState(this.url);

  late String  STSIDP;
  late String ScheeduleWeekDays;
  late String ScheduleStartTime;
  late String ScheduleEndTime;
  bool noDataText = true;
  String noDataTextString = 'Searching...';

  List<DoctorListModal> doctorList = <DoctorListModal>[];

  @override
  void initState() {
    super.initState();
    EasyLoading.show(status: 'Loading...');
    searchDoctorList();
  }

  void searchDoctorList() async{

    doctorList.clear();

    dynamic status = await searchAPI(false ,url,
        {"token" : token
        },{}, 45);

    print(' status after responce: $status');
    EasyLoading.dismiss();

    if(status.toString() != 'Sorry !!! Server Error' && status.toString().isNotEmpty && status.toString() != 'Sorry !!!  Connectivity issue! Try again'){
      List<dynamic> statusinfo = status['dataForReactArray'];

      if(statusinfo.isNotEmpty) {
        for (int i = 0; i < statusinfo.length; i++) {
          String careProfessionalIDP = statusinfo[i]["careProfessionalIDP"].toString();
          String careProfessionalName = statusinfo[i]["careProfessionalName"].toString();
          String specialityType = statusinfo[i]["specialityType"].toString();
          String careProviderIDP = statusinfo[i]["careProviderIDP"].toString();
          String careProviderName = statusinfo[i]["careProviderName"].toString();

          List<dynamic> time = statusinfo[i]['time'];
          for(int j =0; j<time.length; j++){
             STSIDP = time[j]["STSIDP"].toString();
             ScheeduleWeekDays = time[j]["ScheeduleWeekDays"].toString();
             ScheduleStartTime = time[j]["ScheduleStartTime"].toString();
             ScheduleEndTime = time[j]["ScheduleEndTime"].toString();
          }
          doctorList.add(DoctorListModal(careProfessionalIDP: careProfessionalIDP, careProfessionalName: careProfessionalName, specialityType: specialityType, careProviderIDP: careProviderIDP
            ,careProviderName: careProviderName, STSIDP: STSIDP, ScheeduleWeekDays: ScheeduleWeekDays, ScheduleStartTime: ScheduleStartTime, ScheduleEndTime: ScheduleEndTime,));
        }
        if(mounted){
          setState(() {
            noDataText = false;
            EasyLoading.dismiss();
          });
        }
      }
      else{
        if(mounted){
          setState(() {
            noDataText = true;
            noDataTextString = 'No matching data found';
            EasyLoading.dismiss();
            showToast('Sorry ! No matching data found');
          });
        }
      }
    }
    else if(status.toString() == 'Sorry !!!  Connectivity issue! Try again'){
      setState(() {
        noDataText = true;
        noDataTextString = 'Sorry !!!  Poor Internet Connectivity ! Try again';
      });
      showToast('Sorry !!!  Poor Internet Connectivity ! Try again');
    }
    else{
      if(mounted){
        setState(() {
          EasyLoading.dismiss();
          noDataText = true;
          noDataTextString = 'Sorry !!! Server Error';
          showToast('Sorry !!! Server Error');
        });
      }
    }
  }

  Padding CommonDivider(){
    return  Padding(
      padding: const EdgeInsets.only(top: 15,bottom: 15),
      child: Divider(
        thickness: 0.5,
        color: globalBlue,
        height: 1,
      ),
    );
  }

  Row CommonRow(String firstText, secondText){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(firstText,style: TextStyle(color: Colors.grey.shade800,fontSize: 15)),
        Flexible(child: Text(secondText, style:TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.grey.shade800),textAlign: TextAlign.end,))
      ],
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
      appBar: GlobalAppBar(context,'Doctor List'),
      body: Container(
        height: MediaQuery.of(context).size.height ,
        width: MediaQuery.of(context).size.width ,
        color: globalPageBackgroundColor,
        child: Column(
          children: [
            TopPageTextViews('Select doctor from the listing below'),
            noDataText?Text(noDataTextString,style:const TextStyle(fontSize: 15,fontWeight: FontWeight.bold),textAlign: TextAlign.center) :
            Flexible(
              child: Container(
                padding: const EdgeInsets.only(left: 5,right: 5),
                margin: const EdgeInsets.only(left: 5,right: 5,bottom: 5),
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(15),
                ),
                child: RefreshIndicator(
                  onRefresh: () {
                    return Future.delayed(Duration(microseconds: 500),
                            () {
                          EasyLoading.show(status: 'Loading...');
                          searchDoctorList();
                        });
                  },
                  child: SingleChildScrollView(
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: doctorList.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            visualDensity: const VisualDensity(vertical: -4),
                            onTap: (){},
                            contentPadding :EdgeInsets.zero,
                            title: Container(
                                padding: const EdgeInsets.only(left: 20,right: 20,top: 20,bottom: 10),
                                margin: EdgeInsets.all(5),
                                decoration: BorderContainer(Colors.white,globalBlue),
                                child: Column(
                                  children: [
                                    CommonRow('Dr Name   ', doctorList[index].careProfessionalName),
                                    CommonDivider(),
                                    CommonRow('Hospital    ',  doctorList[index].careProviderName),
                                    CommonDivider(),
                                    CommonRow('Speciality    ',  doctorList[index].specialityType),
                                    CommonDivider(),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text('Time    ',style: TextStyle(color: Colors.grey.shade600,fontSize: 15)),
                                        Flexible(child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text( doctorList[index].ScheeduleWeekDays,style:const TextStyle(fontSize: 15,fontWeight: FontWeight.bold)),
                                            Text('${doctorList[index].ScheduleStartTime} - ${doctorList[index].ScheduleEndTime}',style:const TextStyle(fontSize: 15,fontWeight: FontWeight.bold))
                                          ],
                                        ))
                                      ],
                                    ),
                                    CommonDivider(),
                                    InkWell(
                                      onTap: (){
                                      Get.to( TimeSlotPage(careProviderIDP: doctorList[index].careProviderIDP, CareProfessionalIDP: doctorList[index].careProfessionalIDP, careProfessionalName:  doctorList[index].careProfessionalName));
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(top: 5,bottom: 5),
                                        width: double.infinity,
                                        decoration: ColorFillContainer(globalOrange),
                                        child:
                                        Padding(
                                          padding: EdgeInsets.all(10.0),
                                          child: Center(
                                            child: Text('Book Appointment'.toUpperCase(),style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                )
                            ),
                          );
                        }
                    ),
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
