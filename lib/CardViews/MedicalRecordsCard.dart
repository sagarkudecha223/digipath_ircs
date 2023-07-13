import 'dart:convert';
import 'dart:io';
import 'package:digipath_ircs/Design/BorderContainer.dart';
import 'package:digipath_ircs/Global/Colors.dart';
import 'package:digipath_ircs/Global/ShowGlobalDialog.dart';
import 'package:dio/dio.dart' as foo;
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path_provider/path_provider.dart';
import '../Global/Toast.dart';
import '../Global/global.dart';
import '../ModalClass/MedicalReportModal.dart';

class MedicalRecordsCard extends StatefulWidget {

  final MedicalReportModal medicalReportModal;
  MedicalRecordsCard({required this.medicalReportModal});

  @override
  _MedicalRecordsCardState createState() => _MedicalRecordsCardState();

}

class _MedicalRecordsCardState extends State<MedicalRecordsCard> {

  String reportStatusText = '';
  late String ServiceMapIDP =  widget.medicalReportModal.ServiceMapIDP;
  late String Age = widget.medicalReportModal.Age;
  late String EncounterServiceNumber = widget.medicalReportModal.EncounterServiceNumber;
  late String CitizenIDF = widget.medicalReportModal.CitizenIDF;
  late String EncounterServiceIDP = widget.medicalReportModal.EncounterServiceIDP;
  late String PatientReportIDP;
  late String RightPatientReportIDP;
  late String LeftPatientReportIDP;
  late String PatientDocumentIDP = widget.medicalReportModal.PatientDocumentIDP;
  late String imageType = widget.medicalReportModal.ImageType;

  @override
  void initState() {
    super.initState();

    reportStatusText = '';

    if(widget.medicalReportModal.Document == '1'){
      reportStatusText = 'Scanned';
    }

    if(widget.medicalReportModal.ReportStatus == '1'){
      reportStatusText = 'Registered';
    }
    else if(widget.medicalReportModal.ReportStatus == '2'){
      reportStatusText = 'Uploaded';
    }
    else if(widget.medicalReportModal.ReportStatus == '3'){
      reportStatusText = 'Reported';
    }
  }

