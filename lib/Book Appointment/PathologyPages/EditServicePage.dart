import 'package:flutter/material.dart';
import '../../Design/ColorFillContainer.dart';
import '../../Global/global.dart';
import 'ServicePage.dart';

class EditServicePage extends StatefulWidget {
  const EditServicePage({Key? key}) : super(key: key);

  @override
  State<EditServicePage> createState() => _EditServicePageState();
}

class _EditServicePageState extends State<EditServicePage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
            onTap: (){
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_rounded,color: Colors.indigo[900])),
        elevation: 0,
        backgroundColor: Colors.indigo.shade100,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.indigo.shade100,
        child: Column(
          children: [
            Text('Edit Pathology Services', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.indigo[900]),),
            Flexible(
              child: Container(
                margin: EdgeInsets.only(left: 20,right: 20,bottom: 10,top: 5),
                padding: EdgeInsets.all(10),
                decoration: ColorFillContainer(Colors.white),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      ServicePage(),
                      SizedBox(height: 5),
                      InkWell(
                        onTap: (){
                           Navigator.pop(context,selectedServiceList);
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 20,bottom: 10),
                          width: double.infinity,
                          decoration: ColorFillContainer(Colors.green),
                          child: const Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text('OK',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500),textAlign: TextAlign.center,),
                          ),
                        ),
                      )
                    ],
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
