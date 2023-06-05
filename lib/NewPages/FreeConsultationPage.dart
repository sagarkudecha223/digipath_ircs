import 'package:digipath_ircs/Design/ColorFillContainer.dart';
import 'package:digipath_ircs/Design/TopPageTextViews.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';
import 'package:permission_handler/permission_handler.dart';
import '../Design/GlobalAppBar.dart';
import '../ModalClass/AnswerModal.dart';
import 'RecordingPart.dart';

class FreeConsultationPage extends StatefulWidget {
  const FreeConsultationPage({Key? key}) : super(key: key);

  @override
  State<FreeConsultationPage> createState() => _FreeConsultationPageState();
}

class _FreeConsultationPageState extends State<FreeConsultationPage> with WidgetsBindingObserver{

  String selectedQuestion = '';
  int selectedButton = 1;
  TextEditingController textController = TextEditingController();
  List<AnswerModal> answerList = <AnswerModal>[];
  String language = 'English';
  List categoryList = [];
  final _modelManager = OnDeviceTranslatorModelManager();
  final _sourceLanguage = TranslateLanguage.english;
  late TranslateLanguage _targetLanguage = TranslateLanguage.hindi;
  late OnDeviceTranslator _onDeviceTranslator = OnDeviceTranslator(sourceLanguage: _sourceLanguage, targetLanguage: _targetLanguage);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    getAnswerList();
  }

  void getAnswerList() async{

    answerList.clear();
    categoryList.clear();

    categoryList.add('Related to blood & Blood Producer');
    categoryList.add('Related to Blood Transfusion');
    categoryList.add('Related to Iron Overload');
    categoryList.add('Related to');
    categoryList.add('Related to bone marrow Transplant');

    answerList.add(AnswerModal(title: 'Quality', isChecked: false, selectedButton: 1));
    answerList.add(AnswerModal(title: 'Dosage', isChecked: false, selectedButton: 1));
    answerList.add(AnswerModal(title: 'Different Producer', isChecked: false, selectedButton: 1));
    answerList.add(AnswerModal(title: 'Quality of Blood', isChecked: false, selectedButton: 1));

    answerList.add(AnswerModal(title: 'Facilities', isChecked: false, selectedButton: 2));
    answerList.add(AnswerModal(title: 'Transfusion related reactions', isChecked: false, selectedButton: 2));
    answerList.add(AnswerModal(title: 'Haemoglobin levels are not maintained', isChecked: false, selectedButton: 2));

    answerList.add(AnswerModal(title: 'How to Determine', isChecked: false, selectedButton: 3));
    answerList.add(AnswerModal(title: 'Availability of Iron chelation', isChecked: false, selectedButton: 3));
    answerList.add(AnswerModal(title: 'Not Responding to chelation Therapy', isChecked: false, selectedButton: 3));
    answerList.add(AnswerModal(title: 'Side effects of Iron chelation drugs', isChecked: false, selectedButton: 3));

    answerList.add(AnswerModal(title: 'Monitoring for', isChecked: false, selectedButton: 4));
    answerList.add(AnswerModal(title: 'Associated illness', isChecked: false, selectedButton: 4));
    answerList.add(AnswerModal(title: 'Management', isChecked: false, selectedButton: 4));

    answerList.add(AnswerModal(title: 'Eligibility', isChecked: false, selectedButton: 5));
    answerList.add(AnswerModal(title: 'Procedure', isChecked: false, selectedButton: 5));
    answerList.add(AnswerModal(title: 'Financial', isChecked: false, selectedButton: 5));
    answerList.add(AnswerModal(title: 'Option for no matching Donor in Family', isChecked: false, selectedButton: 5));

      if(language == 'English'){
        setState(() {
          EasyLoading.dismiss();
        });
      }
      else {
        mlKitTranslate();
      }
  }

  void mlKitTranslate() async{

    EasyLoading.show(status: 'Changing Language to $language');

    List tempCatList = [];
    tempCatList.addAll(categoryList);
    categoryList.clear();

    for(int i=0; i<tempCatList.length; i++){
      final result = await _onDeviceTranslator.translateText(tempCatList[i]);
      print('Result is :::::::: $result');
      categoryList.add(result.toString());
    }

    List<AnswerModal> tempList = <AnswerModal>[];
    tempList.addAll(answerList);
    answerList.clear();

    for(int i=0; i<tempList.length; i++){
      final result = await _onDeviceTranslator.translateText(tempList[i].title);
      print('Result is :::::::: $result');
      answerList.add(AnswerModal(title: result.toString(), isChecked: tempList[i].isChecked, selectedButton: tempList[i].selectedButton));
    }

    setState(() {
      EasyLoading.dismiss();
    });
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

  Future<bool> checkPermission() async {
    if (!await Permission.microphone.isGranted) {
      PermissionStatus status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        return false;
      }
    }
    return true;
  }

  @override
  void dispose() {
    EasyLoading.dismiss();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    setState(() {
      print('Change State :::');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GlobalAppBar(context),
      body: Container(
        color: Colors.indigo.shade100,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TopPageTextViews('QUESTIONNAIRE','THALASSEMIA CARE'),
                    Container(
                      padding: EdgeInsets.all(20),
                      margin: EdgeInsets.only(left: 20,right: 20,bottom: 5),
                      decoration: ColorFillContainer(Colors.white),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Select Category',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.indigo),),
                              InkWell(
                                onTap: (){
                                  showDialog<String>(
                                      context: context,
                                      builder: (context) =>Dialog(
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                          insetPadding: EdgeInsets.all(20),
                                          elevation: 16,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.indigo[300],
                                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20)),
                                                ),
                                                height: 50,
                                                child: const Center(child: Text('Select Language',textScaleFactor: 1.0,style: TextStyle(color:Colors.white,fontSize: 19,fontWeight: FontWeight.w500,),)),
                                              ),
                                              RadioListTile(
                                                title: const Text('English'),
                                                value: "English",
                                                groupValue: language,
                                                onChanged: (value){
                                                  setState(() {
                                                    language = value.toString();
                                                    Navigator.pop(context, 'Cancel');
                                                    getAnswerList();
                                                  }
                                                  );
                                                },
                                              ),
                                              RadioListTile(
                                                title: Text('Hindi'),
                                                value: "Hindi",
                                                groupValue: language,
                                                onChanged: (value){
                                                  setState(() {
                                                    language = value.toString();
                                                    _targetLanguage = TranslateLanguage.hindi;
                                                    _onDeviceTranslator = OnDeviceTranslator(sourceLanguage: _sourceLanguage, targetLanguage: _targetLanguage);
                                                    print(_onDeviceTranslator.targetLanguage);
                                                    Navigator.pop(context, 'Cancel');
                                                    getAnswerList();
                                                  }
                                                  );
                                                },
                                              ),
                                              RadioListTile(
                                                title: Text('Gujarati'),
                                                value: "Gujarati",
                                                groupValue: language,
                                                onChanged: (value){
                                                  setState(() {
                                                    language = value.toString();
                                                    _targetLanguage = TranslateLanguage.gujarati;
                                                    _onDeviceTranslator = OnDeviceTranslator(sourceLanguage: _sourceLanguage, targetLanguage: _targetLanguage);
                                                    print(_onDeviceTranslator.targetLanguage);
                                                    Navigator.pop(context, 'Cancel');
                                                    getAnswerList();
                                                  }
                                                  );
                                                },
                                              ),
                                              RadioListTile(
                                                title: Text('Marathi'),
                                                value: "Marathi",
                                                groupValue: language,
                                                onChanged: (value){
                                                  setState(() {
                                                    language = value.toString();
                                                    _targetLanguage = TranslateLanguage.marathi;
                                                    _onDeviceTranslator = OnDeviceTranslator(sourceLanguage: _sourceLanguage, targetLanguage: _targetLanguage);
                                                    print(_onDeviceTranslator.targetLanguage);
                                                    Navigator.pop(context, 'Cancel');
                                                    getAnswerList();
                                                  }
                                                  );
                                                },
                                              ),
                                            ],
                                          )
                                      ));
                                  FocusManager.instance.primaryFocus?.unfocus();
                                },
                                child: Icon(Icons.g_translate_rounded,size: 30,color: Colors.indigo,)
                              ),
                            ],
                          ),
                          const Divider(
                            color: Colors.grey,
                            thickness: 1,
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: categoryList.length,
                            itemBuilder: (context, index){
                              return RadioListTile(
                                  title: Text(categoryList[index].toString()),
                                  value: index+1,
                                  activeColor: Colors.indigo,
                                  groupValue: selectedButton,
                                  onChanged: (value){
                                    setState(() {
                                      selectedButton = value!;
                                    });
                                  }
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(20),
                      margin: const EdgeInsets.only(left: 20,right: 20,bottom: 5),
                      decoration: ColorFillContainer(Colors.white),
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: answerList.length,
                        itemBuilder: (context,index){
                          return Visibility(
                            visible: selectedButton == answerList[index].selectedButton,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(child: Text(answerList[index].title,style: const TextStyle(fontSize: 15,fontWeight: FontWeight.w600,color: Colors.indigo),)),

                                Checkbox(
                                  checkColor: Colors.white,
                                  value: answerList[index].isChecked,
                                  fillColor: MaterialStateProperty.resolveWith(getColor),
                                  onChanged: (bool? value) {
                                    setState(() {
                                      answerList[index].isChecked = value!;
                                    });
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    Container(
                      decoration: ColorFillContainer(Colors.white),
                      padding: EdgeInsets.all(20),
                      margin: EdgeInsets.only(left: 20,right: 20,bottom: 5),
                      child: TextField(
                        controller: textController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Enter Text'
                        ),
                        maxLines: 3,
                        maxLength: 50,
                      ),
                    ),
                    Container(
                      decoration: ColorFillContainer(Colors.white),
                      padding: EdgeInsets.all(20),
                      margin: EdgeInsets.only(left: 20,right: 20,bottom: 5),
                      child: RecordingPart(),
                    ),
                  ],
                ),
              ),
            ),
            Visibility(
              visible: WidgetsBinding.instance.window.viewInsets.bottom == 0.0,
              child: Container(
                width: double.infinity,
                decoration: ColorFillContainer(Colors.lightGreen),
                padding: EdgeInsets.all(12),
                margin: EdgeInsets.only(left: 20,right: 20,bottom: 5,top: 2),
                child: Text('submit'.toUpperCase(),style: TextStyle(fontWeight: FontWeight.w600,color: Colors.white,fontSize: 15),textAlign: TextAlign.center,),
              ),
            )
          ],
        ),
      ),
    );
  }

}
