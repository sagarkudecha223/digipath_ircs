import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TestPage extends StatefulWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {

  @override
  void initState() {
    super.initState();
     readJSON();
  }

  void readJSON() async{

     dynamic response = await rootBundle.loadString('assets/JSON/demo.json');
     var status = jsonDecode(response.toString());
     var data = status["JsonResponse"];
     print(data);
     String finalStatus = data['Status'].toString();
    print(finalStatus);

}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(),
    );
  }
}
