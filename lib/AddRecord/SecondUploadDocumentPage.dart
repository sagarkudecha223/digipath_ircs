import 'dart:convert';
import 'dart:io';
import 'package:digipath_ircs/Design/ColorFillContainer.dart';
import 'package:digipath_ircs/Design/GlobalAppBar.dart';
import 'package:digipath_ircs/Global/Colors.dart';
import 'package:digipath_ircs/Global/Toast.dart';
import 'package:digipath_ircs/Global/global.dart';
import 'package:digipath_ircs/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/route_manager.dart';
import 'package:get/utils.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import '../Design/BorderContainer.dart';
import 'CommonSearchPage.dart';

class SecondUploadDocumentPage extends StatefulWidget {
  final File filePath;
  const SecondUploadDocumentPage({Key? key, required this.filePath}) : super(key: key);

  @override
  State<SecondUploadDocumentPage> createState() => _SecondUploadDocumentPageState(filePath);
}
class _SecondUploadDocumentPageState extends State<SecondUploadDocumentPage> {

 late File filePath;

  _SecondUploadDocumentPageState(this.filePath);

 late String currentDate ='';
 String selectedService ='';
 String serviceID='';
 String selectedProfessional ='';
 String professionalID ='';
 String selectedCareProvider ='';
 String providerID='';
 late String base64Image;
 late File compressFile;

  @override
  void initState() {
    super.initState();
    currentDate = DateFormat('dd-MMM-yyyy  kk:mm:ss').format(DateTime.now());
    print(currentDate);
    compressImage(filePath);
  }

  void compressImage(File file) async{

    final bytes = file.readAsBytesSync().lengthInBytes;
    final kb = bytes/ 1024;
    print('KB BEFORE :::::::::::: $kb');
    print('file IS : ${file.path}');

    final imageUri = Uri.parse(file.path);
    final String outputUri = imageUri.resolve('./output.jpeg').toString();
    compressFile = (await FlutterImageCompress.compressAndGetFile(file.path, outputUri, quality: 85, format: CompressFormat.jpeg))!;
    final bytesafter = compressFile.readAsBytesSync().lengthInBytes;
    final kbafter = bytesafter/ 1024;
    print('KB BEFORE :::::::::::: $kbafter');
    print('file IS : ${file.path}');
    getBase64FormateFile(compressFile.path);

  }

  void getBase64FormateFile(String path) {
     File file = File(path);
     print('File is = $file');
     List<int> fileInByte = file.readAsBytesSync();
     String fileInBase64 = base64Encode(fileInByte);
     base64Image =  fileInBase64;
   }

  void submitDocument() async{

    EasyLoading.show(status: 'Uploading Document...');

    try{
      Response response = await post(Uri.parse('$urlForINSC/uploadScanDocAndroid.shc?'),
        headers: {
          'token' : token
        },
        body: {
          'CitizenIDF': localCitizenIDP,
          'DocumentDate': currentDate,
          'ServiceIDF': serviceID,
          'SeerviceName': selectedService,
          'CareProfessionalIDF': professionalID,
          'CareProfessionalName': selectedCareProvider,
          'CareProviderIDF': providerID,
          'CareProviderName': selectedCareProvider,
          'baseStrPDF': base64Image,
        }
      );

      EasyLoading.dismiss();
      print(response.body.toString());

      if(response.statusCode == 200){
        dynamic status = jsonDecode(response.body.toString());
        dynamic data = status["JsonResponse"];
        print(data);
        String finalStatus = data['Status'].toString();
        if(finalStatus == '1'){
          showToast('Upload Successfully');
          Get.offAll(HomePage());
        }
        else{
         showToast('Sorry !!! Please try again');
        }
      }
      else{
        showToast('Sorry !!! Please try again');
      }
    }catch(e){
      showToast(e.toString());
      EasyLoading.dismiss();
    }
  }

  Text topText(String text){
    return Text(text,style: TextStyle(fontWeight: FontWeight.w600,color: Colors.grey.shade800,fontSize: 15),);
  }

  Padding commonDivider(){
    return Padding(
      padding: const EdgeInsets.only(top: 6.0,bottom: 25),
      child: Divider(
        height: 1,
        thickness: 1.5,
        color: globalBlue,
      ),
    );
  }

