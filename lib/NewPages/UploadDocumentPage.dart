import 'dart:convert';
import 'dart:io';
import 'package:digipath_ircs/Design/GlobalAppBar.dart';
import 'package:get/utils.dart';
import 'package:digipath_ircs/Design/BorderContainer.dart';
import 'package:digipath_ircs/Design/ColorFillContainer.dart';
import 'package:digipath_ircs/Global/Colors.dart';
import 'package:digipath_ircs/Global/Toast.dart';
import 'package:digipath_ircs/AddRecord/SecondUploadDocumentPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/route_manager.dart';
import 'package:http/http.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:intl/intl.dart';
import 'package:jitsi_meet_wrapper/jitsi_meet_wrapper.dart';
import 'package:lottie/lottie.dart';
import 'package:photo_view/photo_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Global/SearchAPI.dart';
import '../Global/global.dart';
import '../ImageWidget.dart';
import '../ModalClass/DocumentModal.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'ShowWaitingDialog.dart';

class UploadDocumentPage extends StatefulWidget {
  final bool isDirect;
  final String encounterID;
  final String startTime;
  final String endTime;
  final String appointmentDate;
  const UploadDocumentPage({required this.isDirect,Key? key, required this.encounterID, required this.startTime, required this.endTime, required this.appointmentDate}) : super(key: key);

  @override
  State<UploadDocumentPage> createState() => _UploadDocumentPageState(isDirect,encounterID,startTime,endTime,appointmentDate);
}

class _UploadDocumentPageState extends State<UploadDocumentPage> {
  late bool isDirect;
  late String encounterID;
  late String startTime;
  late String endTime;
  late String appointmentDate;
  _UploadDocumentPageState(this.isDirect,this.encounterID,this.startTime,this.endTime,this.appointmentDate);

  bool noData = true;
  String noDataTextString = 'Searching...';
  List<DocumentModal> documentList = <DocumentModal>[];
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

    documentList.clear();

