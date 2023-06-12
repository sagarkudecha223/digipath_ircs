import 'dart:convert';
import 'package:digipath_ircs/Design/GlobalAppBar.dart';
import 'package:digipath_ircs/Global/Toast.dart';
import 'package:digipath_ircs/Global/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/route_manager.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Design/ColorFillContainer.dart';
import '../Design/TopPageTextViews.dart';
import '../HomePage.dart';
import '../ModalClass/MultiAccountModal.dart';

class SwitchUserPage extends StatefulWidget {
  const SwitchUserPage({Key? key}) : super(key: key);

  @override
  State<SwitchUserPage> createState() => _SwitchUserPageState();
}

class _SwitchUserPageState extends State<SwitchUserPage> {

  @override
  void initState() {
    super.initState();

    EasyLoading.show(status: 'Loading...');
    getAccount();

  }

  void setLocalData(String locitizenIDP, String lousername ,String louserLoginIDP, String citizenCode) async{

    SharedPreferences preferences = await SharedPreferences.getInstance();

    preferences.setString('citizenIDP', locitizenIDP);
    preferences.setString('userName', lousername);
    preferences.setString('userLoginIDP', louserLoginIDP);
    preferences.setString('mobile', localMobileNum);
    preferences.setString('CitizenCode', citizenCode);
    preferences.setBool("loggedIn", true);

    localCitizenIDP = locitizenIDP;
    localUserName = lousername;
    localUserLoginIDP = louserLoginIDP;
    localCitizenCode = citizenCode;

    Get.offAll(HomePage());

  }

  getAccount() async{

    accountList.clear();

    try{

      Response response = await post( Uri.parse('$urlForIN/mobileNumberwisePatientList.notauth?mobile=$localMobileNum'),
        headers: {
          "token" : token
        }
      );

      EasyLoading.dismiss();

      if(response.statusCode == 200){
        var status = jsonDecode(response.body.toString());
        print(status);

        List<dynamic> array = status['array'];
        localMobileNum = status['mobile'].toString();

        for(int i=0; i<array.length; i++){
          String citizenIDP = array[i]['citizenIDP'].toString();
          String userLoginIDP = array[i]['userLoginIDP'].toString();
          String CitizenName = array[i]['CitizenName'].toString();
          String CitizenCode = array[i]['CitizenCode'].toString();

          accountList.add(MultiAccountModal(citizenIDP: citizenIDP, userName: CitizenName, userLoginIDP: userLoginIDP, CitizenCode: CitizenCode));
        }

        setState(() {

        });

      }
      else{
        showToast('Sorry !!! Connection issue');
      }

    }catch(e){
      EasyLoading.dismiss();
      showToast('Sorry !!! Connection issue');
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GlobalAppBar(context,'Switch User'),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.indigo.shade100,
        child: Column(
          children: [
            TopPageTextViews('Registered with mobile No: $localMobileNum'),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(left: 20,right: 20,top: 20,bottom: 20),
                margin: const EdgeInsets.only(left: 15,right: 15,top: 10,bottom: 10),
                decoration: PageMainContainterDecoration(),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: accountList.length,
                  itemBuilder: (context,index){
                    return InkWell(
                      onTap: (){
                        setLocalData(accountList[index].citizenIDP,accountList[index].userName,accountList[index].userLoginIDP,accountList[index].CitizenCode);
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
            )
          ],
        ),
      ),
    );
  }
}
