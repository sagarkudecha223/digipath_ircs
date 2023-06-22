import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../Design/BorderContainer.dart';
import '../Design/ColorFillContainer.dart';
import '../Design/GlobalAppBar.dart';
import '../Design/TopPageTextViews.dart';
import '../Global/Colors.dart';
import '../Global/SearchAPI.dart';
import '../Global/Toast.dart';
import '../Global/global.dart';
import '../ModalClass/SearchCityModal.dart';

class NewEnquiryPage extends StatefulWidget {
  const NewEnquiryPage({Key? key}) : super(key: key);

  @override
  State<NewEnquiryPage> createState() => NewEnquiryPageState();
}

class NewEnquiryPageState extends State<NewEnquiryPage> {

  List<SearchCityModal> natureProblemList = <SearchCityModal>[];
  List<SearchCityModal> cityList = <SearchCityModal>[];
  String natureOfProblem = 'Nature of problem';
  String natureOfProblemID ='';
  bool searchCityView = false;
  TextEditingController searchCityController = TextEditingController();
  TextEditingController enquiryController = TextEditingController();
  bool filterColumn = false;
  List<SearchCityModal> filterlist =  <SearchCityModal>[];
  String cityText = 'Select City';
  String cityID = '';
  bool natureView = false;

  @override
  void initState() {
    super.initState();
    getNatureProblemList();
  }
  
  void getNatureProblemList() async{
    
    EasyLoading.show(status: 'Loading...');
    
    dynamic status = await searchAPI(false, '$urlForINSC/getEnquiryType.shc',
        {'token': token}, {}, 50);

    if(status.toString() != 'Sorry !!! Server Error' && status.toString().isNotEmpty && status.toString() != 'Sorry !!!  Connectivity issue! Try again'){

      List<dynamic> cityListStastus = status['data'];
      for(int i=0; i<cityListStastus.length; i++){
        String id = cityListStastus[i]['id'].toString();
        String name = cityListStastus[i]['name'].toString();
        natureProblemList.add(SearchCityModal(text: name, id: id));
      }

      setState(() {
        getcityList();
      });
    }
    else if(status.toString() == 'Sorry !!!  Connectivity issue! Try again'){
      showToast('Sorry !!!  Poor Internet Connectivity ! Try again');
    }
    else{
      if(mounted){
        EasyLoading.dismiss();
        showToast('Sorry !!! Server Error');
      }
    }
  }

  void getcityList() async{

    dynamic status = await searchAPI(false, '$urlForINSC/getCityStateCountry.notauth',
        {'token': token}, {}, 50);

    EasyLoading.dismiss();

    if(status.toString() != 'Sorry !!! Server Error' && status.toString().isNotEmpty && status.toString() != 'Sorry !!!  Connectivity issue! Try again'){

      for(int i=0; i<status.length; i++){
        String id = status[i]['id'].toString();
        String name = status[i]['name'].toString();
        cityList.add(SearchCityModal(text: name, id: id));
      }

      setState(() {

      });
    }
    else if(status.toString() == 'Sorry !!!  Connectivity issue! Try again'){
      showToast('Sorry !!!  Poor Internet Connectivity ! Try again');
    }
    else{
      if(mounted){
        EasyLoading.dismiss();
        showToast('Sorry !!! Server Error');
      }
    }
  }
  
  void submitData() async{

    EasyLoading.show(status: 'Loading...');

    final split = cityID.split(',');
    final Map<int, String> values = {
      for (int i = 0; i < split.length; i++)
        i: split[i]
    };
    print(values);

    String value1 = values[0].toString();

    dynamic status = await searchAPI(true, '$urlForINSC/insertPatientEnquiry.shc',
        { 'token' : token },
        {
          'citizenID' : localCitizenIDP,
          'enquiryTypeID' : natureOfProblemID,
          'enquiryText': enquiryController.text.toString(),
          'contactNumber' : localMobileNum,
          'cityID': value1
        },
        50);

    EasyLoading.dismiss();

    if(status.toString() != 'Sorry !!! Server Error' && status.toString().isNotEmpty && status.toString() != 'Sorry !!!  Connectivity issue! Try again'){

        String finalStatus = status['status'].toString();
        if(finalStatus == 'true'){
          Navigator.pop(context,'added');
        }
        else{
          showToast('Sorry !!! Please try again');
        }

    }
    else if(status.toString() == 'Sorry !!!  Connectivity issue! Try again'){
      EasyLoading.dismiss();
      showToast('Sorry !!!  Poor Internet Connectivity ! Try again');
    }
    else{
      if(mounted){
        EasyLoading.dismiss();
        showToast('Sorry !!! Server Error');
      }
    }
  }

  Text commonTopText(String text){
   return Text(text.toUpperCase(), style: TextStyle(color: Colors.grey,fontWeight: FontWeight.w600,fontSize: 14,letterSpacing: 0.2),);
  }

