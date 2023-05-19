import 'dart:convert';
import 'package:digipath_ircs/Design/GlobalAppBar.dart';
import 'package:digipath_ircs/Design/TopPageTextViews.dart';
import 'package:digipath_ircs/Global/global.dart';
import 'package:digipath_ircs/NewPages/UploadDocumentPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/route_manager.dart';
import 'package:http/http.dart';
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

    try{

      Response response = await get(Uri.parse('https://smarthealth.care/smart_getAllEncounterForCitizen.shc?citizenID=$localCitizenIDP'),
      headers: {
        'token' : token
      });

      EasyLoading.dismiss();

      if(response.statusCode == 200){

        var data = jsonDecode(response.body.toString());

        String status = data['status'].toString();
        print('Response Is $data');

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
            noDataTextString = 'Do Data Found';
          }

          setState(() {

          });
        }

      }

    }catch(e){
      setState(() {

        noDataTextString = 'Sorry ! Server Error';
        noDataText = true;
        EasyLoading.dismiss();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GlobalAppBar(context),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.indigo[100],
        child: Column(
          children: [
            TopPageTextViews('Tele-Consultation','Video Consultation'),
            noDataText?Container(
                width: double.infinity,
                margin: const EdgeInsets.all(25),
                decoration: ColorFillContainer(Colors.white),
                padding: const EdgeInsets.all(15),
                child: Text(noDataTextString,style:const TextStyle(fontSize: 15,fontWeight: FontWeight.bold),textAlign: TextAlign.center)) :
            ListView.builder(
            itemCount: teleConsulationList.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
               return Container(
                 padding: EdgeInsets.all(15),
                 decoration: ColorFillContainer(Colors.white),
                 margin: EdgeInsets.all(20),
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
                         Get.to(UploadDocumentPage(isDirect: false,));
                       },
                       child: Container(
                         decoration: ColorFillContainer(Colors.green),
                         padding: EdgeInsets.all(15),
                         child: const Text('Add Records Or Initiate Video consultation',textAlign: TextAlign.center,style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),),
                       ),
                     )
                   ],
                 ),

               );
              }
            )
          ],
        ),
      ),
    );
  }
}
