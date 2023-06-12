import 'dart:io';
import 'package:digipath_ircs/Global/Colors.dart';
import 'package:digipath_ircs/Global/global.dart';
import 'package:digipath_ircs/Book%20Appointment/BookApointmentPage.dart';
import 'package:digipath_ircs/NewPages/ViewTimeLinePage.dart';
import 'package:digipath_ircs/SignUpPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'Book Appointment/PathologyPages/PathologyPage.dart';
import 'Design/TextWidget.dart';
import 'DrawerPages/SwitchUserPage.dart';
import 'LoginPage.dart';
import 'ModalClass/HomePageTitleModal.dart';
import 'AddRecord/AddRecordPage.dart';
import 'DrawerPages/EnquiryListPage.dart';
import 'GetFreeAdvise/FreeConsultationPage.dart';
import 'NewPages/OrderedInvestigation.dart';
import 'NewPages/PaymentHistoryPage.dart';
import 'NewPages/PaymentPage.dart';
import 'NewPages/PrescriptionPage.dart';
import 'NewPages/TeleConsulatationPage.dart';
import 'NewPages/UploadDocumentPage.dart';
import 'NewPages/ViewReports.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _homeState();
}

class _homeState extends State<HomePage> {

  late final Permission _permission = Permission.storage;
  List<HomePagetitleModal> titleList = <HomePagetitleModal>[];

  @override
  void initState() {
    super.initState();
    requestPermission();
    getTitle();
  }

  void requestPermission() async {
    final status = await _permission.request();
    print(status);
  }

  void signOut() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool("loggedIn", false);

