import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:digipath_ircs/Global/Toast.dart';
import 'package:digipath_ircs/HomePage.dart';
import 'package:digipath_ircs/NewPages/SecondUploadDocumentPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/route_manager.dart';
import 'package:http/http.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import '../Global/global.dart';
import '../ModalClass/DocumentModal.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class UploadDocumentPage extends StatefulWidget {
  final bool isDirect;
  const UploadDocumentPage({required this.isDirect,Key? key}) : super(key: key);

  @override
  State<UploadDocumentPage> createState() => _UploadDocumentPageState(isDirect);
}

class _UploadDocumentPageState extends State<UploadDocumentPage> {
  late bool isDirect;
  _UploadDocumentPageState(this.isDirect);

  bool noData = true;
  bool loadImage = true;
  String noDataTextString = 'Searching...';
  List<DocumentModal> documentList = <DocumentModal>[];
  List<Uint8List> imageList = <Uint8List>[];
  CroppedFile? _croppedFile;
  late PhotoViewScaleStateController scaleStateController;

  @override
  void initState() {
    super.initState();
    scaleStateController = PhotoViewScaleStateController();
    EasyLoading.show(status: 'Loading...');
    getDocumentData();
  }

  void getDocumentData() async{

    try{
      Response response = await get(
        Uri.parse('https://smarthealth.care/getPatientDocument_smarthealth_new_v2.shc?citizenid=$localCitizenIDP&careProfessionalID=9380'),
        headers: {
          'token' : 'eyJhbGciOiJSUzI1NiJ9.eyJ1bmFtZSI6IjI2MDk3MTQ1NDA5MSIsInNlc3Npb25pZCI6IkQyN0I4QTBBQzNERjZCQzlEQUEwNUU2NTlDODk2NTk1Iiwic3ViIjoiSldUX1RPS0VOIiwianRpIjoiNWQxYWU3ZmYtMzJhOC00YWYxLWE4OTItODE1MWRiMDRlNzE3IiwiaWF0IjoxNjc4MTcyMTQzfQ.J4pK2XBzMaZNlgGAFxB1yFLUJoWKhzqHBKJbZfxwau7aBhMyb1ovWevVVgHQR5DsKJUhPbedNnhqvSOdLNO6uWn2qEwlGVpsslDCz1oftzA3NymnUF5xRoYoTkqjcM_3Raw6sVST9jAlw0hKmS_1tVJKBWdI1754FC-1o2qZ0mPOn-AT_1DGhWkFg88FRdtZAD2Zb7NUJ0vmvVlXzvkvhFEZsb-NksM4neAtWozUGqV-ZQ23JI21QDEZIC6Xj3khEJqNwVxNUrXH6CAdDU2QiDc7RJ6aN9HdqEdRvUSnvjA88qjBtQeNgp88rMMQ5g36WlzO0vQO4uO-Ek4pax9rpg'
        }
      );

      print('Response is::: ${response.body}');

      EasyLoading.dismiss();
      if (response.statusCode == 200) {
        var status = jsonDecode(response.body.toString());
        List<dynamic> statusinfo = status['data'];

        if ((statusinfo.isNotEmpty)) {

          for(int i = 0; i<statusinfo.length; i++){
            String documentIDP = statusinfo[i]['documentIDP'].toString();
            String imageString = statusinfo[i]['imageString'].toString();
            String documentType = statusinfo[i]['documentType'].toString();
            String documentDate = statusinfo[i]['documentDate'].toString();
            String uploadBy = statusinfo[i]['uploadBy'].toString();

            documentList.add(DocumentModal(documentIDP: documentIDP, imageString: imageString, documentType: documentType, documentDate: documentDate, uploadBy: uploadBy));
          }

          if(documentList.isNotEmpty){
            getImageList();
            noData = false;

          }else{
            noData = true;
          }

          setState(() {
            noData = false;
          });
        }
        else{
          noData = true;
          setState(() {
            noDataTextString = 'Sorry !!! no Data found';
          });
        }
      }
    }
    catch(e){
      EasyLoading.dismiss();
      noData = true;
      noDataTextString = 'Sorry Server Error';
      showToast(e.toString());
    }
  }

