import 'dart:convert';
import 'dart:io';
import 'package:digipath_ircs/Design/ContainerDecoration.dart';
import 'package:digipath_ircs/Design/GlobalAppBar.dart';
import 'package:digipath_ircs/Global/Colors.dart';
import 'package:digipath_ircs/Global/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path_provider/path_provider.dart';
import '../Design/BorderContainer.dart';
import '../Design/TopPageTextViews.dart';
import '../Global/Toast.dart';
import '../ModalClass/SubPreviousPrescriptionModel.dart';
import '../ModalClass/citizenCurrentPrescriptionModel.dart';
import 'package:http/http.dart' as http;

class PrescriptionPage extends StatefulWidget {
  const PrescriptionPage({Key? key}) : super(key: key);

  @override
  State<PrescriptionPage> createState() => _PrescriptionPageState();
}

class _PrescriptionPageState extends State<PrescriptionPage> {
  late citizenCurrentPrescriptionModel citizenCurrentPrescription;
  late SubPreviousPrescriptionModel subPreviousPrescription;
  bool serching = true;

  @override
  void initState() {
    super.initState();
    EasyLoading.show(status: 'Loading...');
    getCurrentPrescription();
  }

  void getCurrentPrescription() async {
    final response = await http.get(
        Uri.parse(
            '$urlForINSC/citizenCurrentPrescription.shc?CitizenID=1081787'),
        headers: {
          "token": token
        });

    if (response.statusCode == 200) {
      citizenCurrentPrescription =
          citizenCurrentPrescriptionModel.fromJson(jsonDecode(response.body));
      getSubPreviousPrescription();
    } else {
      throw Exception('Failed to load Prescription');
    }
  }

  void getSubPreviousPrescription() async {
    final response = await http.get(
        Uri.parse(
            '$urlForINSC/displaySubTablednvPreviousPrescription.shc?EncounterID=1339530'),
        headers: {
          "token": token
        });

    if (response.statusCode == 200) {
      EasyLoading.dismiss();
      subPreviousPrescription =
          SubPreviousPrescriptionModel.fromJson(jsonDecode(response.body));
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
      appBar: GlobalAppBar(context,'Prescription'),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: globalPageBackgroundColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TopPageTextViews('View Current Prescription'),
            serching? const Text("Searching...")
                :citizenCurrentPrescription.data?.length !=0 ?
            Container(
              margin: const EdgeInsets.fromLTRB(20, 15, 20, 5),
              padding: EdgeInsets.fromLTRB(35, 25, 35, 25),
              decoration: BorderContainer(Colors.white,globalBlue),
              child:Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.calendar_month,
                        color: globalBlue,
                        size: 23,
                      ),
                      const SizedBox(
                        width: 25,
                        height: 28,
                      ),
                      Text(
                        citizenCurrentPrescription
                            .data![0].PrescribedDate,
                        style: TextStyle(
                          fontSize: 16,
                          color: globalBlue,
                          fontWeight: FontWeight.w600,
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
                        image: AssetImage('assets/images/doctor.png'),
                        height: 23,
                        width: 23,
                        fit: BoxFit.fill,
                        color: globalBlue,
                      ),
                      SizedBox(
                        width: 25,
                        height: 28,
                      ),
                      Flexible(
                        child: Text(
                          'Dr. ${citizenCurrentPrescription.data![0].DoctorName} (${citizenCurrentPrescription.data![0].FacultyName})',
                          style: TextStyle(
                            fontSize: 16,
                            color: globalBlue,
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
                        image: AssetImage('assets/images/doctor.png'),
                        height: 23,
                        width: 23,
                        fit: BoxFit.fill,
                        color: globalBlue,
                      ),
                      SizedBox(
                        width: 25,
                        height: 28,
                      ),
                      Flexible(
                        child: Text(
                          citizenCurrentPrescription.data![0].CareProviderName,
                          style: TextStyle(
                            fontSize: 16,
                            color: globalBlue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 12,
                  ),
                  Divider(
                    thickness: 1,
                    height: 2,
                    color: globalBlue,
                  ),
                ],
              ),
            ) : Text('No Data Found'),
            serching? SizedBox()
                : citizenCurrentPrescription.data?.length !=0 ?Container(
              margin: EdgeInsets.fromLTRB(20, 5, 20, 25),
              padding: EdgeInsets.fromLTRB(0, 20, 0, 25),
              decoration: BorderContainer(Colors.white, globalBlue),
              child: Container(
                padding: EdgeInsets.fromLTRB(35, 5, 35, 5),
                child: Column(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 10,
                    ),
                    Divider(
                      thickness: 1,
                      height: 2,
                      color: globalBlue,
                    ),
                    Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  'Prescription Details',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ],
                            ),
                            InkWell(
                                onTap: (){
                                  EasyLoading.show(status: 'Loading...');
                                  openFile(
                                    url:
                                    '$urlForINSC/OpenPrescriptionContinuedWithInstruction_citizen.do?ptype=2&ptype=1&frmIsLetterHeadOption=0&'
                                        'frmIsGenericReportOption=false&frmLanguage=0&frmIsWithInstruction=false&frmCitizenID=1081787',
                                    fileName: 'prescription.pdf',
                                  );
                                },
                                child: Icon(Icons.download)
                            )
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
                                citizenCurrentPrescription
                                    .data![0].PrescribedDate,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
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
                                'Dr. ${citizenCurrentPrescription.data![0].DoctorName} (${citizenCurrentPrescription.data![0].FacultyName})',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 5,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                          decoration: BoxDecoration(
                            border: Border.all(),
                          ),
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding:
                                EdgeInsets.fromLTRB(5, 0, 0, 0),
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Medicine Name',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      'Centent',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Expanded(
                                          flex: 2,
                                          child: Text('Dosage'),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Text('Days'),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Text('Qty'),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      'Dosage Info',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width:
                                MediaQuery.of(context).size.width,
                                height: 5,
                              ),
                              Divider(
                                thickness: 2,
                                height: 2,
                                color: Colors.black54,
                              ),
                              SizedBox(
                                width:
                                MediaQuery.of(context).size.width,
                                height: 3,
                              ),
                              ListView.builder(
                                itemCount:
                                subPreviousPrescription.data.length,
                                shrinkWrap: true,
                                itemBuilder:
                                    (BuildContext context, int index) {
                                  return Container(
                                    padding:
                                    EdgeInsets.fromLTRB(5, 0, 5, 0),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          subPreviousPrescription
                                              .data[index].drugName,
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          subPreviousPrescription
                                              .data[index].contentName,
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Divider(
                                          thickness: 1,
                                          height: 2,
                                          color: Colors.black54,
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Expanded(
                                              flex: 2,
                                              child: Text(
                                                subPreviousPrescription
                                                    .data[index].dosage,
                                              ),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Text(
                                                subPreviousPrescription
                                                    .data[index]
                                                    .dosageDays,
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Text(
                                                subPreviousPrescription
                                                    .data[index]
                                                    .dosageQty,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          subPreviousPrescription
                                              .data[index]
                                              .dosageInfoEng,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              )
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ) : SizedBox(height: 0,width: 0,),
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
      final response = await get(
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