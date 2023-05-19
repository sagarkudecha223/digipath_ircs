import 'dart:convert';
import 'dart:io';
import 'package:digipath_ircs/Design/GlobalAppBar.dart';
import 'package:dio/dio.dart' as foo;
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path_provider/path_provider.dart';
import '../Design/ColorFillContainer.dart';
import '../Design/TopPageTextViews.dart';
import '../Global/Toast.dart';
import '../ModalClass/PaymentModal.dart';

class PaymentHistoryPage extends StatefulWidget {
  const PaymentHistoryPage({Key? key}) : super(key: key);

  @override
  State<PaymentHistoryPage> createState() => _PaymentHistoryPageState();
}

class _PaymentHistoryPageState extends State<PaymentHistoryPage> {

  bool noDataText = true;
  String noDataTextString = 'Searching...';
  List<PaidPaymentModal> paymentList = <PaidPaymentModal>[];

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
        List<dynamic> statusinfo = status['paidList'];

        if(statusinfo.isNotEmpty){
          for(int i=0; i<statusinfo.length; i++){
            String voucherIDP = statusinfo[i]['voucherIDP'].toString();
            String voucherTypeIDP = statusinfo[i]['voucherTypeIDP'].toString();
            String voucherDate = statusinfo[i]['voucherDate'].toString();
            String tDr = statusinfo[i]['tDr'].toString();
            String amount = statusinfo[i]['amount'].toString();
            String episodeID = statusinfo[i]['episodeID'].toString();
            String patientProfileID = statusinfo[i]['patientProfileID'].toString();

            paymentList.add(PaidPaymentModal(voucherIDP: voucherIDP, voucherTypeIDP: voucherTypeIDP, voucherDate: voucherDate,
                tDr: tDr, amount: amount, episodeID: episodeID, patientProfileID: patientProfileID));
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
            margin: const EdgeInsets.all(25),
            decoration: ColorFillContainer(Colors.white),
            padding: const EdgeInsets.all(15),
            child: Text(noDataTextString,style:const TextStyle(fontSize: 15,fontWeight: FontWeight.bold),textAlign: TextAlign.center)) :
            Flexible(
              child: ListView.builder(
              itemCount: paymentList.length,
              itemBuilder: (context, index) {
                return Container(
                  padding: const EdgeInsets.all(15),
                  margin: const EdgeInsets.only(left: 20,right: 20,bottom: 3,top: 5),
                  width: double.infinity,
                  decoration: ColorFillContainer(Colors.white),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment : CrossAxisAlignment.start,
                          children: [
                            Text('Date : ${paymentList[index].voucherDate}',style: TextStyle(color: Colors.grey.shade800,fontWeight: FontWeight.w600,fontSize: 15),),
                            const SizedBox(height: 5,),
                            Text('Dr. : ${paymentList[index].tDr}',style: TextStyle(color: Colors.grey.shade800,fontWeight: FontWeight.w600,fontSize: 15),),
                            const SizedBox(height: 5,),
                            Text('Amount : ${paymentList[index].amount}',style: TextStyle(color: Colors.grey.shade800,fontWeight: FontWeight.w600,fontSize: 15),),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap : (){
                          String episodeID = paymentList[index].episodeID;
                          String patientProfileID = paymentList[index].patientProfileID;
                          EasyLoading.show(status: 'Loading...');
                          openFile(
                            url: 'https://smarthealth.care/generatePatientVoucherOPD_android.do?patientProfileID=$patientProfileID&episodeID=$episodeID&loginID=10834&withStationary=YES',
                            fileName:'$patientProfileID.pdf',
                          );
                        },
                        child: Icon(Icons.download,size: 26,color: Colors.indigo.shade800,),
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

  Future openFile({required String url, required String fileName}) async {
    final name = fileName ?? url.split('/').last;
    final file = await downloadFile(url,name!);

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
      final response = await foo.Dio().get(
          url,
          options: foo.Options(
            responseType: foo.ResponseType.bytes,
            followRedirects: false,
            receiveTimeout: 0,
          )
      );

      final raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(response.data);
      await raf.close();

      return file;
    }
    catch(e){
      return null;
    }
  }

}