  void getImageList() async{

      for (int i = 0; i < documentList.length; i++) {
        if(mounted) {
          try {
            String imageString = documentList[i].imageString.toString();
            Response response = await get(
                Uri.parse(
                    'https://smarthealth.care/getPatientDocumentFile_ByteArray.shc?documentName=$imageString'),
                headers: {
                  'token': 'eyJhbGciOiJSUzI1NiJ9.eyJ1bmFtZSI6IjI2MDk3MTQ1NDA5MSIsInNlc3Npb25pZCI6IkQyN0I4QTBBQzNERjZCQzlEQUEwNUU2NTlDODk2NTk1Iiwic3ViIjoiSldUX1RPS0VOIiwianRpIjoiNWQxYWU3ZmYtMzJhOC00YWYxLWE4OTItODE1MWRiMDRlNzE3IiwiaWF0IjoxNjc4MTcyMTQzfQ.J4pK2XBzMaZNlgGAFxB1yFLUJoWKhzqHBKJbZfxwau7aBhMyb1ovWevVVgHQR5DsKJUhPbedNnhqvSOdLNO6uWn2qEwlGVpsslDCz1oftzA3NymnUF5xRoYoTkqjcM_3Raw6sVST9jAlw0hKmS_1tVJKBWdI1754FC-1o2qZ0mPOn-AT_1DGhWkFg88FRdtZAD2Zb7NUJ0vmvVlXzvkvhFEZsb-NksM4neAtWozUGqV-ZQ23JI21QDEZIC6Xj3khEJqNwVxNUrXH6CAdDU2QiDc7RJ6aN9HdqEdRvUSnvjA88qjBtQeNgp88rMMQ5g36WlzO0vQO4uO-Ek4pax9rpg'
                }
            );
            if (response.statusCode == 200) {
              imageList.add(response.bodyBytes);
            }
            print(':::::' + imageList.length.toString());
            setState(() {

            });
          }
          catch (e) {
            print(e.toString());
          }
        }
    }
  }

  File? _image;
  final imagePicker = ImagePicker();

  Future openGallery() async {
    final imageFile = await ImagePicker().pickImage(
        source: ImageSource.gallery);
    if (imageFile != null) {
      setState(() {
        _image=File(imageFile.path);
        print('image.... ${imageFile.path}');
        // show2Simple();
        _cropImage();
      });
    }
  }

  Future openCamera() async {
    final imageFile = await ImagePicker().pickImage(
        source: ImageSource.camera);
    if (imageFile != null) {
      setState(() {
        _image = File(imageFile.path);
        print('image.... ${_image?.path.toString()}');
        // show2Simple();
        _cropImage();
      });
    }
  }

  void uploadDocument() async {

    Map<String, String> headers = { "token": token};
    final uri = Uri.parse('https://smarthealth.care/uploadPatientDocument_smarthealth.shc');

    var request = http.MultipartRequest('POST', uri)..files.add(await http.MultipartFile.fromPath('_image1', _image!.path));
    request.headers.addAll(headers);
    request.fields['citizenID'] = localCitizenIDP;
    request.fields['documentType'] = '3';
    request.fields['careprofessionalID'] = '';
    final response = await request.send();

    print('response is :::${response.statusCode}');

    if(response.statusCode == 200){

      EasyLoading.dismiss();
      showToast('Image uploaded successfully');
      Navigator.pop(context);
      Get.offAll(UploadDocumentPage(isDirect: true,));

    }else{
      EasyLoading.dismiss();
      showToast('Sorry !!! Image Not uploaded successfully, Try Again');
      Navigator.pop(context);
    }
  }

