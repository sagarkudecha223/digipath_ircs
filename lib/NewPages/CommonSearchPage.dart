import 'dart:convert';
import 'package:digipath_ircs/Global/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart';
import 'package:lottie/lottie.dart';
import '../Global/Toast.dart';
import '../ModalClass/SearchCityModal.dart';

class CommonSearchPage extends StatefulWidget {

  final String url;
  final String searchType;

   CommonSearchPage({Key? key, required this.url, required this.searchType}) : super(key: key);

  @override
  State<CommonSearchPage> createState() => _CommonSearchPageState(url,searchType);
}

class _CommonSearchPageState extends State<CommonSearchPage> {

  late String url;
  late String searchType;
  _CommonSearchPageState(this.url, this.searchType);

  late TextEditingController _controller = TextEditingController();
  List<SearchCityModal> searchList = <SearchCityModal>[];
  List<SearchCityModal> filterList = <SearchCityModal>[];
  late String noDataText;
  bool noDataBool = false;
  bool filter = false;

  void searchOperation(String searchText) {

    if(searchText.length == 3){
      FocusManager.instance.primaryFocus?.unfocus();
      goForSearch(searchText);
    }
    else if(searchText.length >3){
      filterTheList(searchText);
    }
    else if(searchText.isEmpty){
      setState(() {
        noDataBool = false;
        filter = false;
      });
    }
  }

  void filterTheList(String searchText){

    filterList.clear();

    for(int i= 0; i<searchList.length; i++){
      if(searchList[i].text.toLowerCase().contains(searchText.toLowerCase())){
        filterList.add(searchList[i]);
      }
    }

    if(filterList.isNotEmpty){
      setState(() {
        noDataBool = false;
        filter = true;
      });
    }else{
      setState((){
        noDataBool = true;
        noDataText = 'No Search Found For ${_controller.text.toString()}';
      });
      }
   }

  void goForSearch(String searchText) async {

    EasyLoading.show(status: 'Searching For $searchText',dismissOnTap: false);
    searchList.clear();

    try{
      Response response = await get(
          Uri.parse('${url}searchText=$searchText'),
          headers: {
            'u': 'dhruv',
            'p': 'demo',
          }
      );

      EasyLoading.dismiss();
      FocusManager.instance.primaryFocus?.unfocus();

      if (response.statusCode == 200) {
        List<dynamic> statusinfo = jsonDecode(response.body.toString());
        print(statusinfo.toString());

        if(!(statusinfo.isEmpty || statusinfo ==[])) {
          for (int i = 0; i < statusinfo.length; i++) {
            String text = statusinfo[i]["text"].toString();
            String id = statusinfo[i]["id"].toString();

            searchList.add(SearchCityModal(id: id, text: text,));
          }
        }

        if (mounted) {
          setState(() {
            if (searchList.isEmpty) {
              noDataBool = true;
              noDataText = 'No Search Found For $searchText';
              FocusManager.instance.primaryFocus?.unfocus();
            }
            else {
              noDataBool = false;
              if (searchText.length == 3) {
                FocusManager.instance.primaryFocus?.unfocus();
              }
            }
          });
        }
      }
    }
    catch(e){
      EasyLoading.dismiss();
      showToast(e.toString());
    }
  }

  @override
  void dispose() {
    FocusManager.instance.primaryFocus?.unfocus();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(title: Text('Select $searchType',style: TextStyle(color: Colors.indigo.shade800),),
        leading: InkWell(
            onTap: (){
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios,color: Colors.indigo.shade800,)),
        elevation: 0.0,backgroundColor: Colors.indigo.shade100,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(15),
        color: Colors.indigo.shade100,
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white60,
                  prefixIcon: Icon(Icons.search,),
                  suffixIcon: IconButton(
                    // color: Colors.grey[600],
                    icon: Icon(Icons.cancel),
                    onPressed: () {
                      setState(() {
                        _controller.clear();
                        searchList.clear();
                        noDataBool = false;
                        filter = false;
                      });
                    },
                  ),
                  hintText: 'Enter 3 characters for Search',
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                      width: 1,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                        color: Colors.grey
                    ),
                  )
              ),
              onChanged: searchOperation,
            ),
            SizedBox(
              height: 10,
            ),
            noDataBool? Flexible(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Lottie.asset('assets/JSON/emptySearch.json',repeat: true,height: 300,width: 300),
                    Text(noDataText,style: TextStyle(fontWeight: FontWeight.w600,color: Colors.indigo,fontSize: 15))
                  ],
                ),
              ),
            ) : Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: filter?filterList.length : searchList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: (){
                      FocusManager.instance.primaryFocus?.unfocus();
                      if(filter == true){
                        Navigator.pop(context,'${filterList[index].text} || ${filterList[index].id}');
                      }else{
                        Navigator.pop(context,'${searchList[index].text} || ${searchList[index].id}');
                      }
                    },
                    visualDensity: VisualDensity(vertical: -4),
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
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Text(filter?filterList[index].text : searchList[index].text),
                        )),
                  );
                }
              ),
            )
          ],
        ),
      ),
    );
  }
}
