import 'dart:convert';
import 'package:digipath_ircs/Design/BorderContainer.dart';
import 'package:digipath_ircs/Design/GlobalAppBar.dart';
import 'package:digipath_ircs/Global/Colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:http/http.dart';
import 'package:lottie/lottie.dart';
import '../Global/Toast.dart';
import '../Global/global.dart';
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
  Map<String, HighlightedWord> words = {};

  void searchOperation(String searchText) {

    if(searchText.length == 3){
      FocusManager.instance.primaryFocus?.unfocus();
      words = {
        searchText: HighlightedWord(
          textStyle: TextStyle(color: Colors.red.shade500,fontWeight: FontWeight.w600,fontSize: 16,fontFamily: 'Ageo'),
        ),
      };
      goForSearch(searchText);
    }
    else if(searchText.length >3){
      filterTheList(searchText);
    }
    else if(searchText.length<3){
      setState(() {
        words = {};
        noDataBool = false;
        filter = false;
        searchList.clear();
      });
    }
    else if(searchText.isEmpty){
      words = {};
      setState(() {
        noDataBool = false;
        filter = false;
      });
    }
  }

  void filterTheList(String searchText){
    filterList.clear();

    words = {
      searchText: HighlightedWord(
        textStyle: TextStyle(color: Colors.red.shade500,fontWeight: FontWeight.w600,fontSize: 16,fontFamily: 'Ageo'),
      ),
    };

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
    }
    else{
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
            'token' : token
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
      appBar:  GlobalAppBar(context,searchType),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(15),
        color: Colors.indigo.shade100,
        child: Column(
          children: [
            TextField(
              autofocus: true,
              controller: _controller,
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white60,
                  prefixIcon: const Icon(Icons.search,color: Colors.indigo,),
                  suffixIcon: IconButton(
                    // color: Colors.grey[600],
                    icon: const Icon(Icons.cancel,color: Colors.indigo),
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
            const SizedBox(
              height: 10,
            ),
            noDataBool? Flexible(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Lottie.asset('assets/JSON/MainemptySearch.json',repeat: true,height: 300,width: 300),
                    Text(noDataText,style: const TextStyle(fontWeight: FontWeight.w600,color: Colors.indigo,fontSize: 15))
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
                    visualDensity: const VisualDensity(vertical: -4),
                    contentPadding :EdgeInsets.zero,
                    title: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BorderContainer(Colors.white,globalBlue),
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              searchType == 'Care Professional'?Image.asset('assets/images/doctor.png',color: Colors.indigo.shade300,height: 25,width: 25,):const SizedBox(height: 0,width: 0,),
                              const SizedBox(width: 15,),
                              Flexible(
                                child: TextHighlight(
                                    text: filter?filterList[index].text : searchList[index].text,
                                  words: words,
                                  textStyle: TextStyle(color: Colors.grey.shade800,fontWeight: FontWeight.w600,fontSize: 16,fontFamily: 'Ageo'),
                                )
                              ),
                            ],
                          ),
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