    try{
      Response response = await get(
        Uri.parse('$urlForINSC/getPatientDocument_smarthealth_new_v2.shc?citizenid=$localCitizenIDP&careProfessionalID=9380'),
        headers: {
          'token' : token
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
            noData = false;
          }else{
            noData = true;
          }

          setState(() {
            // noData = false;
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
    final uri = Uri.parse('$urlForINSC/uploadPatientDocument_smarthealth.shc');

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
      EasyLoading.show(status: 'Refreshing Data...');
      setState(() {
        documentList.clear();
      });
      getDocumentData();

    }else{
      EasyLoading.dismiss();
      showToast('Sorry !!! Image Not uploaded successfully, Try Again');
      Navigator.pop(context);
    }
  }

  Future<void> showTimeOverDialog() {
    return showDialog(
        context: context,
        builder: ( BuildContext context ){
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            insetPadding: EdgeInsets.all(20),
            backgroundColor: Colors.indigo.shade50,
            elevation: 16,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Lottie.asset('assets/JSON/timerClock.json',repeat: true,height: 250,width: 250),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0,right: 15),
                    child: Text('Meeting time is over ! Please Book new Appointment',textAlign: TextAlign.center,style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600,color: globalBlue),),
                  )
                ],
              ),
            ),
          );
        }
    );
  }

  void startVideoCall() async{

    EasyLoading.show(status: 'Creating Room...');

    dynamic status = await searchAPI(true ,'$urlForINSC/insertVcGroup.shc',
        {'token' : token},
        {'loginID' : localUserLoginIDP,
          'citizenName' : localUserName,
          'encounterID' : encounterID
        },
        50);

    print(' status after responce: $status');
    EasyLoading.dismiss();

    if(status.toString() != 'Sorry !!! Server Error' && status.toString().isNotEmpty  && status.toString() != 'Sorry !!!  Connectivity issue! Try again'){

      String statusInfo = status['Status'].toString();
      if(statusInfo == 'true'){

        List<dynamic> data = status['data'];
        for(int i=0; i<data.length; i++){
          vcgroupIDP = data[i]['vcgroupIDP'].toString();
          roomName = data[i]['roomName'].toString();
        }

        if(roomName.isNotEmpty){
          roomName = roomName.removeAllWhitespace;
          print('Room name is ::::: $roomName');
          joinMeeting(roomName, vcgroupIDP);
        }
        else{
          showToast('Sorry no data found, Please Try again !!!');
        }
      }
      else{
        showToast('Sorry no data found !!!');
      }

    }else{
      showToast('Sorry !!! Server Error');
    }
  }

  joinMeeting(String roomName, vcgroupIDP) async {

    Map<FeatureFlag, bool> featureFlags = {
      FeatureFlag.isWelcomePageEnabled : false
    };

    var options = JitsiMeetingOptions(
      roomNameOrUrl: roomName,
      featureFlags: featureFlags
    )..featureFlags?.addAll(featureFlags);

    debugPrint("JitsiMeetingOptions: $options");
    await JitsiMeetWrapper.joinMeeting(
      options: options,
      listener: JitsiMeetingListener(
        onConferenceJoined: (url) async {
          SharedPreferences preferences = await SharedPreferences.getInstance();
          isOnline = true;
          preferences.setBool('isOnline', true);
          preferences.setString('vcgroupID', vcgroupIDP);
          debugPrint("onConferenceJoined: url: $url ::::::: isOnline : $isOnline");
        },
        onConferenceTerminated: (url, error) async{
          SharedPreferences preferences = await SharedPreferences.getInstance();
          isOnline = false;
          preferences.setBool('isOnline', false);
          preferences.setString('vcgroupID', '');
          updateVcGroup(vcgroupIDP);
          debugPrint("onClosed ::::::: isOnline : $isOnline");
          debugPrint("onConferenceTerminated: url: $url, error: $error");
        },
        onClosed: () async{
          SharedPreferences preferences = await SharedPreferences.getInstance();
          isOnline = false;
          preferences.setBool('isOnline', false);
          preferences.setString('vcgroupID', '');
          updateVcGroup(vcgroupIDP);
          debugPrint("onClosed ::::::: isOnline : $isOnline");
        }
      ),
    );
  }

  Future<void> showWaitingDialog(int hour, minutes, seconds) async{
    return showDialog(
      context: context,
      builder: ( BuildContext context ){
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          insetPadding: EdgeInsets.all(20),
          backgroundColor: Colors.indigo.shade50,
          elevation: 16,
          child: ShowWaitingDialogPage(hour: hour, minutes: minutes, seconds: seconds,),
        );
      }
    );
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
                        onTap: () async{
                          print('tap');
                          Get.to(SecondUploadDocumentPage(filePath: _image!));
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
                              Icon(Icons.view_timeline_outlined, size: 20,color: Colors.indigo.shade800),
                              Text('ADD TO',style: TextStyle(fontWeight: FontWeight.w500,color: Colors.grey.shade800,fontSize: 10)),
                              Text('TIMELINE',style: TextStyle(fontWeight: FontWeight.w500,color: Colors.grey.shade800,fontSize: 10))
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 20,),
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
                              Text('UPLOAD',style: TextStyle(fontWeight: FontWeight.w500,color: Colors.grey.shade800,fontSize: 11))
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 20,),
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
                              Text('Cancel'.toUpperCase(),style: TextStyle(fontWeight: FontWeight.w500,color: Colors.grey.shade800,fontSize: 10))
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

  getTimeDiffrence(var requestDate) async{

    EasyLoading.show(status: 'Loading...');

    Response response = await get(Uri.parse('$urlForINSC/getDateTimeDifferenceWithServer.notauth?requestDate=$requestDate'));

    EasyLoading.dismiss();

    if(response.statusCode == 200) {
      dynamic data = jsonDecode(response.body.toString());
      return data;
    }
    else{
      return null;
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
    return Scaffold(
      appBar: GlobalAppBar(context, 'upload document'),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(20),
        color: globalPageBackgroundColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
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
                              child : Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text('Select Image From...'.toUpperCase(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: globalBlue),),
                                    const SizedBox(height: 25,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            openCamera();
                                            Navigator.pop(context, false);
                                          },
                                          child: Column(
                                            children:  [
                                              Icon(Icons.camera_alt, size: 40,color: globalBlue,),
                                              Text('CAMERA',style: TextStyle(fontWeight: FontWeight.w600,color: Colors.indigo.shade800),)
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
                                              Icon(Icons.photo_library_rounded, size: 40,color: globalBlue,),
                                              Text('Gallery',style: TextStyle(fontWeight: FontWeight.w600,color: Colors.indigo.shade800))
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                      );
                  },
                  child: Container(
                    margin: EdgeInsets.all(5),
                    padding: EdgeInsets.all(10),
                    decoration: ColorFillContainer(Colors.white),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.add_photo_alternate_rounded,color: Colors.indigo.shade800),
                        SizedBox(width: 5,),
                        Text('Choose Image',style: TextStyle(fontSize: 15,color: Colors.indigo.shade800),)
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 20,),
                InkWell(
                  onTap: () async{

                    String time24 = startTime;
                    DateTime time = DateFormat('H:m').parse(time24);
                    String time12 = DateFormat('h:mm a').format(time);

                    var appointmentTime = '$appointmentDate $time12';
                    print('appointmentTime :::$appointmentTime');

                    dynamic timeDiff = await getTimeDiffrence(appointmentTime);
                    print(timeDiff);

                    if(timeDiff !=null){

                      var hour = timeDiff['diffHours'];
                      var minutes = timeDiff['diffMinutes'];
                      if(minutes>0){
                        minutes = minutes - 5;
                      }
                      var seconds = timeDiff['diffSeconds'];

                      if(minutes>0){
                        showWaitingDialog(hour, minutes, seconds);
                      }
                      else {

                        String time24 = endTime;
                        DateTime time = DateFormat('H:m').parse(time24);
                        String time12 = DateFormat('h:mm a').format(time);

                        var appointmentTime = '$appointmentDate $time12';
                        print('else :: appointmentTime :::$appointmentTime');

                        dynamic timeDiff = await getTimeDiffrence(appointmentTime);
                        print('else :: $timeDiff');

                        if(timeDiff !=null){
                          var minutes = timeDiff['diffMinutes'];

                          if(minutes<=0){
                            showTimeOverDialog();
                          }else{
                            if(isOnline == true){
                              showToast('You already join the Meeting !!!');
                            }else{
                              startVideoCall();
                            }
                          }
                        }else{
                          showToast('Please Try again !!!');
                        }

                      }
                    }
                    else{
                      showToast('Please Try Again');
                    }

                  },
                  child: Visibility(
                    visible: !isDirect,
                    child: InkWell(
                      child: Container(
                        margin: EdgeInsets.all(5),
                        padding: EdgeInsets.all(10),
                        decoration: ColorFillContainer(Colors.white),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.video_call,color: Colors.indigo.shade800),
                            const SizedBox(width: 5,),
                            Text('Video Call',style: TextStyle(fontSize: 15,color: Colors.indigo.shade800),)
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            Flexible(
              child: noData?Center(
                child: Text(noDataTextString,style:const TextStyle(fontSize: 15,fontWeight: FontWeight.bold),textAlign: TextAlign.center),
              ): RefreshIndicator(
                onRefresh: () {
                  return Future.delayed(const Duration(microseconds: 500),
                    () {
                        setState(() {
                          documentList.clear();
                        });
                        EasyLoading.show(status: 'Refreshing Data...');
                        getDocumentData();
                    });
                },
                child: SingleChildScrollView(
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: documentList.length,
                    itemBuilder: (context, index){
                      return Container(
                        decoration: BorderContainer(Colors.white, globalBlue),
                        padding: EdgeInsets.only(left: 10,right: 10,top: 5,bottom: 5),
                        margin: EdgeInsets.all(5),
                        child: Column(
                          crossAxisAlignment: documentList[index].documentType == '3'?CrossAxisAlignment.start : CrossAxisAlignment.end,
                          children: [
                            ImageWidget(imageString: documentList[index].imageString,),
                            SizedBox(height: 5,),
                            Text(documentList[index].documentDate,style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: Colors.indigo.shade800),),
                            SizedBox(height: 5,),
                            Text(documentList[index].uploadBy,style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: Colors.indigo.shade800),),
                            SizedBox(height: 5,),
                          ],
                        ),
                      );
                    }
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
