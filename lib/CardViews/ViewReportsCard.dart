import 'package:digipath_ircs/Global/Colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:open_file_plus/open_file_plus.dart';
import '../Global/Toast.dart';
import '../ModalClass/ViewReportsModal.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart' as foo;

class ViewReportsCard extends StatefulWidget {

  final ViewReportModal viewReportModal;
  ViewReportsCard({required this.viewReportModal});

  @override
  State<ViewReportsCard> createState() => _ViewReportsCardState();
}

class _ViewReportsCardState extends State<ViewReportsCard> {

  bool Reported = false;
  String reportStatusText = '';
  late String ServiceMapIDP = widget.viewReportModal.ServiceMapIDP;
  late String EncounterServiceNumber = widget.viewReportModal.EncounterServiceNumber;
  late String CitizenIDF = widget.viewReportModal.CitizenIDF;
  late String EncounterServiceIDP = widget.viewReportModal.EncounterServiceIDP;

  @override
  void initState() {
    super.initState();

    if(widget.viewReportModal.ReportStatus == '3'){
      reportStatusText = 'Reported';
      Reported = true;
    }
    else if(widget.viewReportModal.ReportStatus == '2'){
      reportStatusText = 'In-process';
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
          if(widget.viewReportModal.ReportStatus == '3'){
                EasyLoading.show(status: 'Loading...'),
                openFile(
                  // https://medicodb.in/getPathologyReportAndroid.do?prmServiceMapID=370742&prmEncounterServiceID=1833113&txtStationary=true
                  url: 'https://medicodb.in/getPathologyReportAndroid.do?prmServiceMapID=$ServiceMapIDP&prmEncounterServiceID=$EncounterServiceIDP&txtStationary=true',
                  fileName:'demo.pdf',
                ),
            }
      },
      child: Container(
        margin: EdgeInsets.fromLTRB(10, 4, 10, 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
              width: 1.5,
              color: Colors.grey
          ),
          boxShadow: const [
            BoxShadow(
                color: Colors.grey,
                blurRadius: 4,
                blurStyle: BlurStyle.outer,
                spreadRadius: 0,
                offset: Offset(0, 0)
            ),
          ],
        ),
        child: Padding(
          padding:  EdgeInsets.fromLTRB(8, 8, 8, 3),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 8,bottom: 2,top: 6,right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Date: '+  widget.viewReportModal.OnSetDate.toString(),textScaleFactor: 1.0,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16.0),),
                    Icon(Reported?Icons.download:Icons.cached_rounded, color: globalOrange,),
                  ],),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 2, 10, 5),
                child: Text('Name: '+ widget.viewReportModal.ServiceName.toString(),textScaleFactor: 1.0,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18),),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8,bottom: 8),
                child: Text('Status: '+ reportStatusText,textScaleFactor: 1.0,),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future openFile({required String url, required String fileName}) async {
    final name = fileName;
    final file = await downloadFile(url,name);

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

    final appStorage = await getApplicationDocumentsDirectory();
    final file = File('${appStorage.path}/$name');

    try {
      final response = await foo.Dio().get(
          url,
          options: foo.Options(
            responseType: foo.ResponseType.bytes,
            followRedirects: false,
            receiveTimeout: 0,
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
