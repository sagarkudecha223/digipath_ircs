import 'dart:convert';
import 'dart:io';
import 'package:digipath_ircs/Design/GlobalAppBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path_provider/path_provider.dart';
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

  bool serching = true;

  @override
  void initState() {
    super.initState();

    EasyLoading.show(status: 'Loading...');
    getPatientOrderSetbyCitizen();
  }

  void getPatientOrderSetbyCitizen() async {
    final response = await http.get(
        Uri.parse(
            'https://smarthealth.care/getPatientOrderSet_byCitizen.shc?citizenID=1081787'),
        headers: {
          "token":
          "eyJhbGciOiJSUzI1NiJ9.eyJ1bmFtZSI6IjI2MDk3MTQ1NDA5MSIsInNlc3Npb25pZCI6IkQyN0I4QTBBQzNERjZCQzlEQUEwNUU2NTlDODk2NTk1Iiwic3ViIjoiSldUX1RPS0VOIiwianRpIjoiNWQxYWU3ZmYtMzJhOC00YWYxLWE4OTItODE1MWRiMDRlNzE3IiwiaWF0IjoxNjc4MTcyMTQzfQ.J4pK2XBzMaZNlgGAFxB1yFLUJoWKhzqHBKJbZfxwau7aBhMyb1ovWevVVgHQR5DsKJUhPbedNnhqvSOdLNO6uWn2qEwlGVpsslDCz1oftzA3NymnUF5xRoYoTkqjcM_3Raw6sVST9jAlw0hKmS_1tVJKBWdI1754FC-1o2qZ0mPOn-AT_1DGhWkFg88FRdtZAD2Zb7NUJ0vmvVlXzvkvhFEZsb-NksM4neAtWozUGqV-ZQ23JI21QDEZIC6Xj3khEJqNwVxNUrXH6CAdDU2QiDc7RJ6aN9HdqEdRvUSnvjA88qjBtQeNgp88rMMQ5g36WlzO0vQO4uO-Ek4pax9rpg"
        });

    if (response.statusCode == 200) {
      patientOrderSetbyCitizeModel =
          PatientOrderSetbyCitizeModel.fromJson(jsonDecode(response.body));
      EasyLoading.dismiss();
      setState(() {
        serching = false;
      });
    } else {
      EasyLoading.dismiss();
      throw Exception('Failed to load Prescription');
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TopPageTextViews(
                'Ordered Investigation', 'List of Ordered Investigation'),
            if (serching)
              const Text('Searching')
            else
              Container(
                margin: EdgeInsets.fromLTRB(20, 25, 20, 5),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: patientOrderSetbyCitizeModel.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      decoration: ContainerDecoration(15),
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
                                  child: Icon(Icons.download),
                                  onTap: () => {
                                    EasyLoading.show(status: 'Loading...'),
                                    openFile(
                                      url:
                                      'https://smarthealth.care/getPatientOrderSetReport_SmartHealthByEncounterID.do?ptype=0&txtStationary=false&txtID=1339530&frmUserName=Rajendra  Vaniya',
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
              ),
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