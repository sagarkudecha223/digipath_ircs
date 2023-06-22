import 'dart:io';
import 'package:digipath_ircs/Design/ColorFillContainer.dart';
import 'package:digipath_ircs/Design/GlobalAppBar.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';
import '../Global/Colors.dart';
import '../ModalClass/SelectedImageModal.dart';
import 'SecondUploadDocumentPage.dart';

class AddRecordPage extends StatefulWidget {
  const AddRecordPage({Key? key}) : super(key: key);

  @override
  State<AddRecordPage> createState() => _AddRecordPageState();
}

class _AddRecordPageState extends State<AddRecordPage> {

  File? _image;
  CroppedFile? _croppedFile;
  bool imageSelected = false;
  final imagePicker = ImagePicker();
  late PhotoViewScaleStateController scaleStateController;
  List<SelectImageModal> selectedImageList = <SelectImageModal>[];
  late int selectedIndex = 100;

  @override
  void initState() {
    super.initState();
    scaleStateController = PhotoViewScaleStateController();
  }

  Future openGallery() async {
    final imageFile = await ImagePicker().pickImage(
        source: ImageSource.gallery);
    if (imageFile != null) {
      setState(() {
        _image=File(imageFile.path);
        _cropImage();
      });
    }
  }

  Future openCamera() async {
    final imageFile = await ImagePicker().pickImage(
        source: ImageSource.camera);
    if (imageFile != null) {
      setState(() {
        _image = File(imageFile.path);
        _cropImage();
      });
    }
  }

  Future<void> _cropImage() async {
    if (_image != null) {
      final croppedFile = await ImageCropper().cropImage(
          sourcePath: _image!.path,
          compressFormat: ImageCompressFormat.jpg,
          compressQuality: 100,
          uiSettings: [
            AndroidUiSettings(
                toolbarTitle: 'Cropper',
                toolbarColor: Colors.indigo.shade800,
                toolbarWidgetColor: Colors.white,
                initAspectRatio: CropAspectRatioPreset.original,
                lockAspectRatio: false),
            IOSUiSettings()
          ]
      );
      if (croppedFile != null) {

        setState(() {
          _croppedFile = croppedFile;
          _image = File(_croppedFile!.path);
          final bytes = _image?.readAsBytesSync().lengthInBytes;
          final kb = bytes! / 1024;
          print('KB :::::::::::: $kb');
          print('file IS : ${_image!.path}');
          selectedImageList.add(SelectImageModal(image: _image!, isSelected: false, size: kb));
          imageSelected = true;
        });
      }
      else{
        // show2Simple();
      }
    }
  }

  Future<void> show1Dialog() async{
    return showDialog<void>(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                insetPadding: const EdgeInsets.all(20),
                elevation: 16,
                child : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          InkWell(
                            onTap: () {
                              openCamera();
                              Navigator.pop(context, false);
                            },
                            child: Column(
                              children:  [
                                Icon(Icons.camera_alt, size: 35,color: Colors.grey.shade800,),
                                Text('CAMERA',style: TextStyle(fontWeight: FontWeight.w500,color: Colors.grey.shade800),)
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              openGallery();
                              Navigator.pop(context, false);
                            },
                            child: Column(
                              children: [
                                Icon(Icons.photo_library_rounded, size: 35,color: Colors.grey.shade800),
                                Text('Files',style: TextStyle(fontWeight: FontWeight.w500,color: Colors.grey.shade800))
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
        );
  }

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.indigo;
    }
    return Colors.indigo;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GlobalAppBar(context,'add record'),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: globalPageBackgroundColor,
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child:imageSelected?
                  Container(
                    margin: const EdgeInsets.only(left: 20,right: 20,top: 20,bottom: 20),
                    child: GridView.builder(
                       itemCount: selectedImageList.length,
                        shrinkWrap: true,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1 / 1.2,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20
                        ),
                        itemBuilder:(BuildContext context, int index){
                          return Container(
                            decoration: ColorFillContainer(Colors.white),
                            child: Stack(
                              clipBehavior: Clip.none,
                              alignment: AlignmentDirectional.center,
                              children:[
                                Image.file(selectedImageList[index].image,fit: BoxFit.fill,),
                                Positioned(
                                  bottom: 0.0,
                                  left: 0.0,
                                  child: Transform.scale(
                                    scale: 1.1,
                                    child: Checkbox(
                                      checkColor: Colors.white,
                                      fillColor: MaterialStateProperty.resolveWith(getColor),
                                      value: selectedIndex == index?true : false ,
                                      onChanged: (bool? value) {
                                        if(selectedIndex == index){
                                          setState((){
                                            selectedIndex =100;
                                          });
                                        }
                                        else{
                                          setState(() {
                                            selectedIndex = index;
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ]
                            ),
                          );
                        }
                    ),
                  )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: (){
                              show1Dialog();
                          },
                          child: Container(
                            decoration: ColorFillContainer(globalOrange),
                            padding: const EdgeInsets.only(left: 25,top: 12,right: 25,bottom: 12),
                            child: const Text('ADD',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white,fontSize: 16),),
                          ),
                        ),
                        const SizedBox(height: 10,),
                        Text('You have no scan images',style: TextStyle(color: globalBlue,fontWeight: FontWeight.bold,fontSize: 16),)
                      ],
              ),
            ),
            Visibility(
              visible: selectedIndex ==100? false : true,
              child: Padding(
                padding: const EdgeInsets.only(left: 20,right: 20,bottom: 3),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        margin: const EdgeInsets.all(3),
                        padding: const EdgeInsets.only(top: 12,bottom: 12,),
                        decoration: ColorFillContainer(globalOrange),
                        child: const Text('Delete',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),textAlign: TextAlign.center,),
                      ),
                    ),
                    Expanded(
                     child: InkWell(
                       onTap: (){
                         Get.to(SecondUploadDocumentPage(filePath : selectedImageList[selectedIndex].image));
                       },
                       child: Container(
                         decoration: ColorFillContainer(globalOrange),
                         margin: const EdgeInsets.all(3),
                         padding: const EdgeInsets.only(top: 12,bottom: 12,),
                         child: const Text('Add to Timeline',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),textAlign: TextAlign.center,),
                        ),
                     ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: Visibility(
        visible: imageSelected,
        child: Padding(
          padding: const EdgeInsets.only(right: 0.0,bottom: 45),
          child: FloatingActionButton(
            mini: true,
            elevation: 0,
            backgroundColor: Colors.indigo,
            onPressed: (){
              show1Dialog();
            },
            child: const Icon(Icons.add,color: Colors.white),
          ),
        ),
      ),
    );
  }
}
