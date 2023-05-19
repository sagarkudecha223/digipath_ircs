import 'package:digipath_ircs/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Global/global.dart';
import 'LoginPage.dart';
import 'Services/InternetCheck.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  @override
  void initState() {
    super.initState();

    InternetCheck().initConnectivity();
    getData();
    Future.delayed(const Duration(seconds: 2),(){
      navigateUser();
    });
  }

  void getData() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    loggedIn = preferences.getBool("loggedIn")!;
    localCitizenIDP = preferences.getString('citizenIDP')!;
    localUserName = preferences.getString('userName')!;
    localUserLoginIDP = preferences.getString('userLoginIDP')!;
    localMobileNum = preferences.getString('mobile')!;

    print('get Data form Local Starage ::: + $localCitizenIDP + $localUserName + $localUserLoginIDP + $localCitizenName + $localMobileNum');
  }

  void navigateUser(){

    if(loggedIn == true){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
    }else{
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: const Center(
       child: Text('Splash !!!')
      ),
    );
  }
}
