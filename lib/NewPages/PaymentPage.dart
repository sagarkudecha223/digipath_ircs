import 'dart:convert';
import 'package:digipath_ircs/Design/ColorFillContainer.dart';
import 'package:digipath_ircs/Global/Toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/route_manager.dart';
import 'package:http/http.dart';
import '../Design/GlobalAppBar.dart';
import '../Design/TopPageTextViews.dart';
import '../Global/global.dart';
import '../ModalClass/PaymentModal.dart';
import '../PathologyPages/WebViewPage.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({Key? key}) : super(key: key);

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {

  bool noDataText = true;
  String noDataTextString = 'Searching...';
  List<PaymentModal> paymentList = <PaymentModal>[];

  @override
  void initState() {
    super.initState();
    getPaymentList();
  }

  void getPaymentList() async{

    EasyLoading.show(status: 'Searching...');

    try{
      Response response = await post(
        Uri.parse('https://medicodb.in/getCitizenPaymentHistory.do?citizenID=1028107'),
      );

      EasyLoading.dismiss();

      if (response.statusCode == 200) {
        var status = jsonDecode(response.body.toString());
        List<dynamic> statusinfo = status['pendingPaymentList'];

        if(statusinfo.isNotEmpty){
          for(int i=0; i<statusinfo.length; i++){
            String encounterIDP = statusinfo[i]['encounterIDP'].toString();
            String purposeType = statusinfo[i]['purposeType'].toString();
            String encounterDate = statusinfo[i]['encounterDate'].toString();
            String amount = statusinfo[i]['amount'].toString();

            paymentList.add(PaymentModal(encounterIDP: encounterIDP,purposeType:purposeType, encounterDate: encounterDate, amount: amount));
          }
        }

        if(paymentList.isNotEmpty){
          noDataText = false;
        }else{
          noDataText = true;
          noDataTextString = 'No Pending Payment Found';
        }

        setState(() {

        });

      }
      else{
        showToast('Sorry !!! Server Error');
      }
    }
    catch(e){
      EasyLoading.dismiss();
      showToast('Sorry !!! Server error');
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GlobalAppBar(context),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.indigo.shade100,
        child: Column(
          children: [
            TopPageTextViews('Pending Payment List','pay your pending payment'),
            noDataText?Container(
              width: double.infinity,
              margin: EdgeInsets.all(25),
              decoration: ColorFillContainer(Colors.white),
              padding: EdgeInsets.all(15),
                child: Text(noDataTextString,style:const TextStyle(fontSize: 15,fontWeight: FontWeight.bold),textAlign: TextAlign.center)) :
            Flexible(
                child: ListView.builder(
                    itemCount: paymentList.length,
                    itemBuilder: (context, index) {
                      return Container(
                        padding: EdgeInsets.all(15),
                        margin: EdgeInsets.only(left: 20,right: 20,bottom: 3,top: 5),
                        width: double.infinity,
                        decoration: ColorFillContainer(Colors.white),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment : CrossAxisAlignment.start,
                                children: [
                                  Text('Date : ${paymentList[index].encounterDate}',style: TextStyle(color: Colors.grey.shade800,fontWeight: FontWeight.w600,fontSize: 15),),
                                  SizedBox(height: 5,),
                                  Text('Purpose type : ${paymentList[index].purposeType}',style: TextStyle(color: Colors.grey.shade800,fontWeight: FontWeight.w600,fontSize: 15),),
                                  SizedBox(height: 5,),
                                  Text('Amount : ${paymentList[index].amount}',style: TextStyle(color: Colors.grey.shade800,fontWeight: FontWeight.w600,fontSize: 15),),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap : (){
                                String encounterID = paymentList[index].encounterIDP;
                                String url = 'https://medicodb.in/CCAvenuePopUp_Android.do?encounterid=$encounterID&callFrom=android&APIFor=redcross&mobileNo=$localMobileNum';
                                Get.to(WebViewPage(url: url,));
                              },
                              child: Container(
                                decoration: ColorFillContainer(Colors.indigo.shade500),
                                padding : EdgeInsets.all(15),
                                child: const Text('PAY',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600,fontSize: 15),),
                              ),
                            )
                          ],
                        ),
                      );
                    }
                )
            )
          ],
        ),
      ),
    );
  }
}
