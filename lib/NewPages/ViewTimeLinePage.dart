import 'dart:convert';
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

  late String ServiceName;
  late String DoctorName;
  late String CareProviderName;
  late String OnSetDate;
  late String ReportStatus;
  late String ImageType;
  late String modalityIDP;
  late String Document;
  late String LinkToMeasurement;
  late String ServiceMapIDP;
  late String EncounterServiceIDP;
  late String filterReportStatus;
  late String Age;
  late String CitizenIDF;
  late String EncounterServiceNumber;
  late String PatientDocumentIDP;

  List<MedicalReportModal> recordlist =  <MedicalReportModal>[];

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
              'https://medicodb.in/getListofDateAsPerCitizenCode.app?CitizenCode=15092100073901'),
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

          if(!(statusinfo == null)) {
            for (int i = 0; i < statusinfo.length; i++) {
              ServiceName = statusinfo[i]["ServiceName"].toString();
              DoctorName = statusinfo[i]["DoctorName"].toString();
              CareProviderName = statusinfo[i]["CareProviderName"].toString();
              OnSetDate = statusinfo[i]["OnSetDate"].toString();
              ReportStatus = statusinfo[i]["ReportStatus"].toString();
              ImageType = statusinfo[i]["ImageType"].toString();
              modalityIDP = statusinfo[i]["modalityIDP"].toString();
              Document = statusinfo[i]["Document"].toString();
              LinkToMeasurement = statusinfo[i]["LinkToMeasurement"].toString();
              ServiceMapIDP = statusinfo[i]["ServiceMapIDP"].toString();
              EncounterServiceIDP = statusinfo[i]["EncounterServiceIDP"].toString();
              Age = statusinfo[i]["Age"].toString();
              CitizenIDF = statusinfo[i]["CitizenIDF"].toString();
              EncounterServiceNumber = statusinfo[i]["EncounterServiceNumber"].toString();
              PatientDocumentIDP = statusinfo[i]["PatientDocumentIDP"].toString();

              recordlist.add(MedicalReportModal(
                  ServiceName: ServiceName, DoctorName: DoctorName,
                  CareProviderName: CareProviderName, OnSetDate: OnSetDate, ReportStatus: ReportStatus,
                  ImageType: ImageType, modalityIDP: modalityIDP, Document: Document, LinkToMeasurement: LinkToMeasurement, ServiceMapIDP: ServiceMapIDP,
                  EncounterServiceIDP: EncounterServiceIDP,Age: Age, CitizenIDF: CitizenIDF, EncounterServiceNumber: EncounterServiceNumber, PatientDocumentIDP: PatientDocumentIDP));
            }
          }
          else{
          }
          if (mounted) {
            setState(() {
              EasyLoading.dismiss();
              // if (recordlist.isEmpty) {
              //   recordFound = true;
              // }
              // else {
              //   recordFound = false;
              // }
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
      appBar: GlobalAppBar(context),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.indigo[100],
        child: Column(
          children: [
            TopPageTextViews('View TimeLine','Can see Timeline Reports here..'),
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
                  child: Column(
                    children: recordlist.map((key) => MedicalRecordsCard(medicalReportModal:key)).toList(),
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
