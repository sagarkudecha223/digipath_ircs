import 'dart:async';
import 'dart:ui';
import 'package:digipath_ircs/Design/TopPageTextViews.dart';
import 'package:digipath_ircs/Global/Colors.dart';
import 'package:digipath_ircs/Global/ShowGlobalDialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'Design/BorderContainer.dart';
import 'Global/SearchAPI.dart';
import 'Global/TextFieldDecoration.dart';
import 'Global/Toast.dart';
import 'Global/global.dart';
import 'ModalClass/SearchCityModal.dart';
import 'OTPpage.dart';

class SignUpPage extends StatefulWidget {
  final bool fromAddMember;
  const SignUpPage({Key? key, required this.fromAddMember}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState(fromAddMember);
}

class _SignUpPageState extends State<SignUpPage> {

  TextEditingController personName = TextEditingController();
  TextEditingController middleName = TextEditingController();
  TextEditingController familyName = TextEditingController();
  TextEditingController mobileNumber = TextEditingController();
  TextEditingController emailAddress = TextEditingController();
  TextEditingController addressController = TextEditingController();
  String genderText = 'Select Gender';
  String genderIDF = '';
  String maritalStatusText = 'Marital Status';
  String maritalStatusIDF = '';
  bool personNamevalid = false;
  bool familyNamevalid = false;
  bool numbervalid = false;
  bool gendervalid = false;
  bool maritalStatusvalid = false;
  bool cityvalid = false;
  bool seachCityView = false;
  bool mStatusList = false;
  String startDate =DateFormat('dd-MMM-yyyy').format(DateTime.now());
  DateTime selectedStartDate = DateTime.now();
  String cityText = 'Select City';
  String cityID = '';
  List<SearchCityModal> citylist =  <SearchCityModal>[];
  List<MeritalStatus> meritalStatulList =  <MeritalStatus>[];
  TextEditingController seachCity = TextEditingController();
  bool filterColumn = false;
  bool onBack = true;
  List<SearchCityModal> filterlist =  <SearchCityModal>[];
  late bool fromAddMember;

  _SignUpPageState(this.fromAddMember);

  void changeText(String enterText){

    if(personName.text.toString().length >=2) {
      personNamevalid = true;
    }
    else{
      personNamevalid = false;
    }
    if(familyName.text.toString().length >=2) {
      familyNamevalid = true;
    }
    else{
      familyNamevalid = false;
    }
    if(mobileNumber.text.toString().length != 10){
      numbervalid = false;
    }
    else{
      numbervalid = true;
    }
    setState(() {
    });
  }

