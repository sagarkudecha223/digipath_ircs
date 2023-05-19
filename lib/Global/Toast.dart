import 'package:fluttertoast/fluttertoast.dart';

void showToast(String text){

  Fluttertoast.showToast(
      msg: text.toString(),
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      fontSize: 16.0
  );
}