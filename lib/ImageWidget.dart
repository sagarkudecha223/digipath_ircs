import 'dart:io';
import 'dart:typed_data';
import 'package:digipath_ircs/Global/Colors.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'AddRecord/SecondUploadDocumentPage.dart';
import 'Global/global.dart';

class ImageWidget extends StatefulWidget {
  final String imageString;
  const ImageWidget({super.key, required this.imageString});

  @override
  State<StatefulWidget> createState() => _MyWidgetState(imageString);
}

class _MyWidgetState extends State<ImageWidget> with AutomaticKeepAliveClientMixin {

  late String imageString;

  _MyWidgetState(this.imageString);

  @override
  bool get wantKeepAlive => true;
  late Uint8List documentImage;
  bool isLoaded = false;
  bool loadingFail = false;
  late PhotoViewScaleStateController scaleStateController;

  @override
  void initState() {
    super.initState();
    scaleStateController = PhotoViewScaleStateController();
    getImageList();
  }
  void getImageList() async{

    print('image Url : $urlForINSC/getPatientDocumentFile_ByteArray.shc?documentName=$imageString' );

    try {
      Response response = await get(
          Uri.parse('$urlForINSC/getPatientDocumentFile_ByteArray.shc?documentName=$imageString'),
          headers: {
            'token': token
          }
      ).timeout(const Duration(seconds: 40),
          onTimeout: (){
            loadingFail = true;
            return Response('Error', 408);
          }
      );
      if (response.statusCode == 200) {
        documentImage = (response.bodyBytes);
        print(':::::${documentImage.length}');
        if(mounted){
          setState(() {
            isLoaded = true;
          });
        }
      }else if(response.statusCode == 408){
        if(mounted){
          setState((){
            loadingFail = true;
          });
        }
      }
    }
    catch (e) {
      if(mounted){
        print(e.toString());
      }
    }
  }

  @override
  void dispose() {
    scaleStateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      height: 200,
      padding: const EdgeInsets.only(left: 5),
      child: loadingFail? Center(child: InkWell(
        onTap: (){
          setState(() {
            loadingFail = false;
            isLoaded = false;
            getImageList();
          });
        },
        child: Icon(Icons.refresh,size: 40,color: globalBlue,))) :
      isLoaded?Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap : (){
              showDialog<String>(
                context: context,
                barrierColor:Colors.transparent,
                builder: (BuildContext context) => TweenAnimationBuilder(
                  tween: Tween<double>(begin: 0, end: 1),
                  duration: const Duration(milliseconds: 500),
                  builder: (BuildContext context, double value, Widget? child) {
                    return Opacity(opacity: value,
                      child: Padding(
                        padding: EdgeInsets.only(top: value * 1),
                        child: child,
                      ),
                    );
                  },
                  child: AlertDialog(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                    backgroundColor: Colors.transparent,
                    insetPadding: EdgeInsets.all(10),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: Row(mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              InkWell(child: Icon(Icons.cancel,size: 35,),
                                  onTap: ()=>{ Navigator.pop(context, 'Cancel')}),
                            ],),
                        ),
                        Container(
                            height: 300,
                            width: 300,
                            color: Colors.transparent,
                            child: PhotoView.customChild(
                              backgroundDecoration: BoxDecoration(color: Colors.transparent),
                              basePosition: Alignment.center,
                              minScale: PhotoViewComputedScale.contained * 1,
                              tightMode: true,
                              maxScale: PhotoViewComputedScale.covered * 2.0,
                              initialScale: PhotoViewComputedScale.contained * 1.1,
                              enableRotation: true,
                              scaleStateController: scaleStateController,
                              child: Container(
                                color: Colors.transparent,
                                width: 300,
                                height: 300,
                                child:isLoaded? Image.memory(documentImage) : const Center(child: CircularProgressIndicator()),
                              ),
                            )
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            child: Container(
              height: 200,
              width: 200,
              child: Image.memory(documentImage,
                frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                  if (wasSynchronouslyLoaded) {
                    return child;
                  } else {
                    return AnimatedOpacity(
                      opacity: frame == null ? 0 : 1,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeOut,
                      child: child,
                    );
                  }
                },
              ),
            ),
          ),
          FloatingActionButton(
            onPressed: ()async{
              Directory appDocDirectory = await getTemporaryDirectory();
              final myImagePath = "${appDocDirectory.path}/image.jpg";
              File file = await File(myImagePath).writeAsBytes(documentImage);
              print(file);
              Get.to(SecondUploadDocumentPage(filePath: file));
            },
            heroTag: null,
            backgroundColor: Colors.indigo,
            elevation: 0.0,
            tooltip: 'ADD TO RECORD',
            mini: true,
            child: const Icon(Icons.add_photo_alternate_rounded),),
        ],
      ): const Center(child: CircularProgressIndicator()),
    );
  }
}