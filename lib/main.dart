import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/route_manager.dart';
import 'SplashScreen.dart';

void main() {

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(const MyApp());
  configLoading();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DigiPath IRCS',
      theme: ThemeData(fontFamily: 'Ageo'),
      home: Splash(),
      builder: EasyLoading.init(),
    );
  }
}

void configLoading() {

  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 1000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
  // ..loadingStyle = isDarkMode?EasyLoadingStyle.light:EasyLoadingStyle.dark
    ..loadingStyle = EasyLoadingStyle.custom
    ..maskType = EasyLoadingMaskType.black
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.indigo.shade500
    ..backgroundColor = Colors.white
    ..indicatorColor = Colors.indigo.shade800
    ..textColor = Colors.indigo.shade500
    ..textStyle = TextStyle(fontWeight: FontWeight.bold,color: Colors.indigo[800])
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = false
    ..dismissOnTap = false;
  // ..customAnimation = CustomAnimation();
}



