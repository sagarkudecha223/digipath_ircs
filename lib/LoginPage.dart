import 'dart:async';
import 'package:digipath_ircs/ModalClass/MultiAccountModal.dart';
import 'package:digipath_ircs/MultiAccountPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/route_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Global/SearchAPI.dart';
import 'Global/Toast.dart';
import 'Global/global.dart';
import 'HomePage.dart';
import 'SignUpPage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  TextEditingController numberController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  bool otpTextBool = false;
  String buttonText  = 'GET OTP';
  bool _oldPasswordVisible = false;
  bool timerVisible = false;

  late Timer _timer;
  int _start = 90;

  void startTimer() {
    _start = 90;
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,(Timer timer) {
        if (_start == 0) {
          setState(() {
            buttonText  = 'GET OTP';
            otpTextBool = false;
            timerVisible = false;
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  void GetOTP(String number) async{

    FocusManager.instance.primaryFocus?.unfocus();

    dynamic status = await searchAPI(true ,'$urlForIN/getOTPForCitizenLoginByMobile_smarthealth_shc.do?mobile=$number',
        {'token': 'eyJhbGciOiJSUzI1NiJ9.eyJ1bmFtZSI6IjI2MDk3MTQ1NDA5MSIsInNlc3Npb25pZCI6IkQyN0I4QTBBQzNERjZCQzlEQUEwNUU2NTlDODk2NTk1Iiwic3ViIjoiSldUX1RPS0VOIiwianRpIjoiNWQxYWU3ZmYtMzJhOC00YWYxLWE4OTItODE1MWRiMDRlNzE3IiwiaWF0IjoxNjc4MTcyMTQzfQ.J4pK2XBzMaZNlgGAFxB1yFLUJoWKhzqHBKJbZfxwau7aBhMyb1ovWevVVgHQR5DsKJUhPbedNnhqvSOdLNO6uWn2qEwlGVpsslDCz1oftzA3NymnUF5xRoYoTkqjcM_3Raw6sVST9jAlw0hKmS_1tVJKBWdI1754FC-1o2qZ0mPOn-AT_1DGhWkFg88FRdtZAD2Zb7NUJ0vmvVlXzvkvhFEZsb-NksM4neAtWozUGqV-ZQ23JI21QDEZIC6Xj3khEJqNwVxNUrXH6CAdDU2QiDc7RJ6aN9HdqEdRvUSnvjA88qjBtQeNgp88rMMQ5g36WlzO0vQO4uO-Ek4pax9rpg',
        },{'mobile': number}, 45);

    print(' status after responce: $status');
    EasyLoading.dismiss();

    if(status.toString() != 'Sorry !!! Server Error' && status.toString().isNotEmpty  && status.toString() != 'Sorry !!!  Connectivity issue! Try again'){
      String statusinfo = status['status'].toString();
      if (statusinfo == "true") {
        otpTextBool = true;
        timerVisible = true;
        buttonText = 'SUBMIT OTP';
        setState(() {

        });
      }
      else{
        showToast('Invalid User ! This Mobile Number not register with us');
      }
    }
    else if(status.toString() == 'Sorry !!!  Connectivity issue! Try again'){
      showToast('Sorry !!!  Poor Internet Connectivity ! Try again');
    }
    else{
      showToast('Sorry !!! Server Error');
    }
  }

  void VerifyOTP(String number,OTP) async{

    accountList.clear();
    FocusManager.instance.primaryFocus?.unfocus();

    dynamic status = await searchAPI(true ,'$urlForIN/validateMobileOTP_smarthealth.notauth',
        {},{'otp':OTP, 'mobile':number }, 45);

    print(' status after responce: $status');
    EasyLoading.dismiss();

    if(status.toString() != 'Sorry !!! Server Error' && status.toString().isNotEmpty && status.toString() != 'Sorry !!!  Connectivity issue! Try again'){
      String statusinfo = status['status'].toString();
      if (statusinfo == "true") {

        List<dynamic> array = status['array'];
        localMobileNum = status['mobile'].toString();

        for(int i=0; i<array.length; i++){
          localCitizenIDP = array[i]['citizenIDP'].toString();
          localUserLoginIDP = array[i]['userLoginIDP'].toString();
          localUserName = array[i]['CitizenName'].toString();
          localCitizenCode = array[i]['CitizenCode'].toString();

          accountList.add(MultiAccountModal(citizenIDP: localCitizenIDP, userName: localUserName, userLoginIDP: localUserLoginIDP, CitizenCode: localCitizenCode));

        }

        showToast('Verification successfully completed !');
        navigateUser();
      }
      else{
        showToast('Problem in verifying OTP Or OTP is not valid!!!');
      }
    }
    else if(status.toString() == 'Sorry !!!  Connectivity issue! Try again'){
      showToast('Sorry !!!  Poor Internet Connectivity ! Try again');
    }
    else{
      showToast('Sorry !!! Server Error');
    }
  }

  void saveData(String citizenIDP,userName,userLoginIDP,CitizenName,mobile,CitizenCode) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('citizenIDP', citizenIDP);
    preferences.setString('userName', userName);
    preferences.setString('userLoginIDP', userLoginIDP);
    preferences.setString('CitizenName', CitizenName);
    preferences.setString('mobile', localMobileNum);
    preferences.setString('CitizenCode', localCitizenCode);
    preferences.setBool("loggedIn", true);
  }

  void navigateUser(){

    _timer.cancel();
    if(accountList.length ==1){
      saveData(localCitizenIDP, localUserName,localUserLoginIDP,localUserName,localMobileNum,localCitizenCode);
      Get.offAll(HomePage());
    }
    else{
      Get.offAll(MultiAccountPage());
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
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/login_screen.png"),
              fit: BoxFit.cover),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 50),
              child: Opacity(
                opacity: 1,
                child: Container(
                  decoration: (BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white70,
                  )),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15, top: 20,bottom: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(bottom: 2),
                          child: Text("MOBILE NUMBER",style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
                        ),
                        TextField(
                          readOnly: otpTextBool,
                          controller: numberController,
                          style: TextStyle(color: Colors.black),
                          decoration:  InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            filled: true,
                            fillColor: Colors.white60,
                            suffixIcon: Icon(Icons.phone_iphone_rounded,color: Colors.grey,),
                            hintText: "Mobile Number",
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                          maxLength: 10,
                          keyboardType: TextInputType.number,
                        ),
                        SizedBox(height: 10),
                        Visibility(
                          visible: otpTextBool,
                          child: TextField(
                            controller: otpController,
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white60,
                              hintText: "Enter OTP",
                              hintStyle: TextStyle(color: Colors.grey),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _oldPasswordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.grey,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _oldPasswordVisible = !_oldPasswordVisible;
                                    });
                                  },
                                ),
                            ),
                            obscureText: !_oldPasswordVisible,
                            maxLength: 6,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        Visibility(
                          visible: timerVisible,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Text('Time left $_start seconds',style: TextStyle(color: Colors.grey[900]),),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.green[500],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: InkWell(
                                onTap: () {
                                  if(numberController.text.toString().length !=10){
                                    showToast('Please Enter valid Mobile number');
                                  }
                                  else{
                                    if(otpTextBool == false){
                                      EasyLoading.show(status: 'Sending OTP...');
                                      startTimer();
                                      GetOTP(numberController.text.toString());
                                    }
                                    else{
                                      if(otpController.text.toString().length !=6){
                                        showToast('Please Enter valid OTP');
                                      }
                                      else{
                                        EasyLoading.show(status: 'Verifying OTP...');
                                        VerifyOTP(numberController.text.toString(),otpController.text.toString());
                                      }
                                    }
                                  }
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(buttonText, style: const TextStyle( color: Colors.white, fontWeight: FontWeight.bold),),
                                    const Icon(  Icons.arrow_forward, color: Colors.white,)
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 30.0, left: 5),
                          child: InkWell(
                            onTap: () {
                              FocusManager.instance.primaryFocus?.unfocus();
                              Get.to(SignUpPage(fromAddMember: false,));
                            },
                            child: Text(
                              "SIGN UP",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue[900],
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