  void fundosCopyReport() async{
    try {
      Response response = await get(
          Uri.parse('$urlForINSC/getPatientReportDataForFundoscopyAndroid.shc?EncounterServiceIDF=$EncounterServiceIDP'),
          headers: {
            'token' : token
          }
      );

      if (mounted) {
        if (response.statusCode == 200) {

          var status = jsonDecode(response.body.toString());
          print(status);

          List<dynamic> statusinfo = status['JsonResponse'];
          print('Fundoscopy::::::: $statusinfo');

          if(!(statusinfo == null || statusinfo.length == 0)) {

            for (int i = 0; i < statusinfo.length; i++) {
              RightPatientReportIDP = statusinfo[i]["RightPatientReportIDP"].toString();
              LeftPatientReportIDP = statusinfo[i]["LeftPatientReportIDP"].toString();
            }

            openFile(
              url: '$urlForINSC/downloadFundoscopyReportForAndroid.app?PatientReportIDP=$RightPatientReportIDP&PatientReportIDPLeft=$LeftPatientReportIDP&Age=$Age&EncounterServiceNumber=$EncounterServiceNumber&CitizenIDF=$CitizenIDF&reportType=$imageType',
              fileName:'$EncounterServiceIDP.pdf',
            );

          }
          else{
            EasyLoading.dismiss();
            showToast('Report Not Found');
          }
        }
        else{
          EasyLoading.dismiss();
          if (mounted) {
            showToast('Report Not Found');
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

  void searchECGReport() async{
    try {
      Response response = await get(
          Uri.parse('$urlForINSC/getPatientReportData.shc?EncounterServiceIDF=$EncounterServiceIDP'),
          headers: {
            'token' : token
          }
      );

      if (mounted) {
        if (response.statusCode == 200) {

          if(response.body != ''){
            var status = jsonDecode(response.body.toString());
            print(status);

            List<dynamic> statusinfo = status['JsonResponse'];
            print('ECGReport::::::: $statusinfo');

            if(!(statusinfo == null || statusinfo.length == 0)) {

              for (int i = 0; i < statusinfo.length; i++) {
                PatientReportIDP = statusinfo[i]["PatientReportIDP"].toString();
              }

              openFile(
                url: '$urlForINSC/getECGReportPrintAndroid.app?patientReportIDP=$PatientReportIDP&Age=$Age&EncounterServiceNumber=$EncounterServiceNumber&reportType=2&CitizenIDF=$CitizenIDF',
                fileName:'$EncounterServiceIDP.pdf',
              );
            }
            else{
              EasyLoading.dismiss();
              showToast('Report Not Found');
            }
          }else{
            EasyLoading.dismiss();
            showToast('Report Not Found');
          }
        }
        else{
          if (mounted) {
            EasyLoading.dismiss();
            showToast('Report Not Found');
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

  void searchXRAYReport() async{

    print('Dicom Report>>>>>>> :::::::: X-Ray');

    try {
      Response response = await get(
          Uri.parse('$urlForINSC/getPatientReportData.shc?EncounterServiceIDF=$EncounterServiceIDP'),
          headers: {
            'token' : token
          }
      );

      if (mounted) {
        if (response.statusCode == 200) {

          if(response.body != ''){
            var status = jsonDecode(response.body.toString());
            print(status);

            List<dynamic> statusinfo = status['JsonResponse'];
            print('XRAyReport::::::: $statusinfo');

            if(!(statusinfo == null || statusinfo.length == 0)) {

              for (int i = 0; i < statusinfo.length; i++) {
                PatientReportIDP = statusinfo[i]["PatientReportIDP"].toString();
              }
              openFile(
                url: '$urlForINSC/getRadiologyReportAndImagePrintAndroid.app?patientReportIDP=$PatientReportIDP&Age=$Age&EncounterServiceNumber=$EncounterServiceNumber&reportType=2&CitizenIDF=$CitizenIDF&selPerPage=1',
                fileName:'$EncounterServiceIDP.pdf',
              );
            }
            else{
              EasyLoading.dismiss();
              showToast('Report Not Found');
            }
          }
          else{
            EasyLoading.dismiss();
            showToast('Report Not Found');
          }
        }
        else{
          if (mounted) {
            EasyLoading.dismiss();
            showToast('Report Not Found');
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
    return InkWell(
      onTap: ()=>{
        if(widget.medicalReportModal.Document == '0'){
          if(widget.medicalReportModal.ReportStatus == '1'){
            showGlobalDialog(context, Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 20, bottom: 8),
                  child: Text('Report is registered',textScaleFactor: 1.0,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight
                        .w500), textAlign: TextAlign.center,),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 10, top: 10),
                  child: Text('you can see your report after reporting',textScaleFactor: 1.0,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight
                        .normal), textAlign: TextAlign.center,),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Divider(thickness: 1, color: Colors.grey,),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 3, bottom: 15),
                  child: InkWell(
                      onTap: () => { Navigator.pop(context, 'Cancel')},
                      child: const Padding(
                        padding: EdgeInsets.only(right: 100,left: 100,top: 10,bottom: 10),
                        child: Text('OK',textScaleFactor: 1.0, style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.normal),
                          textAlign: TextAlign.center,),
                      )),
                ),
              ],
            ), true)
          }
          else if(widget.medicalReportModal.ReportStatus == '2'){
            showGlobalDialog(context, Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 20, bottom: 8),
                  child: Text('Report is just uploaded',textScaleFactor: 1.0,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight
                        .w500), textAlign: TextAlign.center,),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 10, top: 10),
                  child: Text('You can view after report reporting',textScaleFactor: 1.0,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight
                        .normal), textAlign: TextAlign.center,),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Divider(thickness: 1, color: Colors.grey,),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 3, bottom: 15),
                  child: InkWell(
                      onTap: () => { Navigator.pop(context, 'Cancel')},
                      child: const Padding(
                        padding: EdgeInsets.only(right: 100,left: 100,top: 10,bottom: 10),
                        child: Text('OK',textScaleFactor: 1.0, style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.normal),
                          textAlign: TextAlign.center,),
                      )),
                ),
              ],
            ), true)
          }
          else if(widget.medicalReportModal.ReportStatus == '3'){

              if(widget.medicalReportModal.LinkToMeasurement == 'true'){

                print('check Report..................'),

                EasyLoading.show(status: 'Loading...'),
                openFile(
                  // https://smarthealth.care/pathologyReport?prmServiceMapID=322618&prmEncounterServiceID=1833826&txtStationary=false&cbWithGraph=undefined&stationaryOption=1
                  url: '$urlForINSC/pathologyReport?prmServiceMapID=$ServiceMapIDP&prmEncounterServiceID=$EncounterServiceIDP&txtStationary=false&cbWithGraph=undefined&stationaryOption=1',
                  fileName:'PathologyReport.pdf',
                ),
              }
              else{

                if(widget.medicalReportModal.ImageType == '1'){

                  if(widget.medicalReportModal.modalityIDP == '18'){
                    print('fundocopyReport...................'),
                    EasyLoading.show(status: 'Loading...'),
                    fundosCopyReport(),
                  }
                  else if(widget.medicalReportModal.modalityIDP == '22'){
                    print('Dicom Report ::::: Fetal Monitoring')
                  }
                  else if(widget.medicalReportModal.modalityIDP == '28'){
                      print('Dicom Report ::::: OCT')
                    }
                    else{
                        EasyLoading.show(status: 'Loading...'),
                        searchXRAYReport(),
                      }
                }
                else if(widget.medicalReportModal.ImageType == '2'){

                  if(widget.medicalReportModal.modalityIDP == '16'){
                    print('Image Report : Capturing')
                  }
                  else if(widget.medicalReportModal.modalityIDP == '17'){
                    print('Image Report : Monitoring')
                  }
                  else if(widget.medicalReportModal.modalityIDP == '19'){
                      print('Image Report : PFT')
                    }

                }
                else if(widget.medicalReportModal.ImageType == '3'){

                  }
                else if(widget.medicalReportModal.ImageType == '4'){

                    if(widget.medicalReportModal.modalityIDP == '6'){
                      print('Wave Form : ECG'),
                      /// ECG Report...
                      EasyLoading.show(status: 'Loading...'),
                      searchECGReport(),
                    }
                    else if(widget.medicalReportModal.modalityIDP == '24'){
                      print('Wave Form :  Patient Monitor')
                    }
                  }
                else if(widget.medicalReportModal.ImageType == '5'){
                    print('WaveFormLoop')
                }
                else if(widget.medicalReportModal.ImageType == '6'){
                    print('UrinAnalysis')
                }
                else if(widget.medicalReportModal.ImageType == '7'){
                    print('Vital')
                }
              }
            }
        }
        else{
          EasyLoading.show(status: 'Loading...'),
          openFile(
            url: '$urlForINSC/getScanDocReportAndroid.do?patientDocumentIDP=$PatientDocumentIDP',
            fileName:'$PatientDocumentIDP.pdf',
          ),
        }
      },
      child: Container(
        margin: const EdgeInsets.fromLTRB(15, 4, 15, 4),
        decoration: BorderContainer(Colors.white, globalBlue),
        child: Padding(
          padding:  EdgeInsets.fromLTRB(8, 8, 8, 3),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                child: Text(widget.medicalReportModal.Document == '1'?widget.medicalReportModal.ServiceAlias : widget.medicalReportModal.ServiceName.toString(),textScaleFactor: 1.0,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color: globalBlue),),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 5),
                child: Text(widget.medicalReportModal.Document == '1'?widget.medicalReportModal.CareprofessionalByTreatingDoctorIdf :widget.medicalReportModal.DoctorName.toString(),textScaleFactor: 1.0,style: TextStyle(fontSize: 16.0),),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 5),
                child: Text(widget.medicalReportModal.CareProviderName.toString(),textScaleFactor: 1.0,style: const TextStyle(fontSize: 16.0),),
              ),
              const Divider(height: 5, thickness: 1, color: Colors.grey,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(widget.medicalReportModal.OnSetDate.toString(),textScaleFactor: 1.0,
                      style: TextStyle(color: globalBlue,fontWeight: FontWeight.w600,fontSize: 16.0),),
                    Row(
                      children: [
                        Visibility(
                            visible: widget.medicalReportModal.ReportStatus == '1',
                            child: Image.asset('assets/images/registered.png',color: globalBlue,)),
                        Visibility(
                            visible: widget.medicalReportModal.ReportStatus == '2',
                            child: Icon(Icons.cloud_upload,color: globalBlue,)),
                        Visibility(
                            visible: widget.medicalReportModal.ReportStatus == '3',
                            child: Image.asset('assets/images/reported.png',color:globalBlue,)),
                        Visibility(
                            visible: widget.medicalReportModal.Document == '1',
                            child: Icon(Icons.scanner,color: globalBlue,)),
                        const SizedBox(width: 5.0,),
                        Text(reportStatusText,textScaleFactor: 1.0,),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future openFile({required String url, required String fileName}) async {
    final name = fileName;
    final file = await downloadFile(url,name);
    print(url);

    if(file == null){
      showToast('Sorry ! PDF Not Found');
      EasyLoading.dismiss();
      return;
    }
    print('Path: ${file.path}');

    EasyLoading.dismiss();
    OpenFile.open(file.path);
  }

  Future<File?> downloadFile(String url, String name) async{

    print(url);

    final appStorage = await getApplicationDocumentsDirectory();
    final file = File('${appStorage.path}/$name');

    try {
      final response = await foo.Dio().get(
          url,
          options: foo.Options(
            // headers: {
            //   'u': 'dhruv',
            //   'p': 'demo'
            // },
            responseType: foo.ResponseType.bytes,
            followRedirects: false,
          )
      );

      final raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(response.data);
      await raf.close();

      return file;
    }
    catch(e){
      return null;
    }
  }

}
