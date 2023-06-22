import 'dart:convert';
import 'package:digipath_ircs/Global/Colors.dart';
import 'package:digipath_ircs/Global/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart';
import '../CardViews/MedicalRecordsCard.dart';
import '../Design/GlobalAppBar.dart';
import '../Design/TopPageTextViews.dart';
import '../Global/Toast.dart';
import '../ModalClass/MedicalReportModal.dart';

class ViewTimeLinePage extends StatefulWidget {
  const ViewTimeLinePage({Key? key}) : super(key: key);

  @override
  State<ViewTimeLinePage> createState() => _ViewTimeLinePageState();
}

class _ViewTimeLinePageState extends State<ViewTimeLinePage> {

   String ServiceName = '';
   String DoctorName = '';
   String CareProviderName = '';
   String OnSetDate = '';
   String ReportStatus = '';
   String ImageType = '';
   String modalityIDP = '';
   String Document = '';
   String LinkToMeasurement = '';
   String ServiceMapIDP = '';
   String EncounterServiceIDP = '';
   String filterReportStatus = '';
   String Age = '';
   String CitizenIDF = '';
   String EncounterServiceNumber = '';
   String PatientDocumentIDP = '';
   String ServiceIDP = '';
   String CareprofessionalByTreatingDoctorIdf = '';
   String ServiceAlias = '';
  String reportStatusText = '';
  String u = 'dhruv';
  String p  = 'demo';
  List<MedicalReportModal> recordlist =  <MedicalReportModal>[];
   String PatientReportIDP = '';
   String RightPatientReportIDP = '';
   String LeftPatientReportIDP = '';
  bool noDataText = true;
  String noDataTextString = 'Searching...';

  @override
  void initState() {
    super.initState();
    EasyLoading.show(status: 'Loading...');
    getRecord();
  }

  void getRecord() async{

    recordlist.clear();

    try {
      Response response = await get(
          Uri.parse(
              '$urlForIN/getListofDateAsPerCitizenCode.app?CitizenCode=15092100073901'),
          headers: {
            'u': 'dhruv',
            'p': 'demo',
          }
      );

      if (mounted) {
        if (response.statusCode == 200) {

          var status = jsonDecode(response.body.toString());
          print(status);

          List<dynamic> statusinfo = status['JsonResponse'];
          print(statusinfo);

          if(statusinfo.isNotEmpty) {
            for (int i = 0; i < statusinfo.length; i++) {

                Document = statusinfo[i]["Document"].toString();
                CareProviderName = statusinfo[i]["CareProviderName"].toString();
                CareprofessionalByTreatingDoctorIdf = statusinfo[i]["CareprofessionalByTreatingDoctorIdf"].toString();
                PatientDocumentIDP = statusinfo[i]["PatientDocumentIDP"].toString();
                ServiceAlias = statusinfo[i]["ServiceAlias"].toString();
                ServiceName = statusinfo[i]["ServiceName"].toString();
                DoctorName = statusinfo[i]["DoctorName"].toString();
                OnSetDate = statusinfo[i]["OnSetDate"].toString();
                ReportStatus = statusinfo[i]["ReportStatus"].toString();
                ImageType = statusinfo[i]["ImageType"].toString();
                modalityIDP = statusinfo[i]["modalityIDP"].toString();
                LinkToMeasurement = statusinfo[i]["LinkToMeasurement"].toString();
                ServiceMapIDP = statusinfo[i]["ServiceMapIDP"].toString();
                EncounterServiceIDP = statusinfo[i]["EncounterServiceIDP"].toString();
                Age = statusinfo[i]["Age"].toString();
                ServiceIDP = statusinfo[i]["ServiceIDP"].toString();
                CitizenIDF = statusinfo[i]["CitizenIDF"].toString();
                EncounterServiceNumber = statusinfo[i]["EncounterServiceNumber"].toString();

              recordlist.add(MedicalReportModal(
                  ServiceName: ServiceName, DoctorName: DoctorName,
                  CareProviderName: CareProviderName, OnSetDate: OnSetDate, ReportStatus: ReportStatus,
                  ImageType: ImageType, modalityIDP: modalityIDP, Document: Document, LinkToMeasurement: LinkToMeasurement, ServiceMapIDP: ServiceMapIDP,
                  EncounterServiceIDP: EncounterServiceIDP,Age: Age, CitizenIDF: CitizenIDF, EncounterServiceNumber: EncounterServiceNumber,
                  PatientDocumentIDP: PatientDocumentIDP,ServiceIDP: ServiceIDP, CareprofessionalByTreatingDoctorIdf: CareprofessionalByTreatingDoctorIdf, ServiceAlias: ServiceAlias));
            }
          }

          if (mounted) {
            setState(() {
              EasyLoading.dismiss();
              if (recordlist.isEmpty) {
                noDataText = true;
                noDataTextString = 'No Data Found';
              }
              else {
                noDataText = false;
              }
            });
          }
        }
      }
    }
    catch(e){
      EasyLoading.dismiss();
      if (mounted) {
        showToast(e.toString());
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
      appBar: GlobalAppBar(context,'View TimeLine'),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: globalPageBackgroundColor,
        child: Column(
          children: [
            TopPageTextViews('Can see Timeline Reports here..'),
            noDataText?Text(noDataTextString,style:const TextStyle(fontSize: 15,fontWeight: FontWeight.bold),textAlign: TextAlign.center) :
            Flexible(
              child: RefreshIndicator(
                onRefresh: () {
                  return Future.delayed(Duration(microseconds: 500),
                          () {
                        EasyLoading.show(status: 'Loading...');
                        getRecord();
                      });
                },
                child: SingleChildScrollView(
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: recordlist.length,
                    itemBuilder: (context, index){
                      return MedicalRecordsCard(medicalReportModal: recordlist[index]);
                    },
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
