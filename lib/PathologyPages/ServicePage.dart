import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../Design/ColorFillContainer.dart';
import '../Global/Toast.dart';
import '../Global/global.dart';

class ServicePage extends StatefulWidget {
  const ServicePage({Key? key}) : super(key: key);

  @override
  State<ServicePage> createState() => _ServicePageState();
}

class _ServicePageState extends State<ServicePage> {

  bool searchServiceColumn = false;
  bool filterEmpty = false;
  bool filterColumn = false;
  TextEditingController searchFilterController = TextEditingController();

  @override
  void initState() {
    super.initState();

    demoList.clear();
    for(int i=0; i<selectedServiceList.length; i++){
     demoList.add(selectedServiceList[i].name);
    }
  }

  void applyFilter(String searchText){

    if(searchText.length >=2){
      serviceFilterList.clear();
      for (int i = 0; i < serviceList.length; i++) {
        if (serviceList[i].name.toLowerCase().contains(searchText.toLowerCase())) {
          serviceFilterList.add(serviceList[i]);
          print(serviceFilterList.length);
        }
        else {
        }
      }
      if(serviceFilterList.isEmpty){
        setState(() {
          filterEmpty = true;
        });
      }else{
        setState(() {
          filterEmpty = false;
          filterColumn = true;
        });
      }
    }
    else{
      setState(() {
        filterEmpty = false;
        filterColumn = false;
      });
    }
  }

  InputDecoration textFieldDecoration(String hintText){
    return InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 0.0,horizontal: 10),
        hintText:  hintText,
        suffixIcon: InkWell(
          onTap: (){
            setState(() {
              searchFilterController.clear();
              searchServiceColumn = false;
              filterEmpty = false;
              filterColumn = false;
            });
          },
          child: const Icon(Icons.cancel,color: Colors.grey,size: 25,)),
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
    return Column(
      children: [
        SizedBox(height: 5,),
        searchServiceColumn? Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              // autofocus: true,
              decoration: textFieldDecoration('Search Service'),
              controller: searchFilterController,
              onChanged: applyFilter,
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    width: 1,
                    color: Colors.grey
                ),
              ),
              height: 250,
              child: filterEmpty? Center(
                child:  Lottie.asset('assets/JSON/noSearchResult.json',repeat: true,height: 200,width: 200),
              ) : ListView.builder(
                  itemCount:filterColumn? serviceFilterList.length : serviceList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      visualDensity: const VisualDensity(vertical: -4),
                      onTap: (){
                        if( demoList.contains(filterColumn? serviceFilterList[index].name : serviceList[index].name)){
                          showToast('This Service already selected');
                        }else{
                          demoList.add(filterColumn? serviceFilterList[index].name : serviceList[index].name);
                          selectedServiceList.add(filterColumn? serviceFilterList[index] : serviceList[index]);
                          setState(() {
                            searchServiceColumn = false;
                            filterColumn = false;
                          });
                        }
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(child: Text(filterColumn? '${serviceFilterList[index].name} (${serviceFilterList[index].amount} RS.)' : '${serviceList[index].name} (${serviceList[index].amount} RS.)',
                                  style: TextStyle(fontWeight: FontWeight.w500,color: Colors.grey.shade800,fontSize: 14))),
                              SizedBox(width: 10,),
                              demoList.contains(filterColumn? serviceFilterList[index].name : serviceList[index].name)?Icon(Icons.cancel_rounded,color: Colors.red,size: 28,) : Icon(Icons.add_circle_outline_rounded,color: Colors.green,size: 28,)
                            ],
                          )
                      ),
                    );
                  }
              ),
            )
          ],
        ): InkWell(
            onTap: (){
              setState(() {
                searchServiceColumn = true;
                searchFilterController.clear();
              });
            },
            child: Container(
                decoration: ColorFillContainer(Colors.grey.shade300),
                width: double.infinity,
                padding: EdgeInsets.all(15),
                child: Text('SELECT SERVICE',style: TextStyle(color: Colors.grey.shade800),)
            )
        ),
        Container(
          child: ListView.builder(
            itemCount: selectedServiceList.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index){
              return ListTile(
                visualDensity: VisualDensity(vertical: -4),
                contentPadding :EdgeInsets.zero,
                title: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(8),),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(child: Text('${selectedServiceList[index].name} (${selectedServiceList[index].amount} RS.)',style: TextStyle(fontWeight: FontWeight.w600,color: Colors.grey.shade800,fontSize: 14))),
                        SizedBox(width: 10,),
                        InkWell(
                            onTap: (){
                              setState(() {
                                demoList.remove(selectedServiceList[index].name);
                                selectedServiceList.remove(selectedServiceList[index]);
                              });
                            },
                            child: Icon(Icons.cancel_rounded,color: Colors.red,size: 28,)
                        )
                      ],
                    )),
              );
            },
          ),
        ),
      ],
    );
  }
}
