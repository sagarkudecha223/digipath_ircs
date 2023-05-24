import 'package:digipath_ircs/Design/ColorFillContainer.dart';
import 'package:digipath_ircs/Design/TopPageTextViews.dart';
import 'package:digipath_ircs/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Global/global.dart';

class MultiAccountPage extends StatefulWidget {
  const MultiAccountPage({Key? key}) : super(key: key);

  @override
  State<MultiAccountPage> createState() => _MultiAccountPageState();
}

class _MultiAccountPageState extends State<MultiAccountPage> {

  void setLocalData(String locitizenIDP, String lousername ,String louserLoginIDP) async{

    SharedPreferences preferences = await SharedPreferences.getInstance();

    preferences.setString('citizenIDP', locitizenIDP);
    preferences.setString('userName', lousername);
    preferences.setString('userLoginIDP', louserLoginIDP);
    preferences.setString('mobile', localMobileNum);
    preferences.setBool("loggedIn", true);

    localCitizenIDP = locitizenIDP;
    localUserName = lousername;
    localUserLoginIDP = louserLoginIDP;

    Get.offAll(HomePage());

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo.shade100,
        elevation: 0.0,
      ),
      body: Container(
        color: Colors.indigo.shade100,
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            const SizedBox(height: 30,),
            TopPageTextViews('CITIZEN LIST', 'Registration with Mobile No: $localMobileNum'),
            SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    decoration: ColorFillContainer(Colors.white),
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(15),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: accountList.length,
                      itemBuilder: (context,index){
                        return InkWell(
                          onTap: (){
                            setLocalData(accountList[index].citizenIDP,accountList[index].userName,accountList[index].userLoginIDP);
                          },
                          child: Container(
                            margin: EdgeInsets.all(5),
                            padding: EdgeInsets.all(15),
                            decoration: ColorFillContainer(Colors.indigo.shade100),
                            child: Text( accountList[index].userName,style: TextStyle(fontWeight: FontWeight.w600,color: Colors.black,fontSize: 18),),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
