import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../CardViews/ViewReportsCard.dart';
import '../Design/GlobalAppBar.dart';
import '../Design/TopPageTextViews.dart';
import '../Global/SearchAPI.dart';
import '../Global/Toast.dart';
import '../Global/global.dart';
import 'package:http/http.dart';
import '../ModalClass/ViewReportsModal.dart';
import 'dart:convert';

class ViewReportPage extends StatefulWidget {
  const ViewReportPage({Key? key}) : super(key: key);

  @override
  State<ViewReportPage> createState() => _ViewReportPageState();
}

class _ViewReportPageState extends State<ViewReportPage> {

  List<ViewReportModal> searchReportList =  <ViewReportModal>[];
  bool noDataText = true;
  String noDataTextString = 'Searching...';

  @override
  void initState() {
    super.initState();
    EasyLoading.show(status: 'Loading...');
    getReportsData();
  }

  void getReportsData() async{

    searchReportList.clear();

    try{
      Response response = await get(                                                                     /// 1028107
          Uri.parse('https://medicodb.in/patientListForPathologyReport.do?requestFrom=patient&citizenID=1028107&startDate=01-April-2023&endDate=14-April-2023&careProviderID=4286'),
      );

      if (response.statusCode == 200) {
        var status = jsonDecode(response.body.toString());
        List<dynamic> statusinfo = status['data'];

        if(statusinfo.isNotEmpty) {
          for (int i = 0; i < statusinfo.length; i++) {
            String ServiceName = statusinfo[i]["serviceAlias"].toString();
            String OnSetDate = statusinfo[i]["onSetDate"].toString();
            String ReportStatus = statusinfo[i]["reportStatus"].toString();
            String ServiceMapIDP = statusinfo[i]["serviceMapIDF"].toString();
            String EncounterServiceIDP = statusinfo[i]["encounterServiceIDP"].toString();
            String CitizenIDF = statusinfo[i]["citizenIDF"].toString();
            String EncounterServiceNumber = statusinfo[i]["encounterServiceNumber"].toString();

            searchReportList.add(ViewReportModal(
              ServiceName: ServiceName,OnSetDate: OnSetDate, ReportStatus: ReportStatus,
              ServiceMapIDP: ServiceMapIDP, EncounterServiceIDP: EncounterServiceIDP,CitizenIDF: CitizenIDF,
              EncounterServiceNumber: EncounterServiceNumber,));
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
      }else{
        if(mounted){
          setState(() {
            noDataText = true;
            noDataTextString = 'Sorry !!! Server Error';
            EasyLoading.dismiss();
            showToast('Sorry !!! Server Error');
          });
        }
      }
    }catch(e){
      if(mounted){
        EasyLoading.dismiss();
        showToast(e.toString());
      }
    }

    // dynamic status = await searchAPI(false ,'https://medicodb.in/patientListForPathologyReport.do?requestFrom=patient&citizenID=1028107&startDate=01-April-2023&endDate=14-April-2023&careProviderID=4286',
    //     {},{}, 25);
    //
    // print(' status after responce: $status');
    // EasyLoading.dismiss();
    //
    // if(status.toString() != 'Sorry !!! Server Error' || status.toString().isNotEmpty){
    //   List<dynamic> statusinfo = status['data'];
    //
    //   if(!(statusinfo == null)) {
    //     for (int i = 0; i < statusinfo.length; i++) {
    //       String ServiceName = statusinfo[i]["serviceAlias"].toString();
    //       String OnSetDate = statusinfo[i]["onSetDate"].toString();
    //       String ReportStatus = statusinfo[i]["reportStatus"].toString();
    //       String ServiceMapIDP = statusinfo[i]["serviceMapIDF"].toString();
    //       String EncounterServiceIDP = statusinfo[i]["encounterServiceIDP"].toString();
    //       String  CitizenIDF = statusinfo[i]["citizenIDF"].toString();
    //       String EncounterServiceNumber = statusinfo[i]["encounterServiceNumber"].toString();
    //
    //       searchReportList.add(ViewReportModal(
    //         ServiceName: ServiceName,OnSetDate: OnSetDate, ReportStatus: ReportStatus,
    //         ServiceMapIDP: ServiceMapIDP, EncounterServiceIDP: EncounterServiceIDP,CitizenIDF: CitizenIDF,
    //         EncounterServiceNumber: EncounterServiceNumber,));
    //     }
    //
    //     setState(() {
    //       EasyLoading.dismiss();
    //     });
    //   }
    //   else{
    //     setState(() {
    //       noDataText = true;
    //       noDataTextString = 'No matching data found';
    //       EasyLoading.dismiss();
    //       showToast('Sorry ! No matching data found');
    //     });
    //   }
    // }
    // else{
    //   setState(() {
    //     EasyLoading.dismiss();
    //     noDataText = true;
    //     noDataTextString = 'Sorry !!! Server Error';
    //     showToast('Sorry !!! Server Error');
    //   });
    // }
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
            TopPageTextViews('View Reports','Can See Pathology Reports Here..'),
            noDataText? Text(noDataTextString,style:const TextStyle(fontSize: 15,fontWeight: FontWeight.bold),textAlign: TextAlign.center) :
            Flexible(
              child: RefreshIndicator(
                onRefresh: () {
                  return Future.delayed(Duration(microseconds: 500),
                          () {
                        EasyLoading.show(status: 'Loading...');
                        getReportsData();
                      });
                },
                child: SingleChildScrollView(
                  child: Column(
                    children: searchReportList.map((key) => ViewReportsCard(viewReportModal:key)).toList(),
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