  void filterSearchCity(String searchText) {

    if(searchText.length >=2){
      filterlist.clear();
      for (int i = 0; i < cityList.length; i++) {
        if (cityList[i].text.toLowerCase().contains(searchText.toLowerCase())) {
          filterlist.add(cityList[i]);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo[100],
      appBar: GlobalAppBar(context,'ENQUIRY FORM'),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: globalPageBackgroundColor,
        child: SingleChildScrollView(
          child: Column(
            children: [
              TopPageTextViews('Generate your enquiry'),
              Container(
                margin: EdgeInsets.fromLTRB(20, 5, 20, 10),
                padding: EdgeInsets.all(20),
                decoration: BorderContainer(Colors.white,globalBlue),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    commonTopText('customer name'),
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(bottom: 20),
                      padding: EdgeInsets.all(12),
                      decoration: ColorFillContainer(Colors.grey.shade200),
                      child: Text(localUserName,style: TextStyle(fontWeight: FontWeight.bold,color: Colors.grey.shade800,fontSize: 16),),
                    ),
                    commonTopText('mobile number'),
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(bottom: 20),
                      padding: EdgeInsets.all(12),
                      decoration: ColorFillContainer(Colors.grey.shade200),
                      child: Text(localMobileNum,style: TextStyle(fontWeight: FontWeight.bold,color: Colors.grey.shade800,fontSize: 16),),
                    ),
                    commonTopText('nature of problem'),
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(bottom: 1),
                      padding: EdgeInsets.all(12),
                      decoration: ColorFillContainer(Colors.grey.shade200),
                      child: InkWell(
                        onTap: (){
                          setState(() {
                            natureView = !natureView;
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(natureOfProblem,style: TextStyle(fontWeight: FontWeight.bold,color: Colors.grey.shade800,fontSize: 15),),
                            Icon(natureView?Icons.arrow_drop_up_sharp: Icons.arrow_drop_down,size: 25,),
                          ],
                        ),
                      ),
                    ),
                    Visibility(
                      visible: natureView,
                      child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: natureProblemList.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: (){
                              natureOfProblem = natureProblemList[index].text;
                              natureOfProblemID = natureProblemList[index].id;
                              setState(() {
                                natureView = false;
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
                                child: Text(natureProblemList[index].text)),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                    commonTopText('enquiry message'),
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(bottom: 20),
                      padding: EdgeInsets.all(12),
                      decoration: ColorFillContainer(Colors.grey.shade200),
                      child: TextField(
                        controller: enquiryController,
                        maxLines: 2,
                        maxLength: 40,
                        decoration: InputDecoration(
                          border: InputBorder.none
                        ),
                      ),
                    ),
                    commonTopText('city'),
                    Container(
                      decoration: ColorFillContainer(Colors.grey.shade200),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: InkWell(
                                onTap: (){
                                  if(cityList.isEmpty){
                                    EasyLoading.show(status: 'Loading...');
                                    getcityList();
                                  }else{
                                    setState(() {
                                      searchCityView = true;
                                      FocusManager.instance.primaryFocus?.unfocus();
                                    });
                                  }
                                },
                                child: Text(cityText),
                              ),
                            ),
                            Visibility(
                              visible: cityID.isNotEmpty,
                              child: InkWell(
                                onTap: (){
                                  setState((){
                                    cityText = 'select City';
                                    cityID = '';
                                  });
                                  },
                                child: Icon(Icons.cancel)
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 1,),
                    Visibility(
                      visible: searchCityView,
                      child: Column(
                        children: <Widget>[
                          TextField(
                            controller: searchCityController,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(vertical: 0.0),
                              prefixIcon: Icon(Icons.search),
                              suffixIcon: InkWell(
                                  onTap: (){
                                    setState(() {
                                      searchCityView = false;
                                      searchCityController.clear();
                                      filterColumn = false;
                                    });
                                  },
                                  child: Icon(Icons.cancel)
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
                          Container(
                            height: 200,
                            child: ListView.builder(
                              // shrinkWrap: true,
                              itemCount:filterColumn? filterlist.length : cityList.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  visualDensity: VisualDensity(vertical: -4),
                                  onTap: (){
                                    cityText = filterColumn? filterlist[index].text : cityList[index].text;
                                    cityID = filterColumn? filterlist[index].id : cityList[index].id;
                                    setState(() {
                                      searchCityView = false;
                                      filterColumn = false;
                                      searchCityController.clear();
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
                                      child: Text(filterColumn? filterlist[index].text : cityList[index].text)),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30,),
                    InkWell(
                      onTap: (){
                        if(natureOfProblemID.isEmpty){
                          showToast('Please select Nature of problem');
                        }
                        else if(enquiryController.text.isEmpty){
                          showToast('Enquiry message ! should not be blank !');
                        }
                        else if(cityID.isEmpty){
                          showToast('Please select City');
                        }
                        else{
                          submitData();
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        decoration: ColorFillContainer(globalOrange),
                        padding: EdgeInsets.all(10),
                        child: Text('submit'.toUpperCase(),style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 15),textAlign: TextAlign.center,),
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