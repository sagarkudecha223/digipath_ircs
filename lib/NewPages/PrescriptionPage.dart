import 'dart:convert';
import 'package:digipath_ircs/Design/ContainerDecoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import '../Design/TopPageTextViews.dart';
import '../HomePage.dart';
import '../ModalClass/SubPreviousPrescriptionModel.dart';
import '../ModalClass/citizenCurrentPrescriptionModel.dart';
import 'package:http/http.dart' as http;

class PrescriptionPage extends StatefulWidget {
  PrescriptionPage({super.key});

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
            'https://smarthealth.care/citizenCurrentPrescription.shc?CitizenID=1081787'),
        headers: {
          "token":
          "eyJhbGciOiJSUzI1NiJ9.eyJ1bmFtZSI6IjI2MDk3MTQ1NDA5MSIsInNlc3Npb25pZCI6IkQyN0I4QTBBQzNERjZCQzlEQUEwNUU2NTlDODk2NTk1Iiwic3ViIjoiSldUX1RPS0VOIiwianRpIjoiNWQxYWU3ZmYtMzJhOC00YWYxLWE4OTItODE1MWRiMDRlNzE3IiwiaWF0IjoxNjc4MTcyMTQzfQ.J4pK2XBzMaZNlgGAFxB1yFLUJoWKhzqHBKJbZfxwau7aBhMyb1ovWevVVgHQR5DsKJUhPbedNnhqvSOdLNO6uWn2qEwlGVpsslDCz1oftzA3NymnUF5xRoYoTkqjcM_3Raw6sVST9jAlw0hKmS_1tVJKBWdI1754FC-1o2qZ0mPOn-AT_1DGhWkFg88FRdtZAD2Zb7NUJ0vmvVlXzvkvhFEZsb-NksM4neAtWozUGqV-ZQ23JI21QDEZIC6Xj3khEJqNwVxNUrXH6CAdDU2QiDc7RJ6aN9HdqEdRvUSnvjA88qjBtQeNgp88rMMQ5g36WlzO0vQO4uO-Ek4pax9rpg"
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
            'https://smarthealth.care/displaySubTablednvPreviousPrescription.shc?EncounterID=1339530'),
        headers: {
          "token":
          "eyJhbGciOiJSUzI1NiJ9.eyJ1bmFtZSI6IjI2MDk3MTQ1NDA5MSIsInNlc3Npb25pZCI6IkQyN0I4QTBBQzNERjZCQzlEQUEwNUU2NTlDODk2NTk1Iiwic3ViIjoiSldUX1RPS0VOIiwianRpIjoiNWQxYWU3ZmYtMzJhOC00YWYxLWE4OTItODE1MWRiMDRlNzE3IiwiaWF0IjoxNjc4MTcyMTQzfQ.J4pK2XBzMaZNlgGAFxB1yFLUJoWKhzqHBKJbZfxwau7aBhMyb1ovWevVVgHQR5DsKJUhPbedNnhqvSOdLNO6uWn2qEwlGVpsslDCz1oftzA3NymnUF5xRoYoTkqjcM_3Raw6sVST9jAlw0hKmS_1tVJKBWdI1754FC-1o2qZ0mPOn-AT_1DGhWkFg88FRdtZAD2Zb7NUJ0vmvVlXzvkvhFEZsb-NksM4neAtWozUGqV-ZQ23JI21QDEZIC6Xj3khEJqNwVxNUrXH6CAdDU2QiDc7RJ6aN9HdqEdRvUSnvjA88qjBtQeNgp88rMMQ5g36WlzO0vQO4uO-Ek4pax9rpg"
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
    return WillPopScope(
      onWillPop: () async {
        Get.offAll(HomePage());
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.indigo[100],
          leading: InkWell(
              onTap: () {
                Get.offAll(
                  HomePage(),
                );
              },
              child: Icon(Icons.arrow_back_rounded, color: Colors.indigo[900])),
          actions: [
            IconButton(
              icon: Icon(
                Icons.home,
                color: Colors.indigo[900],
              ),
              onPressed: () {
                Get.offAll(
                  HomePage(),
                );
              },
            )
          ],
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.indigo[100],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TopPageTextViews('Presciprtion', 'View Current Presciprtion'),
              Container(
                margin: EdgeInsets.fromLTRB(20, 25, 20, 5),
                decoration: ContainerDecoration(15),
                child: Container(
                  padding: EdgeInsets.fromLTRB(35, 25, 35, 25),
                  child: serching
                      ? const Text("Searching...")
                      : Column(
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
                          Text(
                            citizenCurrentPrescription
                                .data![0].PrescribedDate,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
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
                              '${citizenCurrentPrescription.data![0].CareProviderName}',
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
                        height: 12,
                      ),
                      Divider(
                        thickness: 2,
                        height: 2,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(20, 5, 20, 25),
                padding: EdgeInsets.fromLTRB(0, 0, 0, 25),
                decoration: ContainerDecoration(15),
                child: serching
                    ? const SizedBox(
                  height: 1,
                )
                    : Container(
                  padding: EdgeInsets.fromLTRB(35, 5, 35, 5),
                  child: Column(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 10,
                      ),
                      Divider(
                        thickness: 2,
                        height: 2,
                        color: Colors.grey,
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
                              Icon(
                                Icons.calendar_month,
                                // height: 20,
                                // width: 20,
                                color: Colors.grey,
                                size: 20,
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
                                            style: TextStyle(
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}