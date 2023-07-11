import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import '../CardViews/ViewReportsCard.dart';
import '../Design/BorderContainer.dart';
import '../Design/GlobalAppBar.dart';
import '../Design/TopPageTextViews.dart';
import '../Global/Colors.dart';
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
  bool calenderView = true;

  String startDate =DateFormat('dd-MMM-yyyy').format(DateTime.now().subtract(const Duration(days: 15)));
  String endDate = DateFormat('dd-MMM-yyyy').format(DateTime.now());

  DateTime selectedStartDate = DateTime.now().subtract(const Duration(days: 15));
  DateTime selectedEndDate = DateTime.now();

  late int year;
  late int month;
  late int day;

  @override
  void initState() {
    super.initState();

    year = int.parse(startDate.substring(7, 11));
    month = int.parse(selectedStartDate.month.toString());
    day = int.parse(startDate.substring(0, 2));
    EasyLoading.show(status: 'Loading...');
    getReportsData(startDate,endDate);
  }

  void getReportsData(String startDated, endDated) async{

    searchReportList.clear();
    print('$urlForINSC/patientListForPathologyReport.do?requestFrom=patient&citizenID=$localCitizenIDP&startDate=$startDated&endDate=$endDated&careProviderID=4286');

    try{
      Response response = await get(                                                                     /// 1028107
          Uri.parse('$urlForINSC/patientListForPathologyReport.do?requestFrom=patient&citizenID=$localCitizenIDP&startDate=$startDated&endDate=$endDated&careProviderID=4286'),
      );

      EasyLoading.dismiss();

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
  }

  void _pickStartDateDialog() {
    showDatePicker(
        context: context,
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: Color(0xFF549DD6),
                onPrimary: Colors.white,
                onSurface: Colors.black,
              )
            ),
            child: child!,
          );
        },
        initialDate: selectedStartDate,
        firstDate: DateTime(1999),
        lastDate: DateTime.now())
        .then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        startDate = DateFormat('dd-MMM-yyyy').format(pickedDate);
        selectedStartDate = pickedDate;
        year = int.parse(startDate.substring(7, 11));
        month = int.parse(selectedStartDate.month.toString());
        day = int.parse(startDate.substring(0, 2));

        if(selectedStartDate.compareTo(selectedEndDate) > 0){
          selectedEndDate = DateTime.now();
          endDate =DateFormat('dd-MMM-yyyy').format(DateTime.now());
        }

      });
    });
  }

  void _pickEndDateDialog() {
    showDatePicker(
        context: context,
        initialDate: selectedEndDate,
        firstDate: DateTime(year,month,day),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: Color(0xFF549DD6),
                onPrimary: Colors.white,
                onSurface: Colors.black,
              )
            ),
            child: child!,
          );
        },
        lastDate: DateTime.now())
        .then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        endDate = DateFormat('dd-MMM-yyyy').format(pickedDate);
        selectedEndDate = pickedDate;
      });
    });
  }

  @override
  void dispose() {
    EasyLoading.dismiss();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GlobalAppBar(context,'View Reports'),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: globalPageBackgroundColor,
        child: Column(
          children: [
            TopPageTextViews('Can See Pathology Reports Here..'),
            Visibility(
              visible: calenderView,
              child: Container(
                padding: const EdgeInsets.all(5),
                margin: const EdgeInsets.only(left: 20,right: 20,bottom: 5),
                decoration: BorderContainer(Colors.grey.shade100,globalBlue),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 1,
                      child: InkWell(
                        onTap: _pickStartDateDialog,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 3),
                                child: Text('Start Date:'.toUpperCase(),textScaleFactor: 1.0,style: TextStyle(fontSize: 12,fontWeight: FontWeight.normal,color: globalBlue),),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 0),
                                child: Text(startDate,textScaleFactor: 1.0,
                                  style: const TextStyle(fontSize: 16,fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: InkWell(
                        onTap: _pickEndDateDialog,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 10, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 3),
                                child: Text('End Date:'.toUpperCase(),textScaleFactor: 1.0,style: TextStyle(fontSize: 12,fontWeight: FontWeight.normal,color:globalBlue),),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 0),
                                child: Text(endDate,textScaleFactor: 1.0,
                                  style: const TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(10, 0, 15, 0),
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          shape: BoxShape.circle
                      ),
                      child:InkWell(
                          onTap: (){
                            EasyLoading.show(status: 'Loading...');
                            getReportsData(startDate, endDate);
                          },
                          child: Icon(Icons.search,color:globalBlue)),
                    ),
                  ],
                ),
              ),
            ),
            noDataText? Text(noDataTextString,style:const TextStyle(fontSize: 15,fontWeight: FontWeight.bold),textAlign: TextAlign.center) :
            Flexible(
              child: RefreshIndicator(
                onRefresh: () {
                  return Future.delayed(const Duration(microseconds: 500),() {
                    startDate =DateFormat('dd-MMM-yyyy').format(DateTime.now().subtract(const Duration(days: 15)));
                    endDate = DateFormat('dd-MMM-yyyy').format(DateTime.now());
                    selectedStartDate = DateTime.now().subtract(const Duration(days: 15));
                    selectedEndDate = DateTime.now();
                    year = int.parse(startDate.substring(7, 11));
                    month = int.parse(selectedStartDate.month.toString());
                    day = int.parse(startDate.substring(0, 2));
                    EasyLoading.show(status: 'Loading...');
                    getReportsData(startDate,endDate);
                  });
                },
                child: SingleChildScrollView(
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: searchReportList.length,
                    itemBuilder: (context, index){
                      return ViewReportsCard(viewReportModal: searchReportList[index],);
                    }
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
