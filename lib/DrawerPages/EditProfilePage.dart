import 'package:digipath_ircs/Design/BorderContainer.dart';
import 'package:digipath_ircs/Design/GlobalAppBar.dart';
import 'package:digipath_ircs/Design/TopPageTextViews.dart';
import 'package:digipath_ircs/Global/Colors.dart';
import 'package:digipath_ircs/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/route_manager.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Global/SearchAPI.dart';
import '../Global/Toast.dart';
import '../Global/global.dart';
import '../ModalClass/SearchCityModal.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {

  bool profileView = false;
  bool contactView = false;
  bool addressView = false;

  TextEditingController personName = TextEditingController();
  TextEditingController middleName = TextEditingController();
  TextEditingController familyName = TextEditingController();
  TextEditingController emailAddress = TextEditingController();
  TextEditingController mobileNumber = TextEditingController();
  DateTime selectedStartDate = DateTime.now();
  String genderText = 'Select Gender';
  String genderIDF = '';
  String startDate =DateFormat('dd-MMM-yyyy').format(DateTime.now());
  String cityName = '';
  String cityID = '';
  List<SearchCityModal> citylist =  <SearchCityModal>[];
  TextEditingController seachCity = TextEditingController();
  bool filterColumn = false;
  bool seachCityView = false;
  List<SearchCityModal> filterlist =  <SearchCityModal>[];

  String addressIDP = '';
  String CityIDP = '';
  String CityName = '';
  String StateIDP = '';
  String StateName = '';
  String CountryIDP = '';
  String CountryName = '';
  String ITUCode = '';
  String id = '';
  String name = '';
  String address1 = '';

  String FirstName = '';
  String MiddleName = '';
  String FamilyName = '';
  String CitizenCode = '';
  String DateofBirth = '';
  String GenderIDF = '';
  String Gender  = '';
  String CitizenTitleIDF  = '';
  String CitizenTitle  = '';

  String ContactIDPNumber = '' ;
  String ContactDetails = '' ;

  String ContactIDPEmail = '';
  String ContactDetailsEmail = '';

  void _pickStartDateDialog() {
    showDatePicker(
        context: context,
        initialDate: selectedStartDate,
        firstDate: DateTime(1900),
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
    getUserInfo();
  }

  void getUserInfo() async{

    dynamic status = await searchAPI(false ,'$urlForINSC/getPatientDetails.shc?citizenID=$localCitizenIDP',
        {'token' : token},
        {}, 25);

    print(' status after responce: $status');
    EasyLoading.dismiss();

    if(status.toString() != 'Sorry !!! Server Error' && status.toString().isNotEmpty && status.toString() != 'Sorry !!!  Connectivity issue! Try again'){

      print(status);

      if(status.isNotEmpty) {

        var addressInfo = status['addressInfo'];

        addressIDP = addressInfo['AddressIDP'].toString();
        CityIDP = addressInfo['CityIDP'].toString();
        CityName = addressInfo['CityName'].toString();
        StateIDP = addressInfo['StateIDP'].toString();
        StateName = addressInfo['StateName'].toString();
        CountryIDP = addressInfo['CountryIDP'].toString();
        CountryName = addressInfo['CountryName'].toString();
        ITUCode = addressInfo['ITUCode'].toString();
        id = addressInfo['id'].toString();
        name = addressInfo['name'].toString();
        address1 = addressInfo['address1'].toString();

        var contactInfoMobile = status['contactInfo_Mobile'];

        ContactIDPNumber = contactInfoMobile['ContactIDP'].toString();
        ContactDetails = contactInfoMobile['ContactDetails'].toString();

        var contactInfoEmail = status['contactInfo_Email'];

        if(contactInfoEmail != null && contactInfoEmail != ''){
          ContactIDPEmail = contactInfoEmail['ContactIDP'].toString();
          ContactDetailsEmail = contactInfoEmail['ContactDetails'].toString();
        }

        var basicInfo = status['basicInfo'];

        FirstName = basicInfo['FirstName'].toString();
        MiddleName = basicInfo['MiddleName'].toString();
        FamilyName = basicInfo['FamilyName'].toString();
        CitizenCode = basicInfo['CitizenCode'].toString();
        DateofBirth = basicInfo['DateofBirth'].toString();
        GenderIDF = basicInfo['GenderIDF'].toString();
        Gender = basicInfo['Gender'].toString();
        CitizenTitleIDF = basicInfo['CitizenTitleIDF'].toString();
        CitizenTitle = basicInfo['CitizenTitle'].toString();

        setState(() {
          personName.text = FirstName;
          middleName.text = MiddleName;
          familyName.text = FamilyName;
          startDate = DateofBirth;
          genderText = Gender;
          genderIDF = GenderIDF;
          cityName = CityName;
          mobileNumber.text =  ContactDetails;
          emailAddress.text =  ContactDetailsEmail;

          selectedStartDate = DateFormat('dd-MMM-yyyy').parse(DateofBirth);

        });

        searchCity();

      }
      else{
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

  void submitBasicInfo() async{

    FocusManager.instance.primaryFocus?.unfocus();
    EasyLoading.show(status: 'Updating Basic information');

    dynamic status = await searchAPI(true ,'$urlForINSC/updatePatientBasicInfo.shc?citizenIDP=$localCitizenIDP&firstName=${personName.text}&familyName=${familyName.text}&middleName=${middleName.text}&genderIDF=$genderIDF&dateofBirth=$startDate&Age',
        {'token' : token},{}, 25);

    print(' status after responce: $status');
    EasyLoading.dismiss();

    if(status.toString() != 'Sorry !!! Server Error' && status.toString().isNotEmpty && status.toString() != 'Sorry !!!  Connectivity issue! Try again'){

      bool statusInfo = status['status'];

      if(statusInfo == true){
        Navigator.pop(context);
        localUserName = personName.text;
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.setString('userName', personName.text);
        showHomeDialog('Basic Information Edit successfully');
      }else{
        showToast('Please Try Again !!!');
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

  void submitAddressInfo() async{

    FocusManager.instance.primaryFocus?.unfocus();
    EasyLoading.show(status: 'Updating Address information');

    dynamic status = await searchAPI(true ,'$urlForINSC/updatePatientAddressInfo.shc?citizenIDP=$localCitizenIDP&addressIDP=$addressIDP&citySelected=$cityName&cityIDF=$CityIDP&countryIDF=$CountryIDP',
        {
          'token' : token
        },{}, 25);

    print(' status after responce: $status');
    EasyLoading.dismiss();

    if(status.toString() != 'Sorry !!! Server Error' && status.toString().isNotEmpty && status.toString() != 'Sorry !!!  Connectivity issue! Try again'){

      bool statusInfo = status['status'];

      if(statusInfo == true){
        Navigator.pop(context);
        showHomeDialog('Address Information Edit successfully');
      }else{
        showToast('Please Try Again !!!');
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

  void submitEmailInfo() async{

    FocusManager.instance.primaryFocus?.unfocus();
    EasyLoading.show(status: 'Updating Address information');

    dynamic status = await searchAPI(true ,'$urlForINSC/updatePatientContactInfo.shc?Mobile_ContactIDP=$ContactIDPNumber&mobile=$ContactDetails&Email_ContactIDP=$ContactIDPEmail&email=${emailAddress.text}',
        {
          'token' : token
        },{}, 25);

    print(' status after responce: $status');
    EasyLoading.dismiss();

    if(status.toString() != 'Sorry !!! Server Error' && status.toString().isNotEmpty && status.toString() != 'Sorry !!!  Connectivity issue! Try again'){

      bool statusInfo = status['status'];

      if(statusInfo == true){
        Navigator.pop(context);
        showHomeDialog('Email Address Information Edit successfully');
      }else{
        showToast('Please Try Again !!!');
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

  Padding CommonRowPadding(String text1,String text2){
    return Padding(
      padding: const EdgeInsets.only(top: 8.0,bottom: 8),
      child: Row(
        children: [
          Expanded(child: Text(text1.toUpperCase(),style: TextStyle(color: Colors.grey[700],fontSize: 15),)),
          Expanded(child: Text(text2,style: TextStyle(fontWeight: FontWeight.bold,color: Colors.grey[700],fontSize: 17))),
        ],
      ),
    );
  }

  Future<void> showConfirmBasicInfoDialog(){
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            insetPadding: EdgeInsets.all(20),
            elevation: 16,
            child: Padding(
              padding: const EdgeInsets.all( 30.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('confirm Basic information'.toUpperCase(),style: TextStyle(fontSize: 20,color: globalBlue,fontWeight: FontWeight.bold),textAlign: TextAlign.center),
                  divider(),
                  CommonRowPadding('First name:', personName.text),
                  divider(),
                  CommonRowPadding('Middle name:', middleName.text),
                  divider(),
                  CommonRowPadding('Family name:', familyName.text),
                  divider(),
                  CommonRowPadding('Date of birth:', startDate),
                  divider(),
                  CommonRowPadding('Gender:', genderText),
                  divider(),
                  InkWell(
                    onTap: (){
                      submitBasicInfo();
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
                                Text('edit basic information'.toUpperCase(),style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
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
          );
        }
    );
  }

  Future<void> showConfirmEmailDialog(){
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          insetPadding: EdgeInsets.all(20),
          elevation: 16,
          child: Padding(
            padding: EdgeInsets.all(30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('confirm Email Address information'.toUpperCase(),style: TextStyle(fontSize: 20,color: globalBlue,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                divider(),
                CommonRowPadding('Email Address:', emailAddress.text),
                divider(),
                InkWell(
                  onTap: submitEmailInfo,
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
                              Text('edit address information'.toUpperCase(),style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
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
        );
      }
    );
  }

  Future<void> showConfirmAddressDialog(){
    return showDialog<void>(
        context: context,
        builder: (BuildContext context){
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            insetPadding: EdgeInsets.all(20),
            elevation: 16,
            child: Padding(
              padding: const EdgeInsets.all( 30.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('confirm Address information'.toUpperCase(),style: TextStyle(fontSize: 20,color: globalBlue,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                  divider(),
                  CommonRowPadding('City name:', cityName),
                  divider(),
                  InkWell(
                    onTap: submitAddressInfo,
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
                                Text('edit address information'.toUpperCase(),style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
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
          );
        }
    );
  }

  Future<void> showHomeDialog(String text){
    return showDialog<void>(
        context: context,
        builder: (BuildContext context){
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            insetPadding: EdgeInsets.all(20),
            elevation: 16,
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(text.toUpperCase(),style: TextStyle(fontWeight: FontWeight.w600,color: globalBlue,fontSize: 17),textAlign: TextAlign.center,),
                  divider(),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0,right: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          child: Text('Cancel',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
                          onTap: (){
                            Navigator.pop(context);
                          },
                        ),
                        InkWell(
                            onTap: (){
                              Get.offAll(HomePage());
                            },
                          child: Text('Go to Home',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)))
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        }
    );
  }

  Text topText(String text){
    return Text(text.toUpperCase(),style: TextStyle(color: globalBlue,fontWeight: FontWeight.w600,fontSize: 13),);
  }

  Padding divider() {
    return  const Padding(
      padding: EdgeInsets.only(top: 5.0,bottom: 5.0),
      child: Divider(
        thickness: 1,
        color: Colors.grey,
      ),
    );
  }

  InputDecoration editTextDecoration(Icon prefixIcon){
    return InputDecoration(
        isDense: true,
        filled: true,
        fillColor: Colors.grey.shade100,
        prefixIcon: prefixIcon,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GlobalAppBar(context,'edit Profile'),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: globalPageBackgroundColor,
        child: SingleChildScrollView(
          child: Column(
            children: [
              TopPageTextViews('You can edit profile here'),
              Container(
                padding: const EdgeInsets.only(left: 20,right: 20,top: 20,bottom: 20),
                margin: const EdgeInsets.only(left: 20,right: 20,top: 5,bottom: 5),
                decoration: BorderContainer(globalWhiteColor, globalBlue),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('basic information'.toUpperCase(),style: TextStyle(color: globalBlue,fontWeight: FontWeight.w600,fontSize: 17),),
                        InkWell(
                          onTap: (){
                            setState(() {
                              profileView = !profileView;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              shape: BoxShape.circle
                            ),
                            padding: const EdgeInsets.all(3.0),
                            child: Icon(profileView?Icons.arrow_drop_up_sharp : Icons.arrow_drop_down,color: globalBlue,size: 25,),
                          ),
                        )
                      ],
                    ),
                    divider(),
                    Visibility(
                      visible: profileView,
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            topText('first name'),
                            TextField(
                              maxLength: 15,
                              controller: personName,
                              style: TextStyle(fontWeight: FontWeight.w600,fontSize: 16,color: Colors.grey.shade800),
                              textCapitalization: TextCapitalization.words,
                              decoration: editTextDecoration(
                                  Icon(Icons.person,color: globalBlue,)
                              ),
                            ),
                            SizedBox(height: 10,),
                            topText('middle name'),
                            TextField(
                              maxLength: 15,
                              controller: middleName,
                              style: TextStyle(fontWeight: FontWeight.w600,fontSize: 16,color: Colors.grey.shade800),
                              textCapitalization: TextCapitalization.words,
                              decoration: editTextDecoration(
                                  Icon(Icons.person,color: globalBlue,)
                              ),
                            ),
                            SizedBox(height: 10,),
                            topText('family name'),
                            TextField(
                              maxLength: 15,
                              controller: familyName,
                              style: TextStyle(fontWeight: FontWeight.w600,fontSize: 16,color: Colors.grey.shade800),
                              textCapitalization: TextCapitalization.words,
                              decoration: editTextDecoration(
                                  Icon(Icons.person,color: globalBlue,)
                              ),
                            ),
                            SizedBox(height: 10,),
                            topText('date of birth'),
                            InkWell(
                              onTap: _pickStartDateDialog,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
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
                                          Text(startDate,style: TextStyle(fontWeight: FontWeight.w600,fontSize: 16,color: Colors.grey.shade800),),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20,),
                            topText('gender'),
                            InkWell(
                              onTap: () {
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
                                              child: Center(child: Text('Select Gender',textScaleFactor: 1.0,style: TextStyle(color:Colors.white,fontSize: 19,fontWeight: FontWeight.w500,),)),
                                              decoration: BoxDecoration(
                                                color: globalBlue,
                                                borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20)),
                                              ),
                                              height: 50,
                                            ),
                                            RadioListTile(
                                              title: const Text('Male'),
                                              value: "Male",
                                              activeColor: globalBlue,
                                              groupValue: genderText,
                                              onChanged: (value){
                                                setState(() {
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
                                                  genderIDF = '2';
                                                  genderText = value.toString();
                                                  Navigator.pop(context, 'Cancel');
                                                }
                                                );
                                              },
                                            ),
                                          ],
                                        )
                                    ));
                                FocusManager.instance.primaryFocus?.unfocus();
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
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
                                      Text(genderText,style: TextStyle(fontWeight: FontWeight.w600,fontSize: 16,color: Colors.grey.shade800),),
                                      Icon(Icons.arrow_drop_down,color: globalBlue,),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            InkWell(
                              onTap: (){
                                  showConfirmBasicInfoDialog();
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
                                          Text('edit basic information'.toUpperCase(),style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                                        ],
                                      ),
                                      const Icon(Icons.arrow_forward,color: Colors.white,),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10,)
                          ],
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('Contact information'.toUpperCase(),style: TextStyle(color: globalBlue,fontWeight: FontWeight.w600,fontSize: 17),),
                        InkWell(
                          onTap: (){
                            setState(() {
                              contactView = !contactView;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                shape: BoxShape.circle
                            ),
                            padding: const EdgeInsets.all(3.0),
                            child: Icon(contactView?Icons.arrow_drop_up_sharp : Icons.arrow_drop_down,color: globalBlue,size: 25,),
                          ),
                        )
                      ],
                    ),
                    Visibility(
                      visible: contactView,
                      child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              topText('Mobile number'),
                              TextField(
                                maxLength: 10,
                                controller: mobileNumber,
                                keyboardType: TextInputType.number,
                                style: TextStyle(fontWeight: FontWeight.w600,fontSize: 16,color: Colors.grey.shade800),
                                textCapitalization: TextCapitalization.words,
                                decoration: editTextDecoration(
                                    Icon(Icons.phone_android_outlined,color: globalBlue,)
                                ),
                              ),
                              InkWell(
                                onTap: (){

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
                                            Text('edit contact information'.toUpperCase(),style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                                          ],
                                        ),
                                        const Icon(Icons.arrow_forward,color: Colors.white,),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 30,),
                              topText('Email addreess'),
                              TextField(
                                maxLength: 30,
                                keyboardType: TextInputType.emailAddress,
                                controller: emailAddress,
                                style: TextStyle(fontWeight: FontWeight.w600,fontSize: 16,color: Colors.grey.shade800),
                                textCapitalization: TextCapitalization.words,
                                decoration: editTextDecoration(
                                    Icon(Icons.email_rounded,color: globalBlue,)
                                ),
                              ),
                              InkWell(
                                onTap: (){
                                  showConfirmEmailDialog();
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
                                            Text('edit contact information'.toUpperCase(),style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                                          ],
                                        ),
                                        const Icon(Icons.arrow_forward,color: Colors.white,),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10,)
                            ],
                          )
                      )
                    ),
                    divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('Address information'.toUpperCase(),style: TextStyle(color: globalBlue,fontWeight: FontWeight.w600,fontSize: 17),),
                        InkWell(
                          onTap: (){
                            setState(() {
                              addressView = !addressView;
                            });

                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                shape: BoxShape.circle
                            ),
                            padding: const EdgeInsets.all(3.0),
                            child: Icon(addressView?Icons.arrow_drop_up_sharp : Icons.arrow_drop_down,color: globalBlue,size: 25,),
                          ),
                        )
                      ],
                    ),
                    Visibility(
                      visible: addressView,
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            topText('city : $cityName'),
                            SizedBox(height: 2,),
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
                                  color: Colors.grey.shade100,
                                  border: Border.all(
                                      width: 1,
                                      color: Colors.grey
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Text(cityName,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600),),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: seachCityView,
                              child: Column(
                                children: <Widget>[
                                  TextField(
                                    controller: seachCity,
                                    decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.symmetric(vertical: 0.0),
                                      prefixIcon: Icon(Icons.search,color: globalBlue,),
                                      suffixIcon: InkWell(
                                          onTap: (){
                                            setState(() {
                                              seachCityView = false;
                                              seachCity.clear();
                                              filterColumn = false;
                                            });
                                          },
                                          child: Icon(Icons.cancel,color: globalBlue,)
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
                                    height: 300,
                                    child: ListView.builder(
                                      // shrinkWrap: true,
                                      itemCount:filterColumn? filterlist.length : citylist.length,
                                      itemBuilder: (context, index) {
                                        return ListTile(
                                          visualDensity: const VisualDensity(vertical: -4),
                                          onTap: (){
                                            cityName = filterColumn? filterlist[index].text : citylist[index].text;
                                            cityID = filterColumn? filterlist[index].id : citylist[index].id;
                                            final split = cityID.split(',');
                                            final Map<int, String> values = {
                                              for (int i = 0; i < split.length; i++)
                                                i: split[i]
                                            };
                                            print(values);
                                            CityIDP = values[0].toString();
                                            CountryIDP = values[2].toString();
                                            setState(() {
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
                            const SizedBox(height: 10,),
                            InkWell(
                              onTap: showConfirmAddressDialog,
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
                                          Text('update address information'.toUpperCase(),style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                                        ],
                                      ),
                                      const Icon(Icons.arrow_forward,color: Colors.white,),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