    Get.offAll(LoginPage());
  }

  void getTitle(){

    titleList.clear();

    titleList.add(HomePagetitleModal(icon: Icons.calendar_month,color: globalBlue, title: 'BOOK APPOINTMENT'));
    titleList.add(HomePagetitleModal(icon: Icons.payment_rounded,color: globalBlue, title: 'PAYMENT'));
    titleList.add(HomePagetitleModal(icon: Icons.upload_file,color: globalLightBlue, title: 'UPLOAD DOCUMENT' ));
    titleList.add(HomePagetitleModal(icon: Icons.pageview_rounded,color: globalLightBlue, title: 'VIEW REPORT'));
    titleList.add(HomePagetitleModal(icon: Icons.view_timeline_outlined, color: globalLightBlue, title: 'VIEW TIMELINE'));
    titleList.add(HomePagetitleModal(icon: Icons.video_camera_front_outlined, color: globalLightBlue, title: ' TELE-CONSULTATION'));
    titleList.add(HomePagetitleModal(icon: Icons.medical_services_outlined,color: globalLightBlue, title: 'PRESCRIPTION'));
    titleList.add(HomePagetitleModal(icon: Icons.add_photo_alternate_rounded,color: globalLightBlue, title: 'ADD RECORD'));
    titleList.add(HomePagetitleModal(icon: Icons.inventory_sharp,color: globalLightBlue, title: 'ORDERED INVESTIGATION'));
    titleList.add(HomePagetitleModal(icon: Icons.chat_rounded,color: globalOrange, title: 'थैलासीमिया साथी'));

  }

  Container homeCommonContainer(Color colors,String text1){
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
                color: colors,
                blurRadius: 3,
                blurStyle: BlurStyle.outer,
                spreadRadius: 0,
                offset: Offset(0, 0)
            ),
          ],
          color: colors),
      child: Center(
        child: Text(
          text1,
          textAlign: TextAlign.center,
          style:  TextStyle(
            fontSize: 16,
            color: globalWhiteColor,
            fontFamily: 'Ageo_Bold',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Widget divider =   Divider(
    thickness: 1,
    color: globalBlue,
  );

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        EasyLoading.dismiss();
        showDialog<String>(
            context: context,
            builder: (BuildContext context) => TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: 1),
              duration: Duration(milliseconds: 500),
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
                title:  TextWidget('Are you sure you want to Exit?', 18, FontWeight.w600, globalBlue),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => {Navigator.pop(context, 'Cancel'),_scaffoldKey.currentState?.openEndDrawer(),},
                    child: TextWidget('Cancel', 16, FontWeight.bold, globalBlue),
                  ),
                  TextButton(
                    onPressed: () => {
                      if (Platform.isAndroid) {
                        SystemNavigator.pop()
                      } else if (Platform.isIOS) {
                        exit(0)
                      }
                    },
                    child: TextWidget('OK', 14, FontWeight.bold,globalBlue),
                  ),
                ],
              ),
            )
        );
        return false;
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: globalBlue,
          leading: Builder(
            builder: (context) => IconButton(
              icon: Icon(
                Icons.menu,
                color: globalWhiteColor,
              ),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
          centerTitle: true,
          title: Text('Home'),
          titleTextStyle: TextStyle(color: globalWhiteColor,fontWeight: FontWeight.bold,fontSize: 19),
          elevation: 0.0,
          actions: [
            IconButton(
              icon: Icon(
                Icons.logout_rounded,
                color: globalWhiteColor,
              ),
              onPressed: () {
                showDialog<String>(
                  context: context,
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
                      title: TextWidget('Are you sure you want to Logout?', 15, FontWeight.w600,globalBlue),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => {Navigator.pop(context, 'Cancel'),_scaffoldKey.currentState?.openEndDrawer(),},
                          child: TextWidget('Cancel', 15, FontWeight.bold,globalBlue),
                        ),
                        TextButton(
                          onPressed: () => {
                            signOut(),
                            _scaffoldKey.currentState?.openEndDrawer(),
                          },
                          child: TextWidget('OK', 15, FontWeight.bold,globalBlue),
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
          ],
        ),
        drawer: Drawer(
          backgroundColor: Colors.white,
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20,20,20,0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                     CircleAvatar(
                      backgroundColor: globalOrange,
                      radius:40,
                      child: Icon(
                        Icons.person,
                        size: 60,
                        color: globalBlue,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        localUserName,
                        style: TextStyle(
                          fontSize: 18,
                          color: globalBlue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              divider,
              ListTile(
                dense: true,
                visualDensity: const VisualDensity(vertical: -3),
                leading: Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Icon(Icons.person, color: globalBlue,),
                ),
                title: TextWidget('Edit Profile Details',16,FontWeight.w600,globalBlue),
                onTap: (){},
              ),
              divider,
              ListTile(
                  dense: true,
                  visualDensity: VisualDensity(vertical: -3),
                  leading: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Icon(Icons.payment_rounded, color: globalBlue,),
                  ),
                  title: TextWidget('Payment History',16,FontWeight.w600,globalBlue,),
                  onTap: (){
                    _scaffoldKey.currentState?.openEndDrawer();
                    Get.to(PaymentHistoryPage());
                  }
              ),
              divider,
              ListTile(
                  dense: true,
                  visualDensity: VisualDensity(vertical: -3),
                  leading: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Icon(Icons.switch_account, color: globalBlue,),
                  ),
                  title: TextWidget('Switch User',16,FontWeight.w600,globalBlue,),
                  onTap: (){
                    _scaffoldKey.currentState?.openEndDrawer();
                    Get.to(SwitchUserPage());
                  }
              ),
              divider,
              ListTile(
                dense: true,
                visualDensity: VisualDensity(vertical: -3),
                leading: Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Icon(Icons.edit_note_rounded,color: globalBlue),
                ),
                title: TextWidget('Enquiry List',16,FontWeight.w600,globalBlue),
                onTap: () {
                  _scaffoldKey.currentState?.openEndDrawer();
                  Get.to(EnquiryListPage());
                },
              ),
              divider,
              ListTile(
                  dense: true,
                  visualDensity: VisualDensity(vertical: -3),
                  leading: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Icon(Icons.family_restroom_rounded, color: globalBlue,),
                  ),
                  title: TextWidget('Add Family Member',16,FontWeight.w600,globalBlue,),
                  onTap: (){
                    _scaffoldKey.currentState?.openEndDrawer();
                    Get.to(SignUpPage(fromAddMember: true,));
                  }
              ),
              divider,
            ],
          ),
        ),
        body: Container(
          padding: const EdgeInsets.only(top: 2),
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 26,),
                        GridView.builder(
                            itemCount: titleList.length,
                            shrinkWrap: true,
                            physics: const ClampingScrollPhysics(),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 3.5 / 2,
                                crossAxisSpacing: 0,
                                mainAxisSpacing: 15
                            ),
                            itemBuilder:(BuildContext context, int index){
                              return InkWell(
                                onTap: (){
                                  print(index);
                                  if(index == 0){
                                    showDialog<String>(
                                        context: context,
                                        builder: (BuildContext context) => TweenAnimationBuilder(
                                          tween: Tween<double>(begin: 0, end: 1),
                                          duration: Duration(milliseconds: 500),
                                          builder: (BuildContext context, double value, Widget? child) {
                                            return Opacity(opacity: value,
                                              child: Padding(
                                                padding: EdgeInsets.only(top: value * 1),
                                                child: child,
                                              ),
                                            );
                                          },
                                          child: Dialog(
                                            backgroundColor: Colors.white.withOpacity(0.7),
                                            insetPadding : EdgeInsets.all(15),
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                                            elevation: 16,
                                            child: Container(
                                              padding: EdgeInsets.all(10),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  SizedBox(height: 10,),
                                                  Text('Book Appointment for...',style: TextStyle(fontSize: 18,fontFamily: 'Ageo_Bold',color: Colors.indigo.shade900,fontWeight: FontWeight.bold,),),
                                                  SizedBox(height: 20,),
                                                  InkWell(
                                                    onTap: (){
                                                      Navigator.pop(context);
                                                      Get.to(BookApointmentPage());
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius: BorderRadius.circular(12),
                                                      ),
                                                      margin: EdgeInsets.only(bottom: 3,top: 7,left: 10,right: 10),
                                                      padding: EdgeInsets.all(10),
                                                      child: Row(
                                                        children: [
                                                          Icon(Icons.ac_unit_rounded,color: Colors.indigo.shade800),
                                                          SizedBox(width: 15),
                                                          Text('Tele Consultation',style: TextStyle(fontSize: 16,fontFamily: 'Ageo_Bold',color: Colors.indigo.shade800,fontWeight: FontWeight.w600),)
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(height: 20,),
                                                  InkWell(
                                                    onTap: (){
                                                      Navigator.pop(context);
                                                      Get.to(PathologyPage());
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius: BorderRadius.circular(12),
                                                      ),
                                                      margin: EdgeInsets.only(bottom: 10,top: 3,left: 10,right: 10),
                                                      padding: EdgeInsets.all(10),
                                                      child: Row(
                                                        children: [
                                                          Icon(Icons.ac_unit_rounded,color: Colors.indigo.shade800),
                                                          SizedBox(width: 15),
                                                          Text('Pathology',style: TextStyle(fontSize: 16,fontFamily: 'Ageo_Bold',color: Colors.indigo.shade800,fontWeight: FontWeight.w600),)
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 20,),
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                    );
                                  }
                                  else if(index == 1){
                                    Get.to(PaymentPage());
                                  }
                                  else if(index == 2){
                                    Get.to(UploadDocumentPage(isDirect: true));
                                  }
                                  else if(index == 3){
                                    Get.to(ViewReportPage());
                                  }
                                  else if(index == 4){
                                    Get.to(ViewTimeLinePage());
                                  }
                                  else if(index == 5){
                                    Get.to(TeleConsultationPage());
                                  }
                                  else if(index == 6){
                                    Get.to(PrescriptionPage());
                                  }
                                  else if(index == 7){
                                    Get.to(AddRecordPage());
                                  }
                                  else if(index ==8){
                                      Get.to(OrderedInvestigation());
                                  }
                                  else if(index == 9){
                                    Get.to(FreeConsultationPage());
                                  }
                                },
                                child: Stack(
                                    alignment: Alignment.center,
                                    clipBehavior: Clip.none,
                                  children : [
                                    Container(
                                      margin: const EdgeInsets.all(15),
                                      child: homeCommonContainer(
                                        titleList[index].color,
                                        titleList[index].title,),
                                    ),
                                    Positioned(
                                      top: -15,
                                      child: Container(
                                        padding: EdgeInsets.all(7),
                                        child: Icon(titleList[index].icon,size: 28,color: Colors.grey.shade800,),
                                        decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                  color: titleList[index].color,
                                                  blurRadius: 6,
                                                  blurStyle: BlurStyle.outer,
                                                  spreadRadius: 0,
                                                  offset: Offset(0, 0)
                                              ),
                                            ],
                                            color: Colors.white,
                                            border: Border.all(color: titleList[index].color,width: 1.5),
                                            shape: BoxShape.circle
                                        ),
                                      ),
                                    ),
                                 ]
                                ),
                              );
                            }
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 2,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Powered By",
                    style: TextStyle(fontSize: 15,color: Color(0xFF254D99)),
                  ),
                  InkWell(
                    onTap: () async {
                      final Uri url = Uri.parse('https://artemhealthtech.com/');
                      if (!await launchUrl(url)) {
                      throw Exception('Could not launch $url');
                      }
                    },
                    child: const Text(
                      "Artem Healthtech Pvt Ltd",
                      style: TextStyle(fontSize: 18, color: Color(0xFF254D99),fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(
                    height: 2,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}