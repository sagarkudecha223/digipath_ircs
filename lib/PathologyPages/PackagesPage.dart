import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import '../Design/ColorFillContainer.dart';
import '../Global/global.dart';

class PackagesPage extends StatefulWidget {
  const PackagesPage({Key? key}) : super(key: key);

  @override
  State<PackagesPage> createState() => _PackagesPageState();
}

class _PackagesPageState extends State<PackagesPage> {

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.blue;
    }
    return Colors.blue;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount:trueServiceList.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index){
        int itemCount = 0;
        for(int i=0; i<totalPackageList.length; i++){
          if(trueServiceList[index].servicemapid == totalPackageList[i].serviceIDF){
           itemCount = itemCount + 1;
          }
        }
        trueServiceList[index].itemCount = itemCount;
        return Container(
          decoration: ColorFillContainer(Colors.indigo.shade50),
          margin: EdgeInsets.all(2),
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(trueServiceList[index].name,style: TextStyle(fontWeight: FontWeight.w600,color: Colors.grey.shade800,fontSize: 14),),
                      Text('${trueServiceList[index].amount} RS.',style: TextStyle(fontSize: 14,color: Colors.grey.shade800,fontWeight: FontWeight.w600),)
                    ],
                  ),
                  Row(
                    children:  [
                      Badge(
                        badgeStyle: BadgeStyle(
                          shape: BadgeShape.circle,
                          borderRadius: BorderRadius.circular(5),
                          padding: EdgeInsets.all(3),
                          badgeGradient: BadgeGradient.linear(
                            colors: [
                              Colors.indigo.shade500,
                              Colors.blue,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        position: BadgePosition.topEnd(top: -14),
                        badgeContent: Text(trueServiceList[index].itemCount<9?'0${trueServiceList[index].itemCount}' : '${trueServiceList[index].itemCount}', style: TextStyle(color: Colors.white,fontSize: 10),
                        ),
                        child: SizedBox(
                          height: 20,
                            width: 20,
                            child: Image.asset('assets/images/pathologyI_con.png')),
                      ),
                      SizedBox(width: 10,),
                      Checkbox(
                        checkColor: Colors.white,
                        fillColor: MaterialStateProperty.resolveWith(getColor),
                        value: trueServiceList[index].isSelected == 'false'?false : true,
                        onChanged: (bool? value) {
                          setState(() {
                            if(trueServiceList[index].isSelected == 'true'){
                              trueServiceList[index].isSelected = 'false';
                            }
                            else{
                              trueServiceList[index].isSelected = 'true';
                            }
                          });
                        },
                      ),
                      InkWell(
                          onTap: (){
                            setState(() {
                              if(trueServiceList[index].isVisible == true){
                                trueServiceList[index].isVisible = false;
                              }
                              else{
                                trueServiceList[index].isVisible = true;
                              }
                            });
                          },
                          child: trueServiceList[index].isVisible == false ?Icon(Icons.arrow_drop_down,color: Colors.grey.shade800,) : Icon(Icons.arrow_drop_up,color: Colors.grey.shade800)
                      )
                    ],
                  )
                ],
              ),
              Visibility(
                visible: trueServiceList[index].isVisible,
                child: ListView.builder(
                  itemCount: totalPackageList.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, insideIndex){
                    return trueServiceList[index].servicemapid == totalPackageList[insideIndex].serviceIDF?
                    Container(
                      decoration: ColorFillContainer(Colors.white),
                      padding: EdgeInsets.all(5),
                      margin: EdgeInsets.only(left: 10,right: 10,top: 2,bottom: 1),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.add_circle_outline_rounded,color: Colors.grey.shade600,),
                          SizedBox(width: 10,),
                          Flexible(child: Text(totalPackageList[insideIndex].serviceName,style: TextStyle(color: Colors.grey.shade800,fontWeight: FontWeight.w500,fontSize: 14),))
                        ],
                      ),
                    ) :
                    Container(
                      color: Colors.transparent,
                      height: 0,
                    );
                  },
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
