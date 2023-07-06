import 'dart:convert';
import 'dart:io';
import 'package:digipath_ircs/Design/GlobalAppBar.dart';
import 'package:digipath_ircs/Global/Colors.dart';
import 'package:digipath_ircs/Global/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path_provider/path_provider.dart';
import '../Design/BorderContainer.dart';
import '../Design/TopPageTextViews.dart';
import '../Global/Toast.dart';
import '../ModalClass/PatientOrderSetbyCitizeModel.dart';

class OrderedInvestigation extends StatefulWidget {
  const OrderedInvestigation({Key? key}) : super(key: key);

  @override
  State<OrderedInvestigation> createState() => OrderedInvestigationState();
}

class OrderedInvestigationState extends State<OrderedInvestigation> {

  List<PatientOrderSetbyCitizeModel> patientOrderSetByCitizenList = <PatientOrderSetbyCitizeModel>[];
  List<Service> serviceList = <Service>[];
  String noDataTextString = 'Searching...';
  bool searching = true;

  @override
  void initState() {
    super.initState();

    EasyLoading.show(status: 'Loading...');
    getPatientOrderSetbyCitizen();
  }

  void getPatientOrderSetbyCitizen() async {
    final response = await http.get(
        Uri.parse(
            '$urlForINSC/getPatientOrderSet_byCitizen.shc?citizenID=$localCitizenIDP'),
        headers: {
          "token": token
        });

    EasyLoading.dismiss();

    if (response.statusCode == 200) {

      var status = jsonDecode(response.body.toString());
      List<dynamic> statusinfo = status['data'];

      if ((statusinfo.isNotEmpty)) {
        for (int i = 0; i < statusinfo.length; i++) {
          String EncounterIDF = statusinfo[i]['EncounterIDF'].toString();
          String EncounterDate = statusinfo[i]['EncounterDate'].toString();
          String EncounterNumber = statusinfo[i]['EncounterNumber'].toString();
          String CareProfessionalIDP = statusinfo[i]['CareProfessionalIDP'].toString();
          String DoctorName = statusinfo[i]['DoctorName'].toString();
          String CitizenIDP = statusinfo[i]['CitizenIDP'].toString();
          String CareProviderIDP = statusinfo[i]['CareProviderIDP'].toString();
          String CareProviderName = statusinfo[i]['CareProviderName'].toString();
          String SpecialityType = statusinfo[i]['SpecialityType'].toString();
          List<dynamic> serviceData = statusinfo[i]['service'];

          for (int j = 0; j < serviceData.length; j++) {
            String patientOrderSetIDP = serviceData[j]['PatientOrderSetIDP'].toString();
            String orderDate = serviceData[j]['OrderDate'].toString();
            String ServiceIDF = serviceData[j]['ServiceIDF'].toString();
            String ServiceName = serviceData[j]['ServiceName'].toString();
            String Remarks = serviceData[j]['Remarks'].toString();

            serviceList.add(Service(patientOrderSetIDP: patientOrderSetIDP,
                orderDate: orderDate,
                serviceIDF: ServiceIDF,
                serviceName: ServiceName,
                remarks: Remarks));
          }

          patientOrderSetByCitizenList.add(PatientOrderSetbyCitizeModel(
              encounterIDF: EncounterIDF,
              encounterDate: EncounterDate,
              encounterNumber: EncounterNumber,
              careProfessionalIDP: CareProfessionalIDP,
              doctorName: DoctorName,
              citizenIDP: CitizenIDP,
              careProviderIDP: CareProviderIDP,
              careProviderName: CareProviderName,
              specialityType: SpecialityType));
        }

        setState(() {
          searching = false;
        });

      }else{
        if(mounted){
          setState(() {
            searching = true;
            noDataTextString ='Sorry No data found !!!';
          });
        }
     }
    } else {
      EasyLoading.dismiss();
      if(mounted){
        setState(() {
          noDataTextString ='Failed to load Prescription';
        });
      }
      throw Exception('Failed to load Prescription');
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
      appBar: GlobalAppBar(context,'Ordered Investigation'),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: globalPageBackgroundColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TopPageTextViews('List of Ordered Investigation'),
            if (searching)
              Text(noDataTextString)
            else
              patientOrderSetByCitizenList.isNotEmpty?Container(
                margin: const EdgeInsets.fromLTRB(20, 15, 20, 5),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: patientOrderSetByCitizenList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.fromLTRB(25, 15, 25, 15),
                      decoration: BorderContainer(Colors.white,globalBlue),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.calendar_month,
                                // height: 20,
                                // width: 20,
                                color: globalBlue,
                                size: 20,
                              ),
                              const SizedBox(
                                width: 25,
                                height: 28,
                              ),
                              Flexible(
                                child: Text(
                                  patientOrderSetByCitizenList[index].encounterDate,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: 5,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image(
                                image: const AssetImage('assets/images/doctor.png'),
                                height: 20,
                                width: 20,
                                fit: BoxFit.fill,
                                color: globalBlue,
                              ),
                              const SizedBox(
                                width: 25,
                                height: 28,
                              ),
                              Flexible(
                                child: Text(
                                  patientOrderSetByCitizenList[index].doctorName,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: 5,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.local_hospital_rounded,
                                color: globalBlue,
                                size: 23,
                              ),
                              const SizedBox(
                                width: 25,
                                height: 28,
                              ),
                              Flexible(
                                child: Text(
                                  patientOrderSetByCitizenList[index].careProviderName,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: 5,
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: ListView.builder(
                                  padding: const EdgeInsets.fromLTRB(35, 5, 0, 0),
                                  itemCount: serviceList.length,
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (BuildContext context,
                                      int insideindex) {
                                    return Container(
                                      padding: const EdgeInsets.only(bottom: 3),
                                      child: Row(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        children: [
                                          Icon(Icons.medical_services_outlined,size: 20,color: globalBlue,),
                                          const SizedBox(
                                            width: 25,
                                          ),
                                          Flexible(
                                            child: Text(
                                              serviceList[insideindex].serviceName,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                              InkWell(
                                child: Icon(Icons.download,color: globalBlue,),
                                onTap: () => {
                                  EasyLoading.show(status: 'Loading...'),
                                  openFile(
                                    url:
                                    '$urlForINSC/getPatientOrderSetReport_SmartHealthByEncounterID.do?ptype=0&txtStationary=false&txtID=${patientOrderSetByCitizenList[index].encounterIDF}&frmUserName=$localUserName',
                                    fileName: '${patientOrderSetByCitizenList[index].careProviderIDP}.pdf',
                                  )
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ) : const Text('No Data Found'),
          ],
        ),
      ),
    );
  }

  Future openFile({required String url, required String fileName}) async {
    print('Url :::::::: $url');
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
      final response = await http.get(
        Uri.parse(url),
      );

      final raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(response.bodyBytes);
      await raf.close();

      return file;
    }
    catch(e){
      return null;
    }
  }
}