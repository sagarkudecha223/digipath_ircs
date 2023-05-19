import 'package:digipath_ircs/NewPages/DoctorListPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/route_manager.dart';
import '../Design/ColorFillContainer.dart';
import '../Design/GlobalAppBar.dart';
import '../Design/TopPageTextViews.dart';
import '../Global/SearchAPI.dart';
import '../Global/Toast.dart';
import '../Global/global.dart';
import '../ModalClass/BookApointmentModal.dart';

class BookApointmentPage extends StatefulWidget {
  const BookApointmentPage({Key? key}) : super(key: key);

  @override
  State<BookApointmentPage> createState() => _BookApointmentPageState();
}

class _BookApointmentPageState extends State<BookApointmentPage> {

  List<BookApointmentModal> cityList =  <BookApointmentModal>[];
  List<BookApointmentModal> specialistTypeList =  <BookApointmentModal>[];
  List<BookApointmentModal> hospitalList =  <BookApointmentModal>[];
  List<BookApointmentModal> doctorList =  <BookApointmentModal>[];
  List<BookApointmentModal> filterList =  <BookApointmentModal>[];
  bool searchCityColumn = false;
  bool specialityTypeColumn = false;
  bool hospitalColumn = false;
  bool doctorColumn = false;
  String cityText = 'Search City';
  String specialityTypeText = 'Search Speciality Type';
  String hospitalText = 'Search Hospital';
  String doctorText = 'Search Doctor';
  bool filterColumn = false;
  TextEditingController searchFilterController = TextEditingController();
  late String doctorIDF = '';
  late String careProviderID = '';
  late String cityID = '';
  late String specialityID = '';

  @override
  void initState() {
    super.initState();
    searchData();
  }

  void searchData() async{

    EasyLoading.show(status: 'Loading...');

    dynamic status = await searchAPI(false ,'$urlForIN/findCareProfessionalForAppointment.do?cityID&facultyID&careProviderID&doctorID',
        {},{}, 35);

    print(' status after responce: $status');
    EasyLoading.dismiss();

    if(status.toString() != 'Sorry !!! Server Error' && status.toString().isNotEmpty && status.toString() != 'Sorry !!!  Connectivity issue! Try again'){
      String statusinfo = status['status'].toString();
      if (statusinfo == "true") {

        List<dynamic> cityListStastus = status['cityList'];
        for(int i=0; i<cityListStastus.length; i++){
          String id = cityListStastus[i]['id'].toString();
          String name = cityListStastus[i]['name'].toString();
          cityList.add(BookApointmentModal(id: id,name: name,specialityTypeID: '',specialityType: ''));
        }

        List<dynamic> careProfessionalListstatus = status['careProfessionalList'];
        for(int i=0; i<careProfessionalListstatus.length; i++){
          String id = careProfessionalListstatus[i]['id'].toString();
          String name = careProfessionalListstatus[i]['name'].toString();
          String specialityTypeID = careProfessionalListstatus[i]['specialityTypeID'].toString();
          String specialityType = careProfessionalListstatus[i]['specialityType'].toString();
          doctorList.add(BookApointmentModal(id: id,name: name,specialityTypeID: specialityTypeID,specialityType: specialityType));
        }

        List<dynamic> careProviderListstatus = status['careProviderList'];
        for(int i=0; i<careProviderListstatus.length; i++){
          String id = careProviderListstatus[i]['id'];
          String name = careProviderListstatus[i]['name'];
          String specialityTypeID = careProviderListstatus[i]['cityID'];
          String specialityType = careProviderListstatus[i]['cityName'];
          hospitalList.add(BookApointmentModal(id: id,name: name,specialityTypeID: specialityTypeID,specialityType: specialityType));
        }

        List<dynamic> specialityTypeListstatus = status['specialityTypeList'];
        for(int i=0; i<specialityTypeListstatus.length; i++){
          String id = specialityTypeListstatus[i]['id'];
          String name = specialityTypeListstatus[i]['name'];
          specialistTypeList.add(BookApointmentModal(id: id,name: name,specialityTypeID: '',specialityType: ''));
        }

        if(mounted){
          setState(() {
            EasyLoading.dismiss();
          });
        }
      }
      else{
        if(mounted){
          showToast('Please Try Again !!!');
          EasyLoading.dismiss();
        }
      }
    }
    else if(status.toString() == 'Sorry !!!  Connectivity issue! Try again'){
      // searchData();
      showToast('Sorry !!!  Poor Internet Connectivity ! Try again');
    }
    else{
      if(mounted){
        EasyLoading.dismiss();
        showToast('Sorry !!! Server Error');
      }
    }
  }

