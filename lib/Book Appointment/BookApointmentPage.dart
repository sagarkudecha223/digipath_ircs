import 'package:digipath_ircs/Book%20Appointment/DoctorListPage.dart';
import 'package:digipath_ircs/Global/Colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/route_manager.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:lottie/lottie.dart';
import '../Design/BorderContainer.dart';
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
  bool noDataBool = false;
  late String noDataText;
  Map<String, HighlightedWord> words = {};

  @override
  void initState() {
    super.initState();
    searchData();
  }

  void searchData() async{

    EasyLoading.show(status: 'Loading...');

    dynamic status = await searchAPI(false ,'$urlForINSC/findCareProfessionalForAppointment.do?cityID&facultyID&careProviderID&doctorID',
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

    words = {
      searchText: HighlightedWord(
        textStyle: TextStyle(color: Colors.red.shade500,fontWeight: FontWeight.w600,fontSize: 15,fontFamily: 'Ageo'),
      ),
    };

    if(searchCityColumn == true){

      if(searchText.isNotEmpty){
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

      if(searchText.isNotEmpty){
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
      if(searchText.isNotEmpty){
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
      if(searchText.isNotEmpty){
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

    if(filterList.isEmpty && searchText.length >=1){
      print('Enter');
      setState((){
        noDataBool = true;
        noDataText = 'No Search Found For $searchText';
      });
    }
    else{
      setState((){
        noDataBool = false;
      });
    }
  }

  Padding textWithPadding(String text){
    return Padding(padding: EdgeInsets.only(top: 20,bottom: 2,left: 5),
    child: Text(text, style: TextStyle(fontSize: 14,color: Colors.grey.shade600,fontWeight: FontWeight.w500),),);
  }

  InputDecoration textFieldDecoration(String hintText){
    return InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 0.0,horizontal: 10),
        suffixIcon: InkWell(
          onTap: (){
            setState(() {
              filterColumn = false;
              searchCityColumn = false;
              specialityTypeColumn = false;
              hospitalColumn = false;
              doctorColumn = false;
              filterColumn = false;
              noDataBool = false;
            });
          },
          child: const Icon(Icons.cancel,color: Colors.indigo,)
        ),
        hintText:  hintText,
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

  Container textContainer(String text){
    return Container(
        decoration: ColorFillContainer(Colors.grey.shade300),
        width: double.infinity,
        padding: EdgeInsets.all(15),
        child: Text(text,style: TextStyle(fontWeight: FontWeight.w600,color: Colors.grey.shade800),));
  }

  @override
  void dispose() {
    FocusManager.instance.primaryFocus?.unfocus();
    EasyLoading.dismiss();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GlobalAppBar(context,'Book Appointment'),
      body: Container(
        height: MediaQuery.of(context).size.height ,
        width: MediaQuery.of(context).size.width ,
        color: globalPageBackgroundColor,
        child: SingleChildScrollView(
          child: Column(
            children: [
              TopPageTextViews('Search to Book Appointment'),
              Container(
                padding: const EdgeInsets.only(left: 20,right: 20),
                margin: const EdgeInsets.only(left: 15,right: 15,top: 10),
                decoration: BorderContainer(Colors.white,globalBlue),
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
                            child: noDataBool? Column(
                              children: [
                                Lottie.asset('assets/JSON/MainemptySearch.json',repeat: true,height: 150,width: 150),
                                Text(noDataText,style: const TextStyle(fontWeight: FontWeight.w600,color: Colors.indigo,fontSize: 15))
                              ],
                            ) : ListView.builder(
                                itemCount:filterColumn? filterList.length : cityList.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    visualDensity: const VisualDensity(vertical: -4),
                                    onTap: (){
                                      cityText = filterColumn? filterList[index].name : cityList[index].name;
                                      cityID =  filterColumn? filterList[index].id : cityList[index].id;
                                      final split = cityID.split(',');
                                      final Map<int, String> values = {
                                        for (int i = 0; i < split.length; i++)
                                          i: split[i]
                                      };
                                      print(values);
                                      cityID = values[0].toString();
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
                                        child: TextHighlight( text: filterColumn? filterList[index].name : cityList[index].name, words: words,
                                          textStyle: TextStyle(color: Colors.grey.shade800,fontWeight: FontWeight.w500,fontSize: 15,fontFamily: 'Ageo'),)),
                                  );
                                }
                            ),
                          )
                        ],
                      ): InkWell(
                          onTap: (){
                            setState(() {
                              words = {};
                              searchFilterController.clear();
                              searchCityColumn = true;
                              specialityTypeColumn = false;
                              noDataBool = false;
                              filterColumn = false;
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
                            child: noDataBool? Column(
                              children: [
                                Lottie.asset('assets/JSON/MainemptySearch.json',repeat: true,height: 150,width: 150),
                                Text(noDataText,style: const TextStyle(fontWeight: FontWeight.w600,color: Colors.indigo,fontSize: 15))
                              ],
                            ) : ListView.builder(
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
                                        child: TextHighlight(text :filterColumn? filterList[index].name : specialistTypeList[index].name,words: words,
                                          textStyle: TextStyle(color: Colors.grey.shade800,fontWeight: FontWeight.w500,fontSize: 15,fontFamily: 'Ageo'),)),
                                  );
                                }
                            ),
                          )
                        ],
                      ): InkWell(
                          onTap: (){
                            setState(() {
                              words = {};
                              searchFilterController.clear();
                              searchCityColumn = false;
                              specialityTypeColumn = true;
                              hospitalColumn = false;
                              filterColumn = false;
                              noDataBool = false;
                              doctorColumn = false;
                            });
                          },
                          child: textContainer(specialityTypeText)),
                      // textWithPadding('HOSPITAL'),
                      // hospitalColumn? Column(
                      //   children: [
                      //     TextField(
                      //       decoration: textFieldDecoration('Search Hospital'),
                      //       controller: searchFilterController,
                      //       onChanged: applyFilter,
                      //     ),
                      //     Container(
                      //       width: double.infinity,
                      //       height: 200,
                      //       child: noDataBool? Column(
                      //         children: [
                      //           Lottie.asset('assets/JSON/MainemptySearch.json',repeat: true,height: 150,width: 150),
                      //           Text(noDataText,style: const TextStyle(fontWeight: FontWeight.w600,color: Colors.indigo,fontSize: 15))
                      //         ],
                      //       ) : ListView.builder(
                      //           itemCount:filterColumn? filterList.length : hospitalList.length,
                      //           itemBuilder: (context, index) {
                      //             return ListTile(
                      //               visualDensity: const VisualDensity(vertical: -4),
                      //               onTap: (){
                      //                 hospitalText = filterColumn? filterList[index].name : hospitalList[index].name;
                      //                 careProviderID = filterColumn? filterList[index].id : hospitalList[index].id;
                      //                 setState(() {
                      //                   filterColumn = false;
                      //                   hospitalColumn = false;
                      //                 });
                      //               },
                      //               contentPadding :EdgeInsets.zero,
                      //               title: Container(
                      //                   width: double.infinity,
                      //                   padding: EdgeInsets.all(5),
                      //                   decoration: BoxDecoration(
                      //                     color: Colors.white,
                      //                     border: Border.all(
                      //                         width: 1,
                      //                         color: Colors.grey
                      //                     ),
                      //                     borderRadius: BorderRadius.circular(8),),
                      //                   child: TextHighlight(text:filterColumn? filterList[index].name : hospitalList[index].name,words: words,
                      //                       textStyle: TextStyle(color: Colors.grey.shade800,fontWeight: FontWeight.w500,fontSize: 15,fontFamily: 'Ageo'))),
                      //             );
                      //           }
                      //       ),
                      //     )
                      //   ],
                      // ): InkWell(
                      //     onTap: (){
                      //       setState(() {
                      //         words = {};
                      //         searchFilterController.clear();
                      //         searchCityColumn = false;
                      //         specialityTypeColumn = false;
                      //         hospitalColumn = true;
                      //         filterColumn = false;
                      //         noDataBool = false;
                      //         doctorColumn = false;
                      //       });
                      //     },
                      //     child: textContainer(hospitalText)),
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
                          child: noDataBool? Column(
                            children: [
                              Lottie.asset('assets/JSON/MainemptySearch.json',repeat: true,height: 150,width: 150),
                              Text(noDataText,style: const TextStyle(fontWeight: FontWeight.w600,color: Colors.indigo,fontSize: 15))
                            ],
                          ) : ListView.builder(
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
                                      child: TextHighlight(text:filterColumn? filterList[index].name : doctorList[index].name,words: words,
                                          textStyle: TextStyle(color: Colors.grey.shade800,fontWeight: FontWeight.w500,fontSize: 15,fontFamily: 'Ageo'))),
                                );
                              }
                          ),
                        )
                      ],
                    ): InkWell(
                        onTap: (){
                          setState(() {
                            words = {};
                            searchFilterController.clear();
                            searchCityColumn = false;
                            specialityTypeColumn = false;
                            noDataBool = false;
                            hospitalColumn = false;
                            doctorColumn = true;
                          });
                        },
                        child: textContainer(doctorText)),
                      InkWell(
                        onTap: (){
                          Get.to(DoctorListPage(url: '$urlForINSC/appointmentSearchCareProfessionalAndroid.shc?DoctorIDF=$doctorIDF&appointmentTypeTeleOrClinic=0&availabilityEndTime=24&availabilityStartTime=00&careProviderID=$careProviderID&cityID=$cityID&selectedWeekArray=%5Btrue,true,true,true,true,true,true%5D&specialityID=$specialityID'));
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 20),
                          padding: EdgeInsets.all(15),
                          decoration: ColorFillContainer(globalOrange),
                          width: double.infinity,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text('Find Appointment',style: TextStyle(color: Colors.white,fontFamily: 'Ageo_Bold',fontSize: 16),),
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
                          decoration: ColorFillContainer(globalOrange),
                          width: double.infinity,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text('Reset',style: TextStyle(color: Colors.white,fontFamily: 'Ageo_Bold',fontSize: 16),),
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