  Future<void> show2Simple() async {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            insetPadding: EdgeInsets.all(20),
            backgroundColor: Colors.indigo.shade50,
            elevation: 16,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          EasyLoading.show(status: 'Uploading Image...');
                          uploadDocument();
                        },
                        child: Container(
                          margin: EdgeInsets.all(5),
                          padding: EdgeInsets.all(12),
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle
                          ),
                          child: Column(
                            children: [
                              Icon(Icons.file_upload_rounded, size: 25,color: Colors.indigo.shade800),
                              Text('UPLOAD',style: TextStyle(fontWeight: FontWeight.w500,color: Colors.grey.shade800,fontSize: 10))
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 30,),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context, false);
                        },
                        child: Container(
                          margin: EdgeInsets.all(5),
                          padding: EdgeInsets.all(12),
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle
                          ),
                          child: Column(
                            children: [
                              Icon(Icons.cancel_rounded, size: 25,color: Colors.indigo.shade800),
                              Text('Cancel',style: TextStyle(fontWeight: FontWeight.w500,color: Colors.grey.shade800,fontSize: 11))
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  height: 400,
                  child: _image==null?const Text('Upload your Image'):
                  InkWell(
                    onTap: (){
                      showDialog<String>(
                        context: context,
                        barrierColor:Colors.transparent,
                        builder: (BuildContext context) => TweenAnimationBuilder(
                          tween: Tween<double>(begin: 0, end: 1),
                          duration: const Duration(milliseconds: 500),
                          builder: (BuildContext context, double value, Widget? child) {
                            return Opacity(opacity: value,
                              child: Padding(
                                padding: EdgeInsets.only(top: value * 1),
                                child: child,
                              ),
                            );
                          },
                          child: AlertDialog(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                            backgroundColor: Colors.transparent,
                            insetPadding: EdgeInsets.all(10),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 15),
                                  child: Row(mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      InkWell(child: Icon(Icons.cancel,size: 35,),
                                          onTap: ()=>{ Navigator.pop(context, 'Cancel')}),
                                    ],),
                                ),
                                Container(
                                    height: 300,
                                    width: 300,
                                    color: Colors.transparent,
                                    child: PhotoView.customChild(
                                      backgroundDecoration: BoxDecoration(color: Colors.transparent),
                                      basePosition: Alignment.center,
                                      minScale: PhotoViewComputedScale.contained * 1,
                                      tightMode: true,
                                      maxScale: PhotoViewComputedScale.covered * 2.0,
                                      initialScale: PhotoViewComputedScale.contained * 1.1,
                                      enableRotation: true,
                                      scaleStateController: scaleStateController,
                                      child: Container(
                                        color: Colors.transparent,
                                        width: 300,
                                        height: 300,
                                        child: Image.file(_image!),
                                      ),
                                    )
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    child: Image.file(_image!)
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(10),
                  child: InkWell(
                    onTap: (){
                      Navigator.pop(context);
                      _cropImage();
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.crop, size: 25,color: Colors.indigo.shade800),
                        SizedBox(width: 10,),
                        Text('Crop Image',style: TextStyle(fontWeight: FontWeight.w500,color: Colors.indigo.shade800,fontSize: 13))
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        }
    );
  }

  Future<void> _cropImage() async {
    if (_image != null) {
      final croppedFile = await ImageCropper().cropImage(
          sourcePath: _image!.path,
          compressFormat: ImageCompressFormat.jpg,
          compressQuality: 100,
          uiSettings: [
            AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.indigo.shade800,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
            IOSUiSettings(

            )
          ]
      );
      if (croppedFile != null) {
        setState(() {
          _croppedFile = croppedFile;
          _image = File(_croppedFile!.path);
          show2Simple();
        });
      }
      else{
        show2Simple();
      }
    }
  }

  @override
  void dispose() {
    scaleStateController.dispose();
    EasyLoading.dismiss();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        Get.offAll(HomePage());
          return false;
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.indigo[100],
          leading: InkWell(
              onTap: (){
                Get.offAll(
                  HomePage(),
                );
              },
              child: Icon(Icons.arrow_back_rounded,color: Colors.indigo[900])),
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
              Text('UPLOAD DOCUMENTS', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.indigo[900]),),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: (){
                         showDialog<void>(
                            context: context,
                            builder: (BuildContext context) {
                              return Dialog(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                insetPadding: EdgeInsets.all(20),
                                elevation: 16,
                                child : Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              openCamera();
                                              Navigator.pop(context, false);
                                            },
                                            child: Column(
                                              children:  [
                                                Icon(Icons.camera_alt, size: 50,color: Colors.grey.shade800,),
                                                Text('CAMERA',style: TextStyle(fontWeight: FontWeight.w500,color: Colors.grey.shade800),)
                                              ],
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              openGallery();
                                              Navigator.pop(context, false);
                                            },
                                            child: Column(
                                              children: [
                                                Icon(Icons.photo_library_rounded, size: 50,),
                                                Text('Files',style: TextStyle(fontWeight: FontWeight.w500,color: Colors.grey.shade800))
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                        );
                    },
                    child: Container(
                      margin: EdgeInsets.all(5),
                      padding: EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.upload_rounded,color: Colors.indigo.shade800),
                          Text('Upload',style: TextStyle(fontSize: 10,color: Colors.indigo.shade800),)
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 20,),
                  Visibility(
                    visible: !isDirect,
                    child: InkWell(
                      child: Container(
                        margin: EdgeInsets.all(5),
                        padding: EdgeInsets.all(12),
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle
                        ),
                        child: Column(
                          children: [
                            Icon(Icons.video_call,color: Colors.indigo.shade800),
                            Text('Video Call',style: TextStyle(fontSize: 10,color: Colors.indigo.shade800),)
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Flexible(
                child: Container(
                    padding: const EdgeInsets.only(left: 5,right: 5),
                    margin: const EdgeInsets.only(left: 15,right: 15,top: 0,bottom: 5),
                    decoration: BoxDecoration(
                      color: Colors.indigo[100],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: noData?Center(
                      child: Text(noDataTextString,style:const TextStyle(fontSize: 15,fontWeight: FontWeight.bold),textAlign: TextAlign.center),
                    ): ListView.builder(
                      itemCount: documentList.length,
                      itemBuilder: (context, index){
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                                width: 1.5,
                                color: Colors.grey
                            ),
                          ),
                          padding: EdgeInsets.only(left: 10,right: 10,top: 5,bottom: 5),
                          margin: EdgeInsets.all(5),
                          child: Column(
                            crossAxisAlignment: documentList[index].documentType == '3'?CrossAxisAlignment.start : CrossAxisAlignment.end,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Visibility(
                                    visible : !(imageList.length<(index+1)),
                                    child: FloatingActionButton(onPressed: ()async{
                                      Directory appDocDirectory = await getTemporaryDirectory();
                                      final myImagePath = "${appDocDirectory.path}/image.jpg";
                                      File file = await File(myImagePath).writeAsBytes(imageList[index]);
                                      print(file);
                                          Get.to(SecondUploadDocumentPage(filePath: file));
                                      },
                                      heroTag: null,
                                      backgroundColor: Colors.indigo,
                                      elevation: 0.0,
                                      tooltip: 'ADD TO RECORD',
                                      mini: true,
                                      child: Icon(Icons.add_photo_alternate_rounded),),
                                  )
                                ],
                              ),
                              InkWell(
                                onTap : (){
                                  showDialog<String>(
                                    context: context,
                                    barrierColor:Colors.transparent,
                                    builder: (BuildContext context) => TweenAnimationBuilder(
                                      tween: Tween<double>(begin: 0, end: 1),
                                      duration: const Duration(milliseconds: 500),
                                      builder: (BuildContext context, double value, Widget? child) {
                                        return Opacity(opacity: value,
                                          child: Padding(
                                            padding: EdgeInsets.only(top: value * 1),
                                            child: child,
                                          ),
                                        );
                                      },
                                      child: AlertDialog(
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                                        backgroundColor: Colors.transparent,
                                        insetPadding: EdgeInsets.all(10),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(bottom: 15),
                                              child: Row(mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  InkWell(child: Icon(Icons.cancel,size: 35,),
                                                      onTap: ()=>{ Navigator.pop(context, 'Cancel')}),
                                                ],),
                                            ),
                                            Container(
                                                height: 300,
                                                width: 300,
                                                color: Colors.transparent,
                                                child: PhotoView.customChild(
                                                  backgroundDecoration: BoxDecoration(color: Colors.transparent),
                                                  basePosition: Alignment.center,
                                                  minScale: PhotoViewComputedScale.contained * 1,
                                                  tightMode: true,
                                                  maxScale: PhotoViewComputedScale.covered * 2.0,
                                                  initialScale: PhotoViewComputedScale.contained * 1.1,
                                                  enableRotation: true,
                                                  scaleStateController: scaleStateController,
                                                  child: Container(
                                                    color: Colors.transparent,
                                                    width: 300,
                                                    height: 300,
                                                    child:imageList.length<(index+1)?Center(child: CircularProgressIndicator()) : Image.memory(imageList[index]),
                                                  ),
                                                )
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: EdgeInsets.only(left: 5),
                                  height: 200,
                                  width: 220,
                                  child: imageList.length<(index+1)?const Center(child: CircularProgressIndicator()) : Image.memory(imageList[index]),
                                ),
                              ),
                              SizedBox(height: 5,),
                              Text(documentList[index].documentDate,style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: Colors.indigo.shade800),),
                              SizedBox(height: 5,),
                              Text(documentList[index].uploadBy,style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: Colors.indigo.shade800),),
                              SizedBox(height: 5,),
                            ],
                          ),
                        );
                      }
                    )
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
