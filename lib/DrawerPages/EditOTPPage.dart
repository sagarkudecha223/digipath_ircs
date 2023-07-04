import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../Design/ColorFillContainer.dart';
import '../Global/SearchAPI.dart';
import '../Global/Toast.dart';
import '../Global/global.dart';

class EditOTPPage extends StatefulWidget {
  final String submitUrl;
  const EditOTPPage({Key? key, required this.submitUrl}) : super(key: key);

  @override
  State<EditOTPPage> createState() => _EditOTPPageState(submitUrl);
}

class _EditOTPPageState extends State<EditOTPPage> {

  TextEditingController otpController = TextEditingController();
  bool otpTextBool = false;
  bool _oldPasswordVisible = false;
  String buttonText = 'Verify';
  String submitUrl;
  late Timer _timer;
  int _start = 90;

  _EditOTPPageState(this.submitUrl);

  @override
  void initState() {
    super.initState();
    sendOTP();
  }

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

  void sendOTP() async{

    EasyLoading.show(status: 'Sending OTP...');

    dynamic status = await searchAPI(true ,'$urlForINSC/resendOTPSMS.shc?citizenID=$localCitizenIDP&loginID=$localUserLoginIDP&mobileNo=$localMobileNum&SMSFor=contactUpdate',
        {'token' : token},{}, 25);

    print(' status after responce: $status');
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
      Navigator.pop(context);
      showToast('Sorry !!! Server Error');
    }

  }

  void oTPVerification(String OTP) async{

    EasyLoading.show(status: 'Verifying OTP...');

    dynamic status = await searchAPI(true ,'$urlForINSC/OTP_Verification.shc?otp=$OTP&mobile=$localMobileNum',
        {'token' : token},{}, 50);

    print(' status after responce: $status');
    EasyLoading.dismiss();

    if(status.toString() != 'Sorry !!! Server Error' && status.toString().isNotEmpty  && status.toString() != 'Sorry !!!  Connectivity issue! Try again'){

      String statusInfo = status['status'].toString();
      if(statusInfo == 'true'){

        showToast(status['message'].toString());
        submitPhoneNumberInfo();

      }else{
        showToast('OTP is not valid...Try Again');
      }

    }else{
      showToast('Sorry !!! Server Error');
    }

  }

  void submitPhoneNumberInfo() async{

    EasyLoading.show(status: 'Submitting Mobile number...');

    dynamic status = await searchAPI(true ,submitUrl,
        {'token' : token},{}, 50);

    print(' status after response: $status');
    EasyLoading.dismiss();

    if(status.toString() != 'Sorry !!! Server Error' && status.toString().isNotEmpty  && status.toString() != 'Sorry !!!  Connectivity issue! Try again') {
      String statusInfo = status['status'].toString();

      if (statusInfo == 'true') {
        Navigator.pop(context,'true');
      }
      else {
        showToast('Sorry, Server Error !!! Try again');
      }
    }
  }

  Padding divider() {
    return  const Padding(
      padding: EdgeInsets.only(top: 5.0,bottom: 5.0),
      child: Divider(
        thickness: 1,
        color: Colors.grey,
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Container(
        padding: const EdgeInsets.only(top: 5,bottom: 15),
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
                        padding: EdgeInsets.only(right: 8.0,bottom: 8.0),
                        child: Icon(Icons.cancel,size: 26,color: Colors.blueGrey),
                      )
                  ),
                )
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(otpTextBool?'Please Re-send the OTP' : 'OTP send Successfully',style: TextStyle(color: Colors.indigo,fontWeight: FontWeight.w600),),
                const SizedBox(height: 10,),
                const Padding(
                  padding: EdgeInsets.only(left: 10.0,right: 10,top: 5,bottom: 5),
                  child: Text('Enter OTP press on verify to complete edit contact number process',textAlign: TextAlign.center,style: TextStyle(color: Colors.indigo,fontWeight: FontWeight.w600),),
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
                    if(otpTextBool == true){
                      sendOTP();
                    }else{
                      if(otpController.text.length ==6){
                        oTPVerification(otpController.text.toString());
                      }else{
                        showToast('Please enter valid OTP');
                      }
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
      ),
    );
  }
}
