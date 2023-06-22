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
import '../Design/ContainerDecoration.dart';
import '../Design/TopPageTextViews.dart';
import '../Global/Toast.dart';
import '../ModalClass/PatientOrderSetbyCitizeModel.dart';

class OrderedInvestigation extends StatefulWidget {
  const OrderedInvestigation({Key? key}) : super(key: key);

  @override
  State<OrderedInvestigation> createState() => OrderedInvestigationState();
}

class OrderedInvestigationState extends State<OrderedInvestigation> {
  late PatientOrderSetbyCitizeModel patientOrderSetbyCitizeModel;

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
            '$urlForINSC/getPatientOrderSet_byCitizen.shc?citizenID=1081787'),
        headers: {
          "token": token
        });

    if (response.statusCode == 200) {
      patientOrderSetbyCitizeModel =
          PatientOrderSetbyCitizeModel.fromJson(jsonDecode(response.body));
      EasyLoading.dismiss();
      setState(() {
        searching = false;
      });
    } else {
      EasyLoading.dismiss();
      throw Exception('Failed to load Prescription');
    }
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
              const Text('Searching')
            else
              patientOrderSetbyCitizeModel.data.length !=0 ?Container(
                margin: const EdgeInsets.fromLTRB(20, 15, 20, 5),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: patientOrderSetbyCitizeModel.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      decoration: BorderContainer(Colors.white,globalBlue),
                      child: Container(
                        padding: EdgeInsets.fromLTRB(25, 15, 25, 15),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.calendar_month,
                                  // height: 20,
                                  // width: 20,
                                  color: Colors.grey,
                                  size: 20,
                                ),
                                SizedBox(
                                  width: 25,
                                  height: 28,
                                ),
                                Flexible(
                                  child: Text(
                                    patientOrderSetbyCitizeModel
                                        .data[index].encounterDate,
                                    style: TextStyle(
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
                                  image: AssetImage(
                                      'assets/images/doctor.png'),
                                  height: 20,
                                  width: 20,
                                  fit: BoxFit.fill,
                                  color: Colors.grey,
                                ),
                                SizedBox(
                                  width: 25,
                                  height: 28,
                                ),
                                Flexible(
                                  child: Text(
                                    patientOrderSetbyCitizeModel
                                        .data[index].doctorName,
                                    style: TextStyle(
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
                                  image: AssetImage(
                                      'assets/images/doctor.png'),
                                  height: 20,
                                  width: 20,
                                  fit: BoxFit.fill,
                                  color: Colors.grey,
                                ),
                                SizedBox(
                                  width: 25,
                                  height: 28,
                                ),
                                Flexible(
                                  child: Text(
                                    patientOrderSetbyCitizeModel
                                        .data[index].careProviderName,
                                    style: TextStyle(
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
                                    padding:
                                    EdgeInsets.fromLTRB(35, 5, 0, 0),
                                    itemCount: patientOrderSetbyCitizeModel
                                        .data[index].service.length,
                                    shrinkWrap: true,
                                    itemBuilder: (BuildContext context,
                                        int insideindex) {
                                      return Container(
                                        padding: EdgeInsets.only(bottom: 3),
                                        child: Row(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          children: [
                                            Image(
                                              image: AssetImage(
                                                  'assets/images/doctor.png'),
                                              height: 20,
                                              width: 20,
                                              fit: BoxFit.fill,
                                              color: Colors.grey,
                                            ),
                                            SizedBox(
                                              width: 25,
                                            ),
                                            Flexible(
                                              child: Text(
                                                patientOrderSetbyCitizeModel
                                                    .data[index]
                                                    .service[insideindex]
                                                    .serviceName,
                                                style: TextStyle(
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
                                      '$urlForIN/getPatientOrderSetReport_SmartHealthByEncounterID.do?ptype=0&txtStationary=false&txtID=1339530&frmUserName=Rajendra  Vaniya',
                                      fileName: '${patientOrderSetbyCitizeModel.data[index].careProviderIDP}.pdf',
                                    )
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
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