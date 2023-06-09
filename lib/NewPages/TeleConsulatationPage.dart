import 'dart:convert';
import 'package:digipath_ircs/Design/GlobalAppBar.dart';
import 'package:digipath_ircs/Design/TopPageTextViews.dart';
import 'package:digipath_ircs/Global/Colors.dart';
import 'package:digipath_ircs/Global/global.dart';
import 'package:digipath_ircs/NewPages/UploadDocumentPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/route_manager.dart';
import 'package:http/http.dart';
import '../Design/BorderContainer.dart';
import '../Design/ColorFillContainer.dart';
import '../ModalClass/TeleConsultionModal.dart';

class TeleConsultationPage extends StatefulWidget {
  const TeleConsultationPage({Key? key}) : super(key: key);

  @override
  State<TeleConsultationPage> createState() => _TeleConsultationPageState();
}

class _TeleConsultationPageState extends State<TeleConsultationPage> {

  bool noDataText = true;
  String noDataTextString = 'Searching...';
  List<TeleConsulationModal> teleConsulationList = <TeleConsulationModal>[];

  @override
  void initState() {
    super.initState();
    getTeleConsulation();
  }

  void getTeleConsulation() async{

    EasyLoading.show(status: 'loading...');
    teleConsulationList.clear();

    try{

      print('$urlForINSC/smart_getAllEncounterForCitizen.shc?citizenID=$localCitizenIDP');

      Response response = await get(Uri.parse('$urlForINSC/smart_getAllEncounterForCitizen.shc?citizenID=$localCitizenIDP'),
      headers: {
        'token' : token
      });
      print(' Response :::::::${response.body}');
      EasyLoading.dismiss();

      if(mounted){
        if(response.statusCode == 200){

          var data = jsonDecode(response.body.toString());

          String status = data['status'].toString();

          if(status == 'true'){

            List<dynamic> list = data['data'];

            if(list.isNotEmpty) {
              for (int i = 0; i < list.length; i++) {
                String appointmentDate = list[i]['appointmentDate'].toString();
                String startTime = list[i]['startTime'].toString();
                String endTime = list[i]['endTime'].toString();
                String tDr = list[i]['tDr'].toString();
                String tDrID = list[i]['tDrID'].toString();
                String drCitizenID = list[i]['drCitizenID'].toString();
                String encounterIDP = list[i]['encounterIDP'].toString();
                String encounterServiceIDP = list[i]['encounterServiceIDP'].toString();

                teleConsulationList.add(TeleConsulationModal(appointmentDate: appointmentDate, startTime: startTime, endTime: endTime, tDr: tDr,
                    tDrID: tDrID, drCitizenID: drCitizenID, encounterIDP: encounterIDP, encounterServiceIDP: encounterServiceIDP));

              }
            }

            if(teleConsulationList.isNotEmpty){
              noDataText = false;
            }else{
              noDataText = true;
              noDataTextString = 'No Data Found';
            }
            setState(() {

            });
          }
        }else{
          setState((){
            noDataTextString = 'Sorry ! Server Error';
            noDataText = true;
          });
        }
      }

    }catch(e){
      if(mounted){
        setState(() {
          noDataTextString = 'Sorry ! Server Error';
          noDataText = true;
          EasyLoading.dismiss();
        });
      }
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
      appBar: GlobalAppBar(context, 'Tele-Consultation'),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: globalPageBackgroundColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TopPageTextViews('Video Consultation'),
            noDataText?Container(
                width: double.infinity,
                margin: const EdgeInsets.all(25),
                decoration: BorderContainer(Colors.white,globalBlue),
                padding: const EdgeInsets.all(15),
                child: Text(noDataTextString,style:const TextStyle(fontSize: 15,fontWeight: FontWeight.bold),textAlign: TextAlign.center)) :
            Flexible(
              child: RefreshIndicator(
                onRefresh: () {
                  return Future.delayed(const Duration(microseconds: 500),() {
                    setState(() {
                      noDataText = true;
                    });
                    getTeleConsulation();
                  });
                },
                child: SingleChildScrollView(
                  child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: teleConsulationList.length,
                      itemBuilder: (context, index) {
                     return Container(
                       padding: EdgeInsets.all(15),
                       decoration: BorderContainer(Colors.white,globalBlue),
                       margin: EdgeInsets.only(left: 20,right: 20,top: 10),
                       child: Column(
                         children: [
                           Padding(
                             padding: const EdgeInsets.all(8.0),
                             child: Text('You have an appointment with Dr.${teleConsulationList[index].tDr} On ${teleConsulationList[index].appointmentDate} At ${teleConsulationList[index].startTime}'
                                 ' Please upload all your previous medical records prior to video consultation',textAlign: TextAlign.start,style: TextStyle(fontWeight: FontWeight.w600),),
                           ),
                           SizedBox(height: 10,),
                           InkWell(
                             onTap : (){
                               Get.to(UploadDocumentPage(isDirect: false, encounterID: teleConsulationList[index].encounterIDP, startTime: teleConsulationList[index].startTime,
                                 endTime: teleConsulationList[index].endTime, appointmentDate: teleConsulationList[index].appointmentDate,));
                             },
                             child: Container(
                               decoration: ColorFillContainer(globalOrange),
                               padding: EdgeInsets.all(15),
                               child: const Text('Add Records Or Initiate Video consultation',textAlign: TextAlign.center,style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),),
                             ),
                           )
                         ],
                       ),

                     );
                    }
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
