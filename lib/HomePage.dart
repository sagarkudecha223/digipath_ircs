import 'dart:io';
import 'package:digipath_ircs/NewPages/BookApointmentPage.dart';
import 'package:digipath_ircs/NewPages/ViewTimeLinePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Design/TextWidget.dart';
import 'LoginPage.dart';
import 'ModalClass/HomePageTitleModal.dart';
import 'NewPages/OrderedInvestigation.dart';
import 'NewPages/PaymentHistoryPage.dart';
import 'NewPages/PaymentPage.dart';
import 'NewPages/PrescriptionPage.dart';
import 'NewPages/TeleConsulatationPage.dart';
import 'PathologyPages/PathologyPage.dart';
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
    requestPersmission();
    getTitle();
  }

  void requestPersmission() async {
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

    titleList.add(HomePagetitleModal(color: Colors.yellow.shade800, title: 'BOOK APPOINTMENT'));
    titleList.add(HomePagetitleModal(color: Colors.blueAccent, title: 'PAYMENT'));
    titleList.add(HomePagetitleModal(color: Colors.lightGreen, title: 'UPLOAD DOCUMENT'));
    titleList.add(HomePagetitleModal(color: Colors.lightBlue, title: 'VIEW REPORT'));
    titleList.add(HomePagetitleModal(color: Colors.orangeAccent, title: 'VIEW TIMELINE'));
    titleList.add(HomePagetitleModal(color: Colors.green.shade400, title: 'START TELE-CONSULTATION'));
    titleList.add(HomePagetitleModal(color: Colors.indigo.shade500, title: 'PRESCRIPTION'));

  }

  Container homeCommonContainer(Color colors,String text1){
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white),
      child: Padding(
        padding: const EdgeInsets.only(left: 4.0),
        child: Center(
          child: Text(
            text1,
            textAlign: TextAlign.center,
            style:  TextStyle(
              fontSize: 16,
              color: Colors.indigo.shade800,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Widget divider =   Divider(
    thickness: 1,
    color: Colors.indigo[900],
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
                title:  TextWidget('Are you sure you want to Exit?', 18, FontWeight.normal, Colors.black),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => {Navigator.pop(context, 'Cancel'),_scaffoldKey.currentState?.openEndDrawer(),},
                    child: TextWidget('Cancel', 16, FontWeight.normal, Colors.indigo.shade700),
                  ),
                  TextButton(
                    onPressed: () => {
                      if (Platform.isAndroid) {
                        SystemNavigator.pop()
                      } else if (Platform.isIOS) {
                        exit(0)
                      }
                    },
                    child: TextWidget('OK', 14, FontWeight.normal,Colors.indigo.shade700),
                  ),
                ],
              ),
            )
        );
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.indigo[100],
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: Builder(
            builder: (context) => IconButton(
              icon: const Icon(
                Icons.menu,
                color: Colors.black,
              ),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
          centerTitle: true,
          title: Text('Home',style: TextStyle(color: Colors.grey.shade800),),
          elevation: 0.0,
          actions: [
            IconButton(
              icon: const Icon(
                Icons.logout_rounded,
                color: Colors.black,
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
                      title: TextWidget('Are you sure you want to Logout?', 15, FontWeight.normal,Colors.indigo.shade700),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => {Navigator.pop(context, 'Cancel'),_scaffoldKey.currentState?.openEndDrawer(),},
                          child: TextWidget('Cancel', 15, FontWeight.normal,Colors.indigo.shade700),
                        ),
                        TextButton(
                          onPressed: () => {
                            signOut(),
                            _scaffoldKey.currentState?.openEndDrawer(),
                          },
                          child: TextWidget('OK', 15, FontWeight.normal,Colors.indigo.shade700),
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
          backgroundColor: Colors.indigo[100],
          child: ListView(
            children: [
              DrawerHeader(
                padding: const EdgeInsets.fromLTRB(20,20,20,0),
                margin: EdgeInsets.only(bottom: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                     CircleAvatar(
                      backgroundColor: Colors.white,
                      radius:40,
                      child: Icon(
                        Icons.person,
                        size: 60,
                        color: Colors.indigo.shade900,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        'localUserName',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.indigo[900],
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
                visualDensity: VisualDensity(vertical: -3),
                leading: Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Icon(Icons.person, color: Colors.indigo[900],),
                ),
                title: Text('Edit Profile Details',style: TextStyle( color: Colors.indigo[900],),),
                onTap: (){},
              ),
              divider,
              ListTile(
                  dense: true,
                  visualDensity: VisualDensity(vertical: -3),
                  leading: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Icon(Icons.payment_rounded, color: Colors.indigo[900],),
                  ),
                  title: Text('Payment History',style: TextStyle( color: Colors.indigo[900],),),
                  onTap: (){
                    _scaffoldKey.currentState?.openEndDrawer();
                    Get.to(PaymentHistoryPage());
                  }
              ),
              divider,
            ],
          ),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GridView.builder(
                        itemCount: titleList.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 3.5 / 2,
                            crossAxisSpacing: 0,
                            mainAxisSpacing: 0
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
                                              Text('Book Appointment for...',style: TextStyle(fontSize: 16,color: Colors.indigo.shade900,fontWeight: FontWeight.bold,),),
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
                                                      Text('Tele Consultation',style: TextStyle(fontSize: 16,color: Colors.indigo.shade800,fontWeight: FontWeight.w500),)
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
                                                      Text('Pathology',style: TextStyle(fontSize: 16,color: Colors.indigo.shade800,fontWeight: FontWeight.w500),)
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
                            },
                            child: Container(
                              margin: const EdgeInsets.all(15),
                              child: homeCommonContainer(
                                titleList[index].color,
                                titleList[index].title,),
                            ),
                          );
                        }
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: const[
                  Text(
                    "Powered By",
                    style: TextStyle(fontSize: 15),
                  ),
                  Text(
                    "Artem Healthtech Pvt Ltd",
                    style: TextStyle(fontSize: 18, color: Colors.blueAccent),
                  ),
                  SizedBox(
                    height: 10,
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