 @override
 void dispose() {
   EasyLoading.dismiss();
   super.dispose();
 }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GlobalAppBar(context, 'Upload Document'),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.only(left: 10,right: 10,bottom: 2),
        color: globalPageBackgroundColor,
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(15),
                    margin: const EdgeInsets.all(10),
                    decoration: BorderContainer(Colors.white,globalBlue),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8,),
                        topText('Document Date : '),
                        const SizedBox(height: 2,),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(currentDate, style: const TextStyle(fontWeight: FontWeight.w600,color: Colors.indigo,fontSize: 15),),
                            const Icon(Icons.calendar_month,color: Colors.indigo,)
                          ],
                        ),
                        commonDivider(),
                        topText('Service type :'),
                        InkWell(
                          onTap: () async{
                            var data = await Get.to(CommonSearchPage(url: '$urlForINSC/getServiceAndroid.shc?', searchType: 'service',));
                            print('selected Service  ::: $data');
                            if(data != null){
                              final split = data.toString().split('||');
                              final Map<int, String> values = {
                                for (int i = 0; i < split.length; i++)
                                  i: split[i]
                              };
                              setState(() {
                                selectedService = values[0].toString();
                                serviceID = values[1].toString().removeAllWhitespace;
                              });
                            }else{

                            }
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(child: Text(selectedService, style: const TextStyle(fontWeight: FontWeight.w600,color: Colors.indigo,fontSize: 15),)),
                              const SizedBox(width: 15),
                              const Icon(Icons.file_present_rounded,color: Colors.indigo,),
                            ],
                          ),
                        ),
                        commonDivider(),
                        topText('Care professional :'),
                        InkWell(
                          onTap: () async{
                            var data = await Get.to(CommonSearchPage(url: '$urlForINSC/otpCareProfessional.shc?', searchType: 'Care Professional',));
                            print('selected Care Professional  ::: $data');
                            if(data != null){
                              final split = data.toString().split('||');
                              final Map<int, String> values = {
                                for (int i = 0; i < split.length; i++)
                                  i: split[i]
                              };
                              setState(() {
                                selectedProfessional = values[0].toString();
                                professionalID = values[1].toString().removeAllWhitespace;
                              });
                            }else{

                            }
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(child: Text(selectedProfessional, style: const TextStyle(fontWeight: FontWeight.w600,color: Colors.indigo,fontSize: 15),)),
                              const SizedBox(width: 15,),
                              Image.asset('assets/images/doctor.png',color: Colors.indigo,height: 25,width: 25,)
                            ],
                          ),
                        ),
                        commonDivider(),
                        topText('Care Provider : '),
                        InkWell(
                          onTap: () async{
                            var data = await Get.to(CommonSearchPage(url: '$urlForINSC/getCareProviderAndroid.shc?', searchType: 'Care Provider',));
                            print('selected Care Provide  ::: $data');
                            if(data != null){
                              final split = data.toString().split('||');
                              final Map<int, String> values = {
                                for (int i = 0; i < split.length; i++)
                                  i: split[i]
                              };
                              setState(() {
                                selectedCareProvider = values[0].toString();
                                providerID = values[1].toString().removeAllWhitespace;
                              });
                            }else{

                            }
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(child: Text(selectedCareProvider, style: const TextStyle(fontWeight: FontWeight.w600,color: Colors.indigo,fontSize: 15),)),
                              const SizedBox(width: 15,),
                              const Icon(Icons.local_hospital_rounded,color: Colors.indigo,)
                            ],
                          ),
                        ),
                        commonDivider()
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: InkWell(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Container(
                      margin: const EdgeInsets.all(3),
                      padding: const EdgeInsets.only(top: 14,bottom: 14,),
                      decoration: ColorFillContainer(globalOrange),
                      child: const Text('Cancel',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),textAlign: TextAlign.center,),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: (){
                      if(serviceID.isEmpty){
                        showToast('Please Select Service');
                      }
                      else if(professionalID.isEmpty){
                        showToast('please Select Care Professional');
                      }
                      else if(providerID.isEmpty){
                        showToast('Please Select Care Provider');
                      }
                      else{
                        submitDocument();
                      }
                    },
                    child: Container(
                      decoration: ColorFillContainer(globalOrange),
                      margin: const EdgeInsets.all(3),
                      padding: const EdgeInsets.only(top: 14,bottom: 14,),
                      child: const Text('Submit',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),textAlign: TextAlign.center,),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