  void applyFilter(String searchText){

    if(searchCityColumn == true){

      if(searchText.length >=2){
        filterList.clear();
        for (int i = 0; i < cityList.length; i++) {
          if (cityList[i].name.toLowerCase().contains(searchText.toLowerCase())) {
            filterList.add(cityList[i]);
            print(filterList.length);
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
    else if(specialityTypeColumn == true){

      if(searchText.length >=2){
        filterList.clear();
        for (int i = 0; i < specialistTypeList.length; i++) {
          if (specialistTypeList[i].name.toLowerCase().contains(searchText.toLowerCase())) {
            filterList.add(specialistTypeList[i]);
            print(filterList.length);
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
    else if(hospitalColumn == true){
      if(searchText.length >=2){
        filterList.clear();
        for (int i = 0; i < hospitalList.length; i++) {
          if (hospitalList[i].name.toLowerCase().contains(searchText.toLowerCase())) {
            filterList.add(hospitalList[i]);
            print(filterList.length);
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
    else if(doctorColumn == true){
      if(searchText.length >=2){
        filterList.clear();
        for (int i = 0; i < doctorList.length; i++) {
          if (doctorList[i].name.toLowerCase().contains(searchText.toLowerCase())) {
            filterList.add(doctorList[i]);
            print(filterList.length);
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
  }

  Padding textWithPadding(String text){
    return Padding(padding: EdgeInsets.only(top: 20,bottom: 2),
    child: Text(text, style: TextStyle(fontSize: 14,color: Colors.grey),),);
  }

  InputDecoration textFieldDecoration(String hintText){
    return InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 0.0,horizontal: 10),
        hintText:  hintText,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
              width: 1, color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
              width: 1, color: Colors.grey),
        ),
        border: InputBorder.none
    );
  }

  Container textContainer(String text){
    return Container(
        decoration: ColorFillContainer(Colors.grey.shade300),
        width: double.infinity,
        padding: EdgeInsets.all(15),
        child: Text(text));
  }

  @override
  void dispose() {
    EasyLoading.dismiss();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GlobalAppBar(context),
      body: Container(
        height: MediaQuery.of(context).size.height ,
        width: MediaQuery.of(context).size.width ,
        color: Colors.indigo[100],
        child: SingleChildScrollView(
          child: Column(
            children: [
              TopPageTextViews('Book Appointment','Search to Book Appointment'),
              Container(
                padding: const EdgeInsets.only(left: 20,right: 20),
                margin: const EdgeInsets.only(left: 15,right: 15,top: 10),
                decoration: PageMainContainterDecoration(),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      textWithPadding('CITY'),
                      searchCityColumn? Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextField(
                            decoration: textFieldDecoration('Search City'),
                            controller: searchFilterController,
                            onChanged: applyFilter,
                          ),
                          Container(
                            width: double.infinity,
                            height: 200,
                            child: ListView.builder(
                                itemCount:filterColumn? filterList.length : cityList.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    visualDensity: const VisualDensity(vertical: -4),
                                    onTap: (){
                                      cityText = filterColumn? filterList[index].name : cityList[index].name;
                                      cityID =  filterColumn? filterList[index].id : cityList[index].id;
                                      setState(() {
                                        filterColumn = false;
                                        searchCityColumn = false;
                                      });
                                    },
                                    contentPadding :EdgeInsets.zero,
                                    title: Container(
                                        padding: EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                              width: 1,
                                              color: Colors.grey
                                          ),
                                          borderRadius: BorderRadius.circular(8),),
                                        child: Text(filterColumn? filterList[index].name : cityList[index].name)),
                                  );
                                }
                            ),
                          )
                        ],
                      ): InkWell(
                          onTap: (){
                            setState(() {
                              searchFilterController.clear();
                              searchCityColumn = true;
                              specialityTypeColumn = false;
                              hospitalColumn = false;
                              doctorColumn = false;
                            });
                          },
                          child: textContainer(cityText)),
                      textWithPadding('SPECIALITY TYPE'),
                      specialityTypeColumn? Column(
                        children: [
                          TextField(
                            decoration: textFieldDecoration('Search Speciality Type'),
                            controller: searchFilterController,
                            onChanged: applyFilter,
                          ),
                          Container(
                            width: double.infinity,
                            height: 200,
                            child: ListView.builder(
                                itemCount:filterColumn? filterList.length : specialistTypeList.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    visualDensity: const VisualDensity(vertical: -4),
                                    onTap: (){
                                      specialityTypeText = filterColumn? filterList[index].name : specialistTypeList[index].name;
                                      specialityID = filterColumn? filterList[index].id : specialistTypeList[index].id;
                                      setState(() {
                                        filterColumn = false;
                                        specialityTypeColumn = false;
                                      });
                                    },
                                    contentPadding :EdgeInsets.zero,
                                    title: Container(
                                        width: double.infinity,
                                        padding: EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                              width: 1,
                                              color: Colors.grey
                                          ),
                                          borderRadius: BorderRadius.circular(8),),
                                        child: Text(filterColumn? filterList[index].name : specialistTypeList[index].name)),
                                  );
                                }
                            ),
                          )
                        ],
                      ): InkWell(
                          onTap: (){
                            setState(() {
                              searchFilterController.clear();
                              searchCityColumn = false;
                              specialityTypeColumn = true;
                              hospitalColumn = false;
                              doctorColumn = false;
                            });
                          },
                          child: textContainer(specialityTypeText)),
                      textWithPadding('HOSPITAL'),
                      hospitalColumn? Column(
                        children: [
                          TextField(
                            decoration: textFieldDecoration('Search Hospital'),
                            controller: searchFilterController,
                            onChanged: applyFilter,
                          ),
                          Container(
                            width: double.infinity,
                            height: 200,
                            child: ListView.builder(
                                itemCount:filterColumn? filterList.length : hospitalList.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    visualDensity: const VisualDensity(vertical: -4),
                                    onTap: (){
                                      hospitalText = filterColumn? filterList[index].name : hospitalList[index].name;
                                      careProviderID = filterColumn? filterList[index].id : hospitalList[index].id;
                                      setState(() {
                                        filterColumn = false;
                                        hospitalColumn = false;
                                      });
                                    },
                                    contentPadding :EdgeInsets.zero,
                                    title: Container(
                                        width: double.infinity,
                                        padding: EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                              width: 1,
                                              color: Colors.grey
                                          ),
                                          borderRadius: BorderRadius.circular(8),),
                                        child: Text(filterColumn? filterList[index].name : hospitalList[index].name)),
                                  );
                                }
                            ),
                          )
                        ],
                      ): InkWell(
                          onTap: (){
                            setState(() {
                              searchFilterController.clear();
                              searchCityColumn = false;
                              specialityTypeColumn = false;
                              hospitalColumn = true;
                              doctorColumn = false;
                            });
                          },
                          child: textContainer(hospitalText)),
                      textWithPadding('DOCTOR'),
                      doctorColumn? Column(
                      children: [
                        TextField(
                          decoration: textFieldDecoration('Search Doctor'),
                          controller: searchFilterController,
                          onChanged: applyFilter,
                        ),
                        Container(
                          width: double.infinity,
                          height: 200,
                          child: ListView.builder(
                              itemCount:filterColumn? filterList.length : doctorList.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  visualDensity: const VisualDensity(vertical: -4),
                                  onTap: (){
                                    doctorText = filterColumn? filterList[index].name : doctorList[index].name;
                                    doctorIDF = filterColumn? filterList[index].id : doctorList[index].id;
                                    setState(() {
                                      filterColumn = false;
                                      doctorColumn = false;
                                    });
                                  },
                                  contentPadding :EdgeInsets.zero,
                                  title: Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                            width: 1,
                                            color: Colors.grey
                                        ),
                                        borderRadius: BorderRadius.circular(8),),
                                      child: Text(filterColumn? filterList[index].name : doctorList[index].name)),
                                );
                              }
                          ),
                        )
                      ],
                    ): InkWell(
                        onTap: (){
                          setState(() {
                            searchFilterController.clear();
                            searchCityColumn = false;
                            specialityTypeColumn = false;
                            hospitalColumn = false;
                            doctorColumn = true;
                          });
                        },
                        child: textContainer(doctorText)),
                      InkWell(
                        onTap: (){
                          Get.to(DoctorListPage(url: '$urlForIN/appointmentSearchCareProfessionalAndroid.shc?DoctorIDF=$doctorIDF&appointmentTypeTeleOrClinic=0&availabilityEndTime=24&availabilityStartTime=00&careProviderID=$careProviderID&cityID=$cityID&selectedWeekArray=%5Btrue,true,true,true,true,true,true%5D&specialityID=$specialityID'));
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 20),
                          padding: EdgeInsets.all(15),
                          decoration: ColorFillContainer(Colors.lightGreen),
                          width: double.infinity,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Find Doctor',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                                Icon(Icons.arrow_forward,color: Colors.white,)
                              ],
                            )
                        ),
                      ),
                      InkWell(
                        onTap: (){
                           setState(() {
                             cityText = 'Search City';
                             specialityTypeText = 'Search Speciality Type';
                             hospitalText = 'Search Hospital';
                             doctorText = 'Search Doctor';
                             doctorIDF = '';
                             careProviderID = '';
                             cityID = '';
                             specialityID = '';
                             searchCityColumn = false;
                             specialityTypeColumn = false;
                             hospitalColumn = false;
                             doctorColumn = false;
                             filterColumn = false;
                           });
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 20,bottom: 20),
                          padding: EdgeInsets.all(15),
                          decoration: ColorFillContainer(Colors.lightGreen),
                          width: double.infinity,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Reset',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                                Icon(Icons.refresh,color: Colors.white,)
                              ],
                            )
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
