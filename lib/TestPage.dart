import 'dart:io';
import 'package:digipath_ircs/ModalClass/HomePageTitleModal.dart';
import 'package:dio/dio.dart' as foo;
import 'package:flutter/material.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class TestPage extends StatefulWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {

  late final Permission _permission = Permission.storage;
  List<HomePagetitleModal> titleList = <HomePagetitleModal>[];

  @override
  void initState() {
    super.initState();
    requestPersmission();
    getTitle();
  }

  void requestPersmission() async {
    final status = await _permission.request();
    print(status);
  }

  void getTitle(){

    titleList.add(HomePagetitleModal(color: Colors.yellow.shade800, title: 'BOOK APPOINTMENT'));
    titleList.add(HomePagetitleModal(color: Colors.blueAccent, title: 'PAYMENT'));
    titleList.add(HomePagetitleModal(color: Colors.lightGreen, title: 'UPLOAD DOCUMENT'));
    titleList.add(HomePagetitleModal(color: Colors.lightBlue, title: 'VIEW REPORT'));
    titleList.add(HomePagetitleModal(color: Colors.orangeAccent, title: 'VIEW TIMELINE'));
    titleList.add(HomePagetitleModal(color: Colors.green.shade400, title: 'START TELE-CONSULTATION'));
    titleList.add(HomePagetitleModal(color: Colors.indigo.shade500, title: 'PRESCRIPTION'));

  }

  Container homeCommonContainer(Color colors,String text1){
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.blueAccent),
      child: Padding(
        padding: const EdgeInsets.only(left: 4.0),
        child: Center(
          child: Text(
            text1,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
              GridView.builder(
              itemCount: titleList.length,
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 3.5 / 2,
                  crossAxisSpacing: 0,
                  mainAxisSpacing: 0
              ),
              itemBuilder:(BuildContext context, int index){
                return Container(
                  margin: const EdgeInsets.all(15),
                  child: homeCommonContainer(
                      titleList[index].color,
                      titleList[index].title,),
                );
              }
          ),
        ],
      ),
    );
  }

  Future openFile({required String url, required String fileName}) async {
    final name = fileName ?? url.split('/').last;
    final file = await downloadFile(url,name!);

    if(file == null){
      return;
    }
    print('Path: ${file.path}');

    OpenFile.open(file.path);
  }

  Future<File?> downloadFile(String url, String name) async{

    final appStorage = await getApplicationDocumentsDirectory();
    final file = File('${appStorage.path}/$name');


    try {
      final response = await foo.Dio().get(
          url,
          options: foo.Options(
            responseType: foo.ResponseType.bytes,
            followRedirects: false,
            receiveTimeout: 0,
          )
      );

      final raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(response.data);
      await raf.close();

      return file;
    }
    catch(e){
      return null;
    }
  }

}
