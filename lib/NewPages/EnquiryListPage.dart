import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import '../Design/TopPageTextViews.dart';
import '../Global/global.dart';
import '../HomePage.dart';
import '../ModalClass/RequestByUserModel.dart';
import 'package:http/http.dart' as http;

class EnquiryListPage extends StatefulWidget {
  const EnquiryListPage({super.key});

  @override
  State<EnquiryListPage> createState() => EnquiryListPageState();
}

class EnquiryListPageState extends State<EnquiryListPage> {
  late RequestByUserModel requestByUserModel;
  bool serching = true;

  void getAllRequestByUser() async {
    final response = await http.get(
        Uri.parse(
            'https://smarthealth.care/getAllRequestByUser.shc?citizenID=$localCitizenIDP'),
        headers: {
          "token":
          "eyJhbGciOiJSUzI1NiJ9.eyJ1bmFtZSI6IjI2MDk3MTQ1NDA5MSIsInNlc3Npb25pZCI6IkQyN0I4QTBBQzNERjZCQzlEQUEwNUU2NTlDODk2NTk1Iiwic3ViIjoiSldUX1RPS0VOIiwianRpIjoiNWQxYWU3ZmYtMzJhOC00YWYxLWE4OTItODE1MWRiMDRlNzE3IiwiaWF0IjoxNjc4MTcyMTQzfQ.J4pK2XBzMaZNlgGAFxB1yFLUJoWKhzqHBKJbZfxwau7aBhMyb1ovWevVVgHQR5DsKJUhPbedNnhqvSOdLNO6uWn2qEwlGVpsslDCz1oftzA3NymnUF5xRoYoTkqjcM_3Raw6sVST9jAlw0hKmS_1tVJKBWdI1754FC-1o2qZ0mPOn-AT_1DGhWkFg88FRdtZAD2Zb7NUJ0vmvVlXzvkvhFEZsb-NksM4neAtWozUGqV-ZQ23JI21QDEZIC6Xj3khEJqNwVxNUrXH6CAdDU2QiDc7RJ6aN9HdqEdRvUSnvjA88qjBtQeNgp88rMMQ5g36WlzO0vQO4uO-Ek4pax9rpg"
        });

    if (response.statusCode == 200) {
      requestByUserModel =
          RequestByUserModel.fromJson(jsonDecode(response.body));
      EasyLoading.dismiss();
      setState(() {
        serching = false;
      });
    } else {
      EasyLoading.dismiss();
      throw Exception('Failed to load Request');
    }
  }

  @override
  void initState() {
    super.initState();

    EasyLoading.show(status: 'Loading...');
    getAllRequestByUser();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Get.offAll(HomePage());
          return false;
        },
        child: Scaffold(
          backgroundColor: Colors.indigo[100],
          appBar: AppBar(
            elevation: 0.0,
            backgroundColor: Colors.indigo[100],
            leading: InkWell(
                onTap: () {
                  Get.offAll(
                    HomePage(),
                  );
                },
                child:
                Icon(Icons.arrow_back_rounded, color: Colors.indigo[900])),
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
            child: Column(
              children: [
                TopPageTextViews('Enquiry List', 'Generated Enquiry List'),
                Container(
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.centerRight,
                  margin: EdgeInsets.fromLTRB(0, 0, 16, 0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blueAccent, // background
                      onPrimary: Colors.white, // foreground
                    ),
                    onPressed: () {},
                    child: Text(
                      'NEW ENQUIRY',
                    ),
                  ),
                ),
                if (serching)
                  Text('Searching')
                else
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: requestByUserModel.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        child: Column(
                          children: [
                            if (requestByUserModel.data[index].isClosed)
                              Text('Status:Close')
                            else
                              Text('Status:Close'),
                            Text(
                              'TYPE : ${requestByUserModel.data[index].enquiryType}',
                            ),
                            Text(
                              'MESSAGE : ${requestByUserModel.data[index].closedReason}',
                            ),
                          ],
                        ),
                      );
                    },
                  )
              ],
            ),
          ),
        ));
  }
}