  void _pickStartDateDialog() {
    showDatePicker(
        context: context,
        initialDate: selectedStartDate,
        firstDate: DateTime(1900),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme:const ColorScheme.light(
                primary: Color(0xFF549DD6),
                onPrimary: Colors.white,
                onSurface: Colors.black,
              ),
            ),
            child: child!,
          );
        },
        lastDate: DateTime.now())
        .then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        startDate = DateFormat('dd-MMM-yyyy').format(pickedDate);
        selectedStartDate = pickedDate;
      });
    });
    FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  void initState() {
    super.initState();
    EasyLoading.show(status: 'Loading...');
    searchCity();
  }

  Future<String> submitData() async{

    final split = cityID.split(',');
    final Map<int, String> values = {
      for (int i = 0; i < split.length; i++)
        i: split[i]
    };
    print(values);

    String value1 = values[0].toString();
    String value2 = values[1].toString();
    String value3 = values[2].toString();

    FocusManager.instance.primaryFocus?.unfocus();

    dynamic status = await searchAPI(true ,'$urlForINSC/citizen_signup_smarthealth.notauth',
        {'token': token},
        {
          'firstName': personName.text.toString(),
          'middleName':middleName.text.toString(),
          'familyName' : familyName.text.toString(),
          'genderIDF': genderIDF,
          'maritalStatusID':maritalStatusIDF,
          'dateofBirth': startDate,
          'mobile':mobileNumber.text.toString(),
          'email':emailAddress.text.toString(),
          'cityIDF':value1,
          'citySelected':cityText,
          'countryIDF': value3,
          'residentialAddress':addressController.text.toString(),
          'Age':'',
          'address':'',
          'area':'',
          'areaIDF':'',
          'stateIDF':value2,
          'requestFrom':'signup'
        },
        45);

    print(' status after responce: $status');
    EasyLoading.dismiss();

    if(status.toString() != 'Sorry !!! Server Error' && status.toString().isNotEmpty  && status.toString() != 'Sorry !!!  Connectivity issue! Try again') {
      String statusInfo = status['status'].toString();
      if (statusInfo == 'true') {
        var citizen = status['citizen'];
        citizenID = citizen['citizenIDP'].toString();
        ULID = status['ULID'].toString();
        mobile = status['mobile'].toString();
        setState(() {
          onBack = false;
        });
        return statusInfo;
      } else {
        return 'false';
      }
    }else{
      return 'false';
    }
  }

  void filterSearchCity(String searchText) {

    if(searchText.length >=2){
      filterlist.clear();
      for (int i = 0; i < citylist.length; i++) {
        if (citylist[i].text.toLowerCase().contains(searchText.toLowerCase())) {
          filterlist.add(citylist[i]);
          print(filterlist.length);
        }
        else {
        }
      }
      setState(() {
        filterColumn = true;
      });
    }
    else{
      setState(() {
        filterColumn = false;
      });
    }
  }

  void searchCity() async{

    dynamic status = await searchAPI(false ,'$urlForINSC/getCitySelect2_Vinecare.notauth',
        {},{}, 25);

    print(' status after responce: $status');
    EasyLoading.dismiss();

    if(status.toString() != 'Sorry !!! Server Error' && status.toString().isNotEmpty && status.toString() != 'Sorry !!!  Connectivity issue! Try again'){
      List<dynamic> statusinfo = status;
      if(statusinfo.isNotEmpty) {
        for (int i = 0; i < statusinfo.length; i++) {
          String name = statusinfo[i]["name"].toString();
          String id = statusinfo[i]["id"].toString();
          citylist.add(SearchCityModal(text: name, id: id));
        }
        EasyLoading.dismiss();
      }
      else{
        EasyLoading.dismiss();
        showToast('Please.. Try Again...');
      }
    }
    else if(status.toString() == 'Sorry !!!  Connectivity issue! Try again'){
      showToast('Sorry !!!  Poor Internet Connectivity ! Try again');
    }
    else{
      EasyLoading.dismiss();
      showToast('Sorry !!! Server Error');
    }

    getStatus();

  }

  void getStatus() async{

    meritalStatulList.clear();

    List<dynamic> status = await searchAPI(false ,'$urlForINSC/getMaritalStatus.notauth',
        {},{}, 25);

    print(' status after responce: $status');
    EasyLoading.dismiss();

    if(status.toString() != 'Sorry !!! Server Error' && status.toString().isNotEmpty && status.toString() != 'Sorry !!!  Connectivity issue! Try again'){

      for(int i = 0; i<status.length; i++){
        String id = status[i]['id'].toString();
        String name = status[i]['name'].toString();

        meritalStatulList.add(MeritalStatus(id: id, name: name));
      }

    }
    else if(status.toString() == 'Sorry !!!  Connectivity issue! Try again'){
      showToast('Sorry !!!  Poor Internet Connectivity ! Try again');
    }
    else{
      EasyLoading.dismiss();
      showToast('Sorry !!! Server Error');
    }

  }

  Padding paddingWithText(String text,  double leftPadding, double rightPadding,double topPadding,double bottomPadding){
    return Padding(
      padding: EdgeInsets.only(left: leftPadding,right: rightPadding,top: topPadding,bottom: bottomPadding),
      child: Text(text,style: TextStyle(color: Colors.grey[700],letterSpacing: .4,fontSize: 12),),
    );
  }

  @override
  void dispose() {
    EasyLoading.dismiss();
    FocusManager.instance.primaryFocus?.unfocus();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => onBack,
      child: Scaffold(
        appBar: AppBar(
          title: Text(fromAddMember?'Add Family Member'.toUpperCase() : 'QUICK SIGN UP'.toUpperCase()),
          centerTitle: true,
          titleTextStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
          leading: InkWell(
              onTap: (){
                Navigator.pop(context);
              },
              child: const Icon(Icons.arrow_back_rounded,color: Colors.white)),
          backgroundColor: globalBlue,
          elevation: 0.0,
        ),
        body: Container(
          color: globalPageBackgroundColor,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TopPageTextViews(fromAddMember?'family member registration' : 'Start your Account of Vinecare'),
                Container(
                  margin: const EdgeInsets.only(left: 15,right: 15,top: 5,bottom: 5),
                  decoration: BorderContainer(globalWhiteColor,globalBlue),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15,right: 15,top: 25,bottom: 25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        paddingWithText('FIRST NAME',2,0,0,2),
                        TextField(
                          maxLength: 15,
                          controller: personName,
                          textCapitalization: TextCapitalization.words,
                          decoration: TextFieldDecoration(
                              Icon(Icons.person,color: globalBlue,),
                              personNamevalid?Icon(Icons.check_circle_outline,color: Colors.green,):Icon(Icons.error_outline,color: Colors.red,)
                          ),
                          onChanged: changeText,
                        ),
                        paddingWithText('MIDDLE NAME',2,0,0,2),
                        TextField(
                          maxLength: 15,
                          controller: middleName,
                          textCapitalization: TextCapitalization.words,
                          decoration: TextFieldDecoration(
                            Icon(Icons.person,color: globalBlue,),
                            const Icon(Icons.check_circle_outline,color: Colors.green,),
                          ),
                        ),
                        paddingWithText('FAMILY NAME',2,0,0,2),
                        TextField(
                          maxLength: 15,
                          controller: familyName,
                          textCapitalization: TextCapitalization.words,
                          decoration: TextFieldDecoration(
                              Icon(Icons.person,color: globalBlue,),
                              familyNamevalid?const Icon(Icons.check_circle_outline,color: Colors.green,):const Icon(Icons.error_outline,color: Colors.red,)
                          ),
                          onChanged: changeText,
                        ),
                        paddingWithText('GENDER',2,0,0,2),
                        InkWell(
                          onTap: () {
                            showGlobalDialog(context, Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: globalBlue,
                                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20)),
                                  ),
                                  height: 50,
                                  child: const Center(child: Text('Select gender',textScaleFactor: 1.0,style: TextStyle(color:Colors.white,fontSize: 19,fontWeight: FontWeight.w500,),)),
                                ),
                                RadioListTile(
                                  title: const Text('Male'),
                                  value: "Male",
                                  activeColor: globalBlue,
                                  groupValue: genderText,
                                  onChanged: (value){
                                    setState(() {
                                      gendervalid = true;
                                      genderIDF = '1';
                                      genderText = value.toString();
                                      Navigator.pop(context, 'Cancel');
                                    }
                                    );
                                  },
                                ),
                                RadioListTile(
                                  title: Text('Female'),
                                  value: "Female",
                                  activeColor: globalBlue,
                                  groupValue: genderText,
                                  onChanged: (value){
                                    setState(() {
                                      gendervalid = true;
                                      genderIDF = '2';
                                      genderText = value.toString();
                                      Navigator.pop(context, 'Cancel');
                                    }
                                    );
                                  },
                                ),
                              ],
                            ), true);
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  width: 1,
                                  color: gendervalid?Colors.grey:Colors.red
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(genderText),
                                  Icon(Icons.arrow_drop_down),
                                ],
                              ),
                            ),
                          ),
                        ),
                        paddingWithText('MARITAL STATUS',2,0,20,2),
                        InkWell(
                          onTap: () {
                            if(meritalStatulList.isNotEmpty){
                              setState(() {
                                mStatusList = true;
                              });
                            }else{
                              EasyLoading.show(status: 'Loading...');
                              getStatus();
                            }

                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  width: 1,
                                  color: maritalStatusvalid?Colors.grey:Colors.red
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(maritalStatusText),
                                  const Icon(Icons.arrow_drop_down),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: mStatusList,
                          child: ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount:meritalStatulList.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: (){
                                  maritalStatusText = meritalStatulList[index].name;
                                  maritalStatusIDF = meritalStatulList[index].id;
                                  setState(() {
                                      maritalStatusvalid = true;
                                      mStatusList = false;
                                  });
                                },
                                child: Container(
                                  margin: EdgeInsets.all(1),
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.indigo.shade50,
                                      border: Border.all(
                                          width: 1,
                                          color: Colors.grey
                                      ),
                                      borderRadius: BorderRadius.circular(8),),
                                    child: Text(meritalStatulList[index].name)),
                              );
                            },
                          ),
                        ),
                        paddingWithText('DATE OF BIRTH',2,0,20,2),
                        InkWell(
                          onTap: _pickStartDateDialog,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  width: 1,
                                  color: Colors.grey
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.calendar_month_outlined,color: globalBlue,),
                                      const SizedBox(width: 5,),
                                      Text(startDate),
                                    ],
                                  ),
                                  const Icon(Icons.check_circle_outline,color: Colors.green,),
                                ],
                              ),
                            ),
                          ),
                        ),
                        paddingWithText('MOBILE NUMBER',2,0,20,2),
                        TextField(
                          keyboardType: TextInputType.number,
                          controller: mobileNumber,
                          maxLength: 10,
                          decoration: TextFieldDecoration(
                              Icon(Icons.phone_iphone_rounded,color: globalBlue,),
                              numbervalid?const Icon(Icons.check_circle_outline,color: Colors.green,):const Icon(Icons.error_outline,color: Colors.red,)
                          ),
                          onChanged: changeText,
                        ),
                        paddingWithText('EMAIL',2,0,0,2),
                        TextField(
                          keyboardType: TextInputType.emailAddress,
                          controller: emailAddress,
                          decoration: TextFieldDecoration(
                              Icon(Icons.email_rounded,color: globalBlue,),
                              const Icon(Icons.check_circle_outline,color: Colors.green,)
                          ),
                          onChanged: changeText,
                        ),
                        paddingWithText('RESIDENTIAL ADDRESS',2,0,10,2),
                        TextField(
                          maxLength: 50,
                          maxLines: 2,
                          controller: addressController,
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                    width: 1, color: Colors.grey),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                    width: 1, color: Colors.grey),
                              ),
                              border: InputBorder.none
                          ),
                        ),
                        paddingWithText('CITY',2,0,0,2),
                        InkWell(
                          onTap: (){
                             if(citylist.isEmpty){
                                EasyLoading.show(status: 'Loading...');
                                searchCity();
                              }else{
                                setState(() {
                                  seachCityView = true;
                                  FocusManager.instance.primaryFocus?.unfocus();
                                });
                            }
                          },
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  width: 1,
                                  color: cityvalid?Colors.grey:Colors.red
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(cityText),
                            ),
                          ),
                        ),
                        const SizedBox(height: 1,),
                        Visibility(
                          visible: seachCityView,
                          child: Column(
                            children: <Widget>[
                              TextField(
                                controller: seachCity,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(vertical: 0.0),
                                  prefixIcon: const Icon(Icons.search),
                                  suffixIcon: InkWell(
                                    onTap: (){
                                      setState(() {
                                        seachCityView = false;
                                        seachCity.clear();
                                        filterColumn = false;
                                      });
                                    },
                                    child: const Icon(Icons.cancel)
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                        width: 1, color: Colors.grey),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                        width: 1, color: Colors.grey),
                                  ),
                                  hintText: 'Search City',
                                ),
                                onChanged: filterSearchCity,
                              ),
                              SizedBox(
                                height: 200,
                                child: ListView.builder(
                                  // shrinkWrap: true,
                                  itemCount:filterColumn? filterlist.length : citylist.length,
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                      visualDensity: const VisualDensity(vertical: -4),
                                      onTap: (){
                                        cityText = filterColumn? filterlist[index].text : citylist[index].text;
                                        cityID = filterColumn? filterlist[index].id : citylist[index].id;
                                        setState(() {
                                          cityvalid = true;
                                          seachCityView = false;
                                          filterColumn = false;
                                          seachCity.clear();
                                        });
                                      },
                                      contentPadding :EdgeInsets.zero,
                                      title: Container(
                                          padding: const EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                                width: 1,
                                                color: Colors.grey
                                            ),
                                            borderRadius: BorderRadius.circular(8),),
                                          child: Text(filterColumn? filterlist[index].text : citylist[index].text)),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () async{
                            if(personNamevalid ==false){
                                showToast('First name should not be blank !!!');
                            }
                            else if(familyNamevalid == false){
                              showToast('Family name should not be blank !!!');
                            }
                            else if(gendervalid == false){
                              showToast('Please Select Gender');
                            }
                            else if(maritalStatusvalid == false){
                              showToast('Please select Marital Status');
                            }
                            else if(mobileNumber.text.isEmpty){
                              showToast('Mobile number should not be blank !!!');
                            }
                            else if(numbervalid == false){
                              showToast('Please enter valid Mobile number');
                            }
                            else if(cityvalid == false){
                              showToast('Please Select City');
                            }
                            else{
                              EasyLoading.show(status: 'Sending OTP..');
                              var status = await submitData();

                              if(status == 'true'){
                                FocusManager.instance.primaryFocus?.unfocus();
                                showDialog<String>(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) =>StatefulBuilder(
                                    builder: (context, StateSetter setState) {
                                      return BackdropFilter(
                                        filter: ImageFilter.blur(sigmaX: 7.0, sigmaY: 7.0),
                                        child: Dialog(
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                          insetPadding: const EdgeInsets.all(20),
                                          elevation: 16,
                                          child: Padding(
                                            padding:  EdgeInsets.all(20.0),
                                            child: OTPPage(fromAddMember: fromAddMember,),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              }else{
                               showToast('Please Try Again');
                              }
                            }
                            },
                          child: Container(
                            margin: const EdgeInsets.only(top: 20),
                            decoration: BoxDecoration(
                              color: globalOrange,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text(fromAddMember?'Add Family Member'.toUpperCase() : 'CREATE ACCOUNT',style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                                    ],
                                  ),
                                  const Icon(Icons.arrow_forward,color: Colors.white,),
                                ],
                              ),
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
        ),
      ),
    );
  }
}
