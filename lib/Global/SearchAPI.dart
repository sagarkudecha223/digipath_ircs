import 'dart:convert';
import 'dart:io';
import 'package:digipath_ircs/Global/Toast.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart';
import 'package:http/io_client.dart';

Future<dynamic> searchAPI(bool isPost, String url, Map<String, String> headers, Map<String, String> body, int seconds, ) async{

  try {

    late Response response;
    print(url);

    // bool trustSelfSigned = true;
    // HttpClient httpClient = HttpClient()
    //   ..badCertificateCallback = ((X509Certificate cert, String host, int port) => trustSelfSigned);
    // IOClient ioClient = IOClient(httpClient);

    /// TO USE THIS --- ioClient.post OR ioClient.get

    if(isPost == true){
      response = await post(
          Uri.parse(url),
          headers: headers,
          body: body
      ).timeout(
        Duration(seconds: seconds),
        onTimeout: () {
          EasyLoading.dismiss();
          showToast('Sorry !!!  Connectivity issue! Try again');
          return Future.error('Poor Internet connectivity ! Try again'); // Request Timeout response status code
        },
      );
    }
    else{
      response = await get(
          Uri.parse(url),
          headers: headers,
      ).timeout(
        Duration(seconds: seconds),
        onTimeout: () {
          EasyLoading.dismiss();
          return Future.error('Poor Internet connectivity ! Try again'); // Request Timeout response status code
        },
      );
    }

    if (response.statusCode == 200) {
      return jsonDecode(response.body.toString());
    }
    else{
      return 'Sorry !!!  Connectivity issue! Try again';
    }
  }
  catch (e) {
    return 'Sorry !!! Server Error';
  }
}