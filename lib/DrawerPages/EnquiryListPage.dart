import 'dart:convert';
import 'package:digipath_ircs/Design/ColorFillContainer.dart';
import 'package:digipath_ircs/Design/GlobalAppBar.dart';
import 'package:digipath_ircs/Global/Colors.dart';
import 'package:digipath_ircs/Global/global.dart';
import 'package:digipath_ircs/DrawerPages/NewEnquiryPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import '../Design/ContainerDecoration.dart';
import '../Design/TopPageTextViews.dart';
import '../ModalClass/RequestByUserModel.dart';
import 'package:http/http.dart' as http;

class EnquiryListPage extends StatefulWidget {
  const EnquiryListPage({Key? key}) : super(key: key);

  @override
  State<EnquiryListPage> createState() => EnquiryListPageState();
}

class EnquiryListPageState extends State<EnquiryListPage> {
  late RequestByUserModel requestByUserModel;
  bool serching = true;

  void getAllRequestByUser() async {

    EasyLoading.show(status: 'Loading...');

    final response = await http.get(
        Uri.parse(
            '$urlForINSC/getAllRequestByUser.shc?citizenID=$localCitizenIDP'),
        headers: {
          "token": token
        });

    EasyLoading.dismiss();

    if (response.statusCode == 200) {
      requestByUserModel = RequestByUserModel.fromJson(jsonDecode(response.body));
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
    getAllRequestByUser();
  }

  @override
  void dispose() {
    EasyLoading.dismiss();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: globalPageBackgroundColor,
      appBar: GlobalAppBar(context,'Enquiry List'),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            TopPageTextViews('Generated Enquiry List'),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () async{
                    var data = await Get.to(NewEnquiryPage());
                    if(data == 'added'){
                      getAllRequestByUser();
                    }
                  },
                  child: Container(
                    decoration: ColorFillContainer(globalOrange),
                    margin: EdgeInsets.fromLTRB(0, 0, 26, 0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'NEW ENQUIRY',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                      ),
                    )
                  ),
                ),
              ],
            ),
            SizedBox(height: 2,),
            if (serching)
              Text('Searching')
            else
              requestByUserModel.data.length !=0 ?Flexible(
                child: RefreshIndicator(
                  onRefresh: () {
                    return Future.delayed(const Duration(microseconds: 500),
                            () {
                          getAllRequestByUser();
                        });
                  },
                  child: SingleChildScrollView(
                    physics: ClampingScrollPhysics(),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: requestByUserModel.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          margin: const EdgeInsets.fromLTRB(25, 5, 25, 5),
                          padding: const EdgeInsets.fromLTRB(15, 15, 10, 15),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 1.5,
                                  color: globalBlue
                              ),
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text( requestByUserModel.data[index].isClosed?'status: Close'.toUpperCase():'Status: OPEN'.toUpperCase(),
                                style: TextStyle(color: Colors.indigo.shade800,fontWeight: FontWeight.bold,fontSize: 15),),
                              SizedBox(height: 3,),
                              Text(
                                  'TYPE : ${requestByUserModel.data[index].enquiryType}',
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14)),
                              SizedBox(height: 3,),
                              Text(
                                  'MESSAGE : ${requestByUserModel.data[index].enquiryText}',
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14)),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ) : Text('No Data Found')
          ],
        ),
      ),
    );
  }
}