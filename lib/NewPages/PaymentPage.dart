import 'dart:convert';
import 'package:digipath_ircs/Design/ColorFillContainer.dart';
import 'package:digipath_ircs/Global/Colors.dart';
import 'package:digipath_ircs/Global/Toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/route_manager.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import '../Book Appointment/PathologyPages/WebViewPage.dart';
import '../Design/BorderContainer.dart';
import '../Design/GlobalAppBar.dart';
import '../Design/TopPageTextViews.dart';
import '../Global/global.dart';
import '../ModalClass/PaymentModal.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({Key? key}) : super(key: key);

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {

  bool noDataText = true;
  String noDataTextString = 'Searching...';
  List<PaymentModal> paymentList = <PaymentModal>[];
  late DateTime currentTime;
  bool isPay = false;

  @override
  void initState() {
    super.initState();
    getSeverTime();
  }

  void getSeverTime() async {

    EasyLoading.show(status: 'Searching...');

    try {
      Response response = await get(Uri.parse('https://smarthealth.care/getServerDateTime.notauth'));

      if (response.statusCode == 200) {
        var status = jsonDecode(response.body.toString());

        String Time = status['Date1'].toString();
        currentTime = DateFormat('dd-MMM-yyyy H:m').parse(Time);
        print('currentTime :: $currentTime');

        getPaymentList();

      }else{
          EasyLoading.dismiss();
          showToast('Connection Error !! Try again');
      }
    }
    catch(e){
      EasyLoading.dismiss();
      showToast(e.toString());
    }
  }

  void getPaymentList() async{

    paymentList.clear();

    print('$urlForINSC/getCitizenPaymentHistory.do?citizenID=$localCitizenIDP');

    try{
      Response response = await post(
        Uri.parse('$urlForINSC/getCitizenPaymentHistory.do?citizenID=$localCitizenIDP'),
      );

      if (response.statusCode == 200) {
        var status = jsonDecode(response.body.toString());
        List<dynamic> statusinfo = status['pendingPaymentList'];

        if(statusinfo.isNotEmpty){
          for(int i=0; i<statusinfo.length; i++){
            String encounterIDP = statusinfo[i]['encounterIDP'].toString();
            String purposeType = statusinfo[i]['purposeType'].toString();
            String encounterDate = statusinfo[i]['encounterDate'].toString();
            String amount = statusinfo[i]['amount'].toString();
            String collecationTime = statusinfo[i]['collecationTime'].toString();
            String StartTimeSlot = statusinfo[i]['StartTimeSlot'].toString();
            String date = statusinfo[i]['date'].toString();

            if(purposeType == 'Tele Consultation'){

              DateTime paymentTime = DateFormat('dd-MMM-yyyy H:m').parse(date);
              print('Tele Consultation:: $paymentTime');
              encounterDate = date;
              if(paymentTime.isAfter(currentTime)){
                isPay = true;
              }
              else{
                isPay = false;
              }
            }
            else{

              StartTimeSlot = StartTimeSlot.replaceAll('.', '');
              var appointmentTime = '$collecationTime $StartTimeSlot';
              DateTime paymentTime = DateFormat('dd-MMM-yyyy H:m').parse(appointmentTime);
              encounterDate = appointmentTime;
              if(paymentTime.isAfter(currentTime)){
                isPay = true;
              }
              else{
                isPay = false;
              }
            }

            paymentList.add(PaymentModal(encounterIDP: encounterIDP,purposeType:purposeType, encounterDate: encounterDate, amount: amount, collecationTime: collecationTime, StartTimeSlot: StartTimeSlot, isPay: isPay));
          }
          paymentList = paymentList.reversed.toList();
        }

        if(paymentList.isNotEmpty){
          noDataText = false;
        }else{
          noDataText = true;
          noDataTextString = 'No Pending Payment Found';
        }
        setState(() {
          EasyLoading.dismiss();
        });
      }
      else{
        EasyLoading.dismiss();
        setState(() {
          noDataText = true;
          noDataTextString = 'Sorry !!! Server Error';
        });
        showToast('Sorry !!! Server Error');
      }
    }
    catch(e){
      EasyLoading.dismiss();
      setState(() {
        noDataText = true;
        noDataTextString = 'Sorry !!! Server Error';
      });
      EasyLoading.dismiss();
      showToast('Sorry !!! Server error');
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
      appBar: GlobalAppBar(context, 'Pending Payment List'),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: globalPageBackgroundColor,
        child: Column(
          children: [
            TopPageTextViews('pay your pending payment',),
            noDataText?Container(
              width: double.infinity,
              margin: const EdgeInsets.all(25),
              decoration: ColorFillContainer(Colors.white),
              padding: const EdgeInsets.all(15),
                child: Text(noDataTextString,style:const TextStyle(fontSize: 15,fontWeight: FontWeight.bold),textAlign: TextAlign.center)) :
            Flexible(
                child: RefreshIndicator(
                  onRefresh: () {
                    return Future.delayed(const Duration(microseconds: 500),
                            () {
                          getPaymentList();
                        });
                  },
                  child: SingleChildScrollView(
                    child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: paymentList.length,
                        itemBuilder: (context, index) {
                          return Container(
                            padding: const EdgeInsets.all(15),
                            margin: const EdgeInsets.only(left: 20,right: 20,bottom: 3,top: 5),
                            width: double.infinity,
                            decoration: BorderContainer(Colors.white,globalBlue),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment : CrossAxisAlignment.start,
                                    children: [
                                      Text('Date : ${paymentList[index].encounterDate}',style: TextStyle(color: Colors.grey.shade800,fontWeight: FontWeight.w600,fontSize: 15),),
                                      const SizedBox(height: 5,),
                                      Text('Purpose type : ${paymentList[index].purposeType}',style: TextStyle(color: Colors.grey.shade800,fontWeight: FontWeight.w600,fontSize: 15),),
                                      const SizedBox(height: 5,),
                                      Text('Amount : ${paymentList[index].amount}',style: TextStyle(color: Colors.grey.shade800,fontWeight: FontWeight.w600,fontSize: 15),),
                                    ],
                                  ),
                                ),
                                Visibility(
                                  visible : paymentList[index].isPay,
                                  child: InkWell(
                                    onTap : (){
                                      String encounterID = paymentList[index].encounterIDP;
                                      String url = '$urlForIN/CCAvenuePopUp_Android.do?encounterid=$encounterID&callFrom=flutter&APIFor=redcross&mobileNo=$localMobileNum';
                                      Get.to(WebViewPage(url: url,));
                                    },
                                    child: Container(
                                      decoration: ColorFillContainer(const Color(0xFFF7AB39)),
                                      padding : const EdgeInsets.all(15),
                                      child: const Text('PAY',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600,fontSize: 15),),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
                        }
                    ),
                  ),
                )
            )
          ],
        ),
      ),
    );
  }
}
