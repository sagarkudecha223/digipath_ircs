import 'dart:async';
import 'package:digipath_ircs/LoginPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/route_manager.dart';
import 'Design/ColorFillContainer.dart';
import 'Global/SearchAPI.dart';
import 'Global/Toast.dart';
import 'Global/global.dart';

class OTPPage extends StatefulWidget {
  const OTPPage({Key? key}) : super(key: key);

  @override
  State<OTPPage> createState() => _OTPPageState();
}

class _OTPPageState extends State<OTPPage> {

  TextEditingController otpController = TextEditingController();
  bool otpTextBool = false;
  bool _oldPasswordVisible = false;
  String buttonText = 'Verify';

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void VerifyOTP(String OTP) async{

    accountList.clear();
    EasyLoading.show(status: 'Verifying OTP...');

    dynamic status = await searchAPI(true ,'$urlForIN/submitOTP_smarthealth_shc.notauth',{},
      {
        'otp': OTP,
        'mobile':mobile,
        'citizenID':citizenID
      },70);

    print('status after response is : $status');
    EasyLoading.dismiss();

    if(status.toString() != 'Sorry !!! Server Error' && status.toString().isNotEmpty  && status.toString() != 'Sorry !!!  Connectivity issue! Try again'){

      String statusInfo = status['status'].toString();
      if(statusInfo == 'true'){

        showToast(status['message'].toString());
        Get.offAll(LoginPage());

      }else{
        showToast('OTP is not valid...Try Again');
      }

    }else{
      showToast('Sorry !!! Server Error');
    }
  }

  void reSendOTP() async{

    EasyLoading.show(status: 'Re-sending OTP...');
    dynamic status = await searchAPI(true ,'$urlForIN/resendVerificationSMS.notauth',{},
        {
          'citizenID': citizenID,
          'loginID':ULID,
          'mobileNo':mobile
        },70);

    print('status after response is : $status');
    EasyLoading.dismiss();

    if(status.toString() != 'Sorry !!! Server Error' && status.toString().isNotEmpty  && status.toString() != 'Sorry !!!  Connectivity issue! Try again'){

      String statusInfo = status['status'].toString();

      if(statusInfo == 'true'){

       showToast(status['message'].toString());
        setState(() {
          otpController.clear();
          _start = 90;
          startTimer();
          buttonText = 'Verify';
          otpTextBool = false;
        });
      }
    }else{
      showToast('Sorry !!! Server Error');
    }

  }

  late Timer _timer;
  int _start = 90;

  void startTimer() {
    _start = 90;
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,(Timer timer) {
      if (_start == 0) {
        setState(() {
          otpTextBool = true;
          buttonText = 'Re-Send OTP';
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

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 15,bottom: 15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children:  [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Visibility(
                visible: otpTextBool,
                child: InkWell(
                    onTap : (){
                      Navigator.pop(context);
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.cancel,size: 26,color: Colors.blueGrey),
                    )),
              )
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text('OTP send Successfully',style: TextStyle(color: Colors.indigo,fontWeight: FontWeight.w600),),
              const SizedBox(height: 10,),
              const Padding(
                padding: EdgeInsets.only(left: 10.0,right: 10,top: 5,bottom: 5),
                child: Text('Enter OTP press on verify to complete registration process',textAlign: TextAlign.center,style: TextStyle(color: Colors.indigo,fontWeight: FontWeight.w600),),
              ),
              const SizedBox(height: 20,),
              Visibility(
                visible: !otpTextBool,
                child: TextField(
                  controller: otpController,
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white60,
                    hintText: "Enter OTP",
                    hintStyle: const TextStyle(color: Colors.grey),
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
              const SizedBox(height: 20,),
              InkWell(
                onTap: (){
                  FocusManager.instance.primaryFocus?.unfocus();
                  if(otpController.text.length ==6){
                    if(otpTextBool == false){
                      VerifyOTP(otpController.text.toString());
                    }else{
                      reSendOTP();
                    }
                  }else{
                    showToast('Please enter valid OTP');
                  }
                },
                child: Container(
                  width: double.infinity,
                  decoration: ColorFillContainer(Colors.indigo.shade300),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(buttonText,style: const TextStyle(color: Colors.white,fontWeight: FontWeight.w600),textAlign: TextAlign.center,),
                  ),
                ),
              ),
              const SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        image: DecorationImage(image: AssetImage("assets/images/otp_varify.png"))
                    ),
                    padding: const EdgeInsets.only(left: 30,top: 30),
                    height: 50,
                    width: 50,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Text(otpTextBool?'TIMED OUT' : _start.toString(),style: TextStyle(color: Colors.indigo[900],fontSize: 20,fontWeight: FontWeight.bold),),
                  ),
                  const SizedBox(
                    width: 10,
                  )
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
