import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:digipath_ircs/Global/Toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'dart:developer' as developer;
import '../Global/global.dart';

class InternetCheck{

  late BuildContext context;
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  Future<Object> initConnectivity() async {

    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(updateConnectionStatus);
    late ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      developer.log('Couldn\'t check connectivity status', error: e);
      return e;
    }
    return updateConnectionStatus(result);
  }

  Future<Object> updateConnectionStatus(ConnectivityResult result) async {

    _connectionStatus = result;
    print(':::'+_connectionStatus.toString());
    internetStatus = _connectionStatus.toString();
    if(internetStatus == 'ConnectivityResult.none'){

      EasyLoading.show(
        maskType: EasyLoadingMaskType.black,
        dismissOnTap: false,
        indicator: Container(
          width: 200,
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.wifi_off_rounded,size: 55,color: Colors.grey.shade600,),
              SizedBox(height: 15),
              Text('Connection Error',style: TextStyle(fontSize: 22,color: Colors.grey.shade600,fontWeight: FontWeight.bold),),
              SizedBox(height: 15),
              Text('Please check your Internet connection',style: TextStyle(fontSize: 14,color: Colors.grey.shade600,fontWeight: FontWeight.w500),textAlign: TextAlign.center),
              SizedBox(height: 15),
              InkWell(
                onTap: (){
                  if(internetStatus == 'ConnectivityResult.none'){
                    showToast('Please Check Internet Connectivity');
                  }
                  else{
                    EasyLoading.dismiss();
                  }
                },
                child: Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(left: 15,right: 15),
                  decoration: BoxDecoration(
                    color: Colors.blueGrey.shade400,
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                        width: 1.5,
                        color: Colors.grey
                    ),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.grey,
                          blurRadius: 4,
                          blurStyle: BlurStyle.outer,
                          spreadRadius: 0,
                          offset: Offset(0, 0)
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Text('  Try again  ',textAlign: TextAlign.center,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16),),
                  ),
                ),
              ),
              SizedBox(height: 15),
            ],
          ),
        ),
      );
    }
    else{
      EasyLoading.dismiss();
    }
    return result;
  }
}