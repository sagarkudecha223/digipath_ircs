import 'dart:convert';
import 'dart:io';
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
  String noDataTextString = 'Searching...';
  bool noDataText = true;

  @override
  void initState() {
    super.initState();
    EasyLoading.show(status: 'Loading...');
    getCurrentPrescription();
  }

  void getCurrentPrescription() async {
    final response = await http.get(
        Uri.parse('$urlForINSC/citizenCurrentPrescription.shc?CitizenID=$localCitizenIDP'),
        headers: {
          "token": token
        });

    if (response.statusCode == 200) {

      var status = jsonDecode(response.body.toString());
      List<dynamic> statusinfo = status['data'];
      if(statusinfo.isNotEmpty){

        citizenCurrentPrescription =citizenCurrentPrescriptionModel.fromJson(jsonDecode(response.body));
        getSubPreviousPrescription(citizenCurrentPrescription.data![0].EncounterID);

      }else{
        if(mounted){
          EasyLoading.dismiss();
          setState((){
            noDataTextString = 'No data found...';
            noDataText = true;
          });
        }
      }

    }
    else {
      if(mounted){
        EasyLoading.dismiss();
        setState((){
          noDataTextString = 'Failed to load Prescription...';
          noDataText = true;
        });
      }
      throw Exception('Failed to load Prescription');
    }
  }

  void getSubPreviousPrescription(String EncounterID) async {
    final response = await http.get(
        Uri.parse('$urlForINSC/displaySubTablednvPreviousPrescription.shc?EncounterID=$EncounterID'),
        headers: {
          "token": token
        });

    EasyLoading.dismiss();

    if (response.statusCode == 200) {

      subPreviousPrescription = SubPreviousPrescriptionModel.fromJson(jsonDecode(response.body));
      if(mounted){
        setState(() {
          serching = false;
        });
      }
    }
    else {
      if(mounted){
        EasyLoading.dismiss();
        setState((){
          noDataTextString = 'Failed to load Prescription...';
          noDataText = true;
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
      appBar: GlobalAppBar(context,'Prescription'),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: globalPageBackgroundColor,
        child: Column(
          children: [
            TopPageTextViews('View Current Prescription'),
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    serching? Text(noDataTextString)
                        :citizenCurrentPrescription.data?.length !=0 ?
                    Container(
                      margin: const EdgeInsets.fromLTRB(20, 15, 20, 5),
                      padding: const EdgeInsets.fromLTRB(35, 25, 35, 25),
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
                                image: const AssetImage('assets/images/doctor.png'),
                                height: 23,
                                width: 23,
                                fit: BoxFit.fill,
                                color: globalBlue,
                              ),
                              const SizedBox(
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
                              Icon(
                                Icons.local_hospital_rounded,
                                color: globalBlue,
                                size: 23,
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
                    ) : Text(noDataTextString),
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
                                      children: const [
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
                                                'frmIsGenericReportOption=false&frmLanguage=0&frmIsWithInstruction=false&frmCitizenID=$localCitizenIDP',
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
                                    const Icon(
                                      Icons.calendar_month,
                                      // height: 20,
                                      // width: 20,
                                      color: Colors.grey,
                                      size: 20,
                                    ),
                                    const SizedBox(
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
                                        itemCount: subPreviousPrescription.data.length,
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
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
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                Text(
                                                  subPreviousPrescription
                                                      .data[index].contentName,
                                                  style: const TextStyle(
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