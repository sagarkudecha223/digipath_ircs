import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/route_manager.dart';
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

    dynamic status = await searchAPI(false ,url,
        {"token" : "eyJhbGciOiJSUzI1NiJ9.eyJ1bmFtZSI6IjI2MDk3MTQ1NDA5MSIsInNlc3Npb25pZCI6IkQyN0I4QTBBQzNERjZCQzlEQUEwNUU2NTlDODk2NTk1Iiwic3ViIjoiSldUX1RPS0VOIiwianRpIjoiNWQxYWU3ZmYtMzJhOC00YWYxLWE4OTItODE1MWRiMDRlNzE3IiwiaWF0IjoxNjc4MTcyMTQzfQ.J4pK2XBzMaZNlgGAFxB1yFLUJoWKhzqHBKJbZfxwau7aBhMyb1ovWevVVgHQR5DsKJUhPbedNnhqvSOdLNO6uWn2qEwlGVpsslDCz1oftzA3NymnUF5xRoYoTkqjcM_3Raw6sVST9jAlw0hKmS_1tVJKBWdI1754FC-1o2qZ0mPOn-AT_1DGhWkFg88FRdtZAD2Zb7NUJ0vmvVlXzvkvhFEZsb-NksM4neAtWozUGqV-ZQ23JI21QDEZIC6Xj3khEJqNwVxNUrXH6CAdDU2QiDc7RJ6aN9HdqEdRvUSnvjA88qjBtQeNgp88rMMQ5g36WlzO0vQO4uO-Ek4pax9rpg"
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
        color: Colors.grey[500],
        height: 1,
      ),
    );
  }

  Row CommonRow(String firstText, secondText){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(firstText,style: TextStyle(color: Colors.grey.shade500,fontSize: 15)),
        Flexible(child: Text(secondText,style:const TextStyle(fontSize: 15,fontWeight: FontWeight.bold),textAlign: TextAlign.end,))
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
      appBar: GlobalAppBar(context),
      body: Container(
        height: MediaQuery.of(context).size.height ,
        width: MediaQuery.of(context).size.width ,
        color: Colors.indigo[100],
        child: Column(
          children: [
            TopPageTextViews('Doctor List','select doctor from the listing below'),
            noDataText?Text(noDataTextString,style:const TextStyle(fontSize: 15,fontWeight: FontWeight.bold),textAlign: TextAlign.center) :
            Flexible(
              child: Container(
                padding: const EdgeInsets.only(left: 5,right: 5),
                margin: const EdgeInsets.only(left: 5,right: 5,top: 5,bottom: 5),
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(15),
                ),
                child: ListView.builder(
                    itemCount: doctorList.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        visualDensity: const VisualDensity(vertical: -4),
                        onTap: (){},
                        contentPadding :EdgeInsets.zero,
                        title: Container(
                            padding: EdgeInsets.all(20),
                            margin: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: const [
                                BoxShadow(
                                    color: Colors.grey,
                                    blurRadius: 5,
                                    blurStyle: BlurStyle.outer,
                                    spreadRadius: 1,
                                    offset: Offset(0, 0)
                                ),
                              ],
                            borderRadius: BorderRadius.circular(13),),
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
                                    Text('Time    ',style: TextStyle(color: Colors.grey.shade500,fontSize: 15)),
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
                                    margin: EdgeInsets.only(top: 15,bottom: 15),
                                    width: double.infinity,
                                    decoration: ColorFillContainer(Colors.lightGreen),
                                    child: const Padding(
                                      padding: EdgeInsets.all(10.0),
                                      child: Center(
                                        child: Text('Book Appointment',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
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
            )
          ],
        ),
      ),
    );
  }
}
