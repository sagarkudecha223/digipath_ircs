import 'package:digipath_ircs/Design/GlobalAppBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_week/flutter_calendar_week.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/route_manager.dart';
import 'package:intl/intl.dart';
import '../Animation/ThemeIcon.dart';
import '../Design/ColorFillContainer.dart';
import '../Global/SearchAPI.dart';
import '../Global/Toast.dart';
import '../Global/global.dart';
import '../HomePage.dart';
import '../ModalClass/SelectServiceModal.dart';
import '../ModalClass/TimeSlotsModal.dart';

class TimeSlotPage extends StatefulWidget {
  final String careProviderIDP;
  final String CareProfessionalIDP;
  final String careProfessionalName;
  const TimeSlotPage({Key? key, required this.careProviderIDP, required this.CareProfessionalIDP, required this.careProfessionalName}) : super(key: key);

  @override
  State<TimeSlotPage> createState() => _TimeSlotPageState(careProviderIDP,CareProfessionalIDP,careProfessionalName);
}

class _TimeSlotPageState extends State<TimeSlotPage> with SingleTickerProviderStateMixin{

  _TimeSlotPageState(this.careProviderIDP, this.CareProfessionalIDP,this.careProfessionalName);

  late int selectedIndex = 100;
  late final CalendarWeekController _controller = CalendarWeekController();
  bool todaySelect = true;
  bool noData = true;
  late String time;
  late String isEnable;
  late String isVisible;
  late String selectedService ='';
  late String selectedServiceIDP ='';
  late String selectedTimeSlots ='';
  List<TimeSlotsModal> timeSlotsList = <TimeSlotsModal>[];
  List<SelectServiceModal> serviceList = <SelectServiceModal>[];
  late String careProviderIDP;
  late String CareProfessionalIDP;
  late String careProfessionalName;
  late String selectedTime;
  String noDataTextString = 'Searching...';
  bool verifyButton = false;

  String date =DateFormat('yyyy-MM-dd').format(DateTime.now());
  String current_date = DateFormat('dd-MMM-yyyy').format(DateTime.now());

  @override
  void initState() {
    super.initState();
    getTimeSlots(date, current_date);
    getServiceList();
  }

  void getServiceList() async{

    dynamic status = await searchAPI(false,
        '$urlForIN/careProfessionalSetting_smarthealth.shc?careProfesionalID=$CareProfessionalIDP&careProviderID=$careProviderIDP',
        {
          "token": "eyJhbGciOiJSUzI1NiJ9.eyJ1bmFtZSI6IjI2MDk3MTQ1NDA5MSIsInNlc3Npb25pZCI6IkQyN0I4QTBBQzNERjZCQzlEQUEwNUU2NTlDODk2NTk1Iiwic3ViIjoiSldUX1RPS0VOIiwianRpIjoiNWQxYWU3ZmYtMzJhOC00YWYxLWE4OTItODE1MWRiMDRlNzE3IiwiaWF0IjoxNjc4MTcyMTQzfQ.J4pK2XBzMaZNlgGAFxB1yFLUJoWKhzqHBKJbZfxwau7aBhMyb1ovWevVVgHQR5DsKJUhPbedNnhqvSOdLNO6uWn2qEwlGVpsslDCz1oftzA3NymnUF5xRoYoTkqjcM_3Raw6sVST9jAlw0hKmS_1tVJKBWdI1754FC-1o2qZ0mPOn-AT_1DGhWkFg88FRdtZAD2Zb7NUJ0vmvVlXzvkvhFEZsb-NksM4neAtWozUGqV-ZQ23JI21QDEZIC6Xj3khEJqNwVxNUrXH6CAdDU2QiDc7RJ6aN9HdqEdRvUSnvjA88qjBtQeNgp88rMMQ5g36WlzO0vQO4uO-Ek4pax9rpg"
        }, {}, 25);

    print(' status after responce: $status');
    serviceList.clear();

    if (status.toString() != 'Sorry !!! Server Error' && status.toString().isNotEmpty) {

      String dataStatus = status["status"].toString();
      if(dataStatus !='false'){
        List<dynamic>ServiceInfo = status["serviceName"];
        if(ServiceInfo.length!=0||ServiceInfo.isEmpty){
          for(int s=0; s<ServiceInfo.length;s++){
            String CPServiceRateIDP = ServiceInfo[s]["CPServiceRateIDP"].toString();
            String CareProfessionalIDP = ServiceInfo[s]["CareProfessionalIDP"].toString();
            String ServiceIDP = ServiceInfo[s]["ServiceIDP"].toString();
            String ServiceName = ServiceInfo[s]["ServiceName"].toString();
            String ServiceRate = ServiceInfo[s]["ServiceRate"].toString();
            serviceList.add(SelectServiceModal(CPServiceRateIDP: CPServiceRateIDP, CareProfessionalIDP: CareProfessionalIDP, ServiceIDP: ServiceIDP, ServiceName: ServiceName, ServiceRate: ServiceRate));
          }
        }
        if(serviceList.isEmpty){
          showToast('Service Not Available');
        }
      }else{
        if(mounted){
          setState(() {
            showToast('Sorry !!! No Data Available');
          });
        }
      }
    }
    else{
      if(mounted){
        setState(() {
          showToast('Sorry !!! Server Error');
        });
      }
    }
  }

  void getTimeSlots(String date, currentDate) async {

    timeSlotsList.clear();
    EasyLoading.show(status: 'Loading...');

    dynamic status = await searchAPI(false,'$urlForIN/getAppointmentTimeSlabSmartHealthReact.shc?careProviderIDP=$careProviderIDP&CareProfessionalIDP=$CareProfessionalIDP&date=$date&current_date=$currentDate',
        {"token": "eyJhbGciOiJSUzI1NiJ9.eyJ1bmFtZSI6IjI2MDk3MTQ1NDA5MSIsInNlc3Npb25pZCI6IkQyN0I4QTBBQzNERjZCQzlEQUEwNUU2NTlDODk2NTk1Iiwic3ViIjoiSldUX1RPS0VOIiwianRpIjoiNWQxYWU3ZmYtMzJhOC00YWYxLWE4OTItODE1MWRiMDRlNzE3IiwiaWF0IjoxNjc4MTcyMTQzfQ.J4pK2XBzMaZNlgGAFxB1yFLUJoWKhzqHBKJbZfxwau7aBhMyb1ovWevVVgHQR5DsKJUhPbedNnhqvSOdLNO6uWn2qEwlGVpsslDCz1oftzA3NymnUF5xRoYoTkqjcM_3Raw6sVST9jAlw0hKmS_1tVJKBWdI1754FC-1o2qZ0mPOn-AT_1DGhWkFg88FRdtZAD2Zb7NUJ0vmvVlXzvkvhFEZsb-NksM4neAtWozUGqV-ZQ23JI21QDEZIC6Xj3khEJqNwVxNUrXH6CAdDU2QiDc7RJ6aN9HdqEdRvUSnvjA88qjBtQeNgp88rMMQ5g36WlzO0vQO4uO-Ek4pax9rpg"
        }, {}, 25);

    print(' status after responce: $status');
    EasyLoading.dismiss();

    if (status.toString() != 'Sorry !!! Server Error' && status.toString().isNotEmpty  && status.toString() != 'Sorry !!!  Connectivity issue! Try again') {

      String slotInterval = status["SlotInterval"].toString();
      String scheduleTimeSlotIDP = status["ScheduleTimeSlotIDP"].toString();
      List<dynamic> mainTimeSlots = (status['finalAppointmentReactList'] ?? []);

      if(mainTimeSlots.isNotEmpty && mainTimeSlots !=''){

        for (int i = 0; i < mainTimeSlots.length; i++) {
          List<dynamic> secondList = mainTimeSlots[i];
          for(int j =0; j<secondList.length; j++){
            time = secondList[j]["time"].toString();
            isEnable = secondList[j]["isEnable"].toString();
            isVisible = secondList[j]["isVisible"].toString();

            if(time != '' && time.isNotEmpty){
              timeSlotsList.add(TimeSlotsModal(SlotInterval: slotInterval,ScheduleTimeSlotIDP: scheduleTimeSlotIDP,time: time,isEnable: isEnable,isVisible: isVisible));
            }
          }
        }
        verifyButton = true;
        noData = false;
      }else{
        noDataTextString = 'No matching data found';
        noData = true;
        verifyButton = false;
      }

      if(mounted){
        setState(() {
          EasyLoading.dismiss();
        });
      }
    }
    else if(status.toString() == 'Sorry !!!  Connectivity issue! Try again'){
      setState(() {
        noData = true;
        noDataTextString = 'Sorry !!!  Poor Internet Connectivity ! Try again';
      });
      showToast('Sorry !!!  Poor Internet Connectivity ! Try again');
    }
    else {
      if(mounted){
        setState(() {
          EasyLoading.dismiss();
          noData = true;
          verifyButton = false;
          noDataTextString = 'Sorry !!! Server Error';
          showToast('Sorry !!! Server Error');
        });
      }
    }
  }

  saveAppointmentData() async{

    /// https://admin.vinecare.co.zm/saveAppointmentCitizenForAppointmentSmartHealth.shc?citizenIDP=201928&ScheduleTimeSlotIDP=2532
    /// &SlotInterval=00:10&CareProvider=3345&CareProfessional=9379&selectedTime=13:00&purDetail=2,New Consultation&selectedDate=27-Apr-2023&
    /// serviceIDF=2&citizen_mobile=260971454091&loginID=4710&callFromCitizen=callFromCitizen&CITIZEN_URL=https://smarthealth.care/login?mobile='

    dynamic status = await searchAPI(true,'$urlForIN/saveAppointmentCitizenForAppointmentSmartHealth.shc?'
            'citizenIDP=$localCitizenIDP&ScheduleTimeSlotIDP=${timeSlotsList[0].ScheduleTimeSlotIDP}&SlotInterval=${timeSlotsList[0].SlotInterval}'
            '&CareProvider=$careProviderIDP&CareProfessional=$CareProfessionalIDP&selectedTime=$selectedTime&purDetail=$selectedServiceIDP,$selectedService'
            '&selectedDate=$current_date&serviceIDF=$selectedServiceIDP&citizen_mobile=$localMobileNum&loginID=$localUserLoginIDP&callFromCitizen=callFromCitizen&CITIZEN_URL=https://smarthealth.care/login?mobile=',
        {
          "token": token
        }, {}, 45);

    print(' status after responce: $status');
    EasyLoading.dismiss();

    if (status.toString() != 'Sorry !!! Server Error' && status.toString().isNotEmpty  && status.toString() != 'Sorry !!!  Connectivity issue! Try again') {

      String dataStatus = status["status"].toString();
        return dataStatus;
    }
    else if(status.toString() == 'Sorry !!!  Connectivity issue! Try again'){
      showToast('Sorry !!!  Poor Internet Connectivity ! Try again');
      return 'false';
    }
  }

  Widget divider =   const Divider(thickness: 1);

  Padding CommonRowPadding(String text1,String text2){
    return Padding(
      padding: const EdgeInsets.only(top: 8.0,bottom: 8),
      child: Row(
        children: [
          Expanded(child: Text(text1,style: TextStyle(color: Colors.grey[600]),)),
          Expanded(child: Text(text2,style: TextStyle(fontWeight: FontWeight.bold))),
        ],
      ),
    );
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
        child: Column(
          children: [
            Container(
                margin: EdgeInsets.all(5),
                padding: EdgeInsets.only(top:10,left: 5,right: 5),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15)
                ),
                child: CalendarWeek(
                  controller: _controller,
                  backgroundColor: Colors.transparent,
                  height: 105,
                  showMonth: true,
                  minDate: DateTime.now(),
                  maxDate: DateTime.now().add(Duration(days: 13),),
                  onDatePressed: (DateTime datetime) {

                    date = DateFormat('yyyy-MM-dd').format(datetime);
                    current_date = DateFormat('dd-MMM-yyyy').format(datetime);
                    getTimeSlots(date, current_date);
                    print(date + '....' + current_date);

                    setState(() {
                      if(date.contains(DateTime.now().day.toString())){
                        todaySelect = true;
                      }
                      else{
                        todaySelect = false;
                      }
                    });
                  },
                  pressedDateBackgroundColor: Colors.indigo.shade800,
                  dateBackgroundColor: Colors.black12,
                  todayBackgroundColor : todaySelect?Colors.indigo.shade800 : Colors.black12,
                  dateStyle: TextStyle(color: Colors.indigo[800],fontWeight: FontWeight.bold),
                  dayOfWeekStyle: TextStyle(color: Colors.indigo[800],fontWeight: FontWeight.bold),
                  todayDateStyle: TextStyle(color:todaySelect?Colors.white : Colors.indigo[800],fontWeight: FontWeight.bold),
                  weekendsStyle: TextStyle(color: Colors.indigo[800],fontWeight: FontWeight.bold),
                  onDateLongPressed: (DateTime datetime) {
                    // Do something
                  },
                  marginMonth : EdgeInsets.all(0),
                  marginDayOfWeek : EdgeInsets.only(bottom: 5),
                  onWeekChanged: () {
                    // Do something
                  },
                  monthViewBuilder: (DateTime time) => Align(
                    alignment: FractionalOffset.center,
                    child: Container(
                        margin:  const EdgeInsets.only(bottom: 10),
                        child: Text(
                          DateFormat.yMMMM().format(time),
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: TextStyle(color:Colors.indigo[800], fontWeight: FontWeight.bold),
                        )
                    ),
                  ),
                  decorations: [
                    // DecorationItem(
                    //   decorationAlignment: FractionalOffset.center,
                    //   date: DateTime.now().add(Duration(days: 1)),
                    // ),
                    // DecorationItem(
                    //     date: DateTime.now().add(Duration(days: 3))),
                  ],
                )
            ),
            const Padding(
              padding: EdgeInsets.only(left: 8.0,top: 10,bottom: 5),
              child: Text('Time Slots',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black87,fontSize: 18,letterSpacing: 0.5),),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.all(5),
                padding: EdgeInsets.only(top:10,left: 5,right: 5),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15)
                ),
                height: double.infinity,
                  child: noData ? Center(
                    child: Text(noDataTextString,style:const TextStyle(fontSize: 15,fontWeight: FontWeight.bold),textAlign: TextAlign.center),
                  ) : GridView.builder(
                    itemCount: timeSlotsList.length,
                    padding: EdgeInsets.symmetric(vertical: 0,horizontal: 0),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 3.5 / 2,
                        crossAxisSpacing: 0,
                        mainAxisSpacing: 0
                    ),
                    itemBuilder: (BuildContext context, int index){
                      return InkWell(
                        onTap: () async{
                          if(serviceList.isEmpty){
                            getServiceList();
                          }
                          else{
                            if(timeSlotsList[index].isEnable == 'false'){
                              showToast('This Time Slots is unavailable');
                            }
                            else{
                              setState(() {
                                selectedTimeSlots = timeSlotsList[index].time;
                                selectedIndex = index;
                              });
                              selectedTime = timeSlotsList[index].time;
                               showDialog<String>(
                                  context: context,
                                  builder: (context) =>TweenAnimationBuilder(
                                    tween: Tween<double>(begin: 0, end: 1),
                                    duration: Duration(milliseconds: 500),
                                    builder: (BuildContext context, double value, Widget? child) {
                                      return Opacity(opacity: value,
                                        child: Padding(
                                          padding: EdgeInsets.only(top: value * 1),
                                          child: child,
                                        ),
                                      );
                                    },
                                    child: Dialog(
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                      insetPadding: EdgeInsets.all(20),
                                      elevation: 16,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(left: 20,right: 20,top: 15,bottom: 10),
                                            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text('Select Service',style: TextStyle(fontWeight: FontWeight.w500,color: Colors.grey,fontSize: 19 ),),
                                                InkWell(child: Icon(Icons.cancel,size: 30,),
                                                    onTap: ()=>{ Navigator.pop(context, 'Cancel')}),
                                              ],),
                                          ),
                                          ListView.builder(
                                              shrinkWrap: true,
                                              itemCount:serviceList.length,
                                              itemBuilder: (context,index){
                                                return ListTile(
                                                    onTap: (){
                                                      selectedService = serviceList[index].ServiceName;
                                                      selectedServiceIDP = serviceList[index].ServiceIDP;
                                                      Navigator.pop(context, 'Cancel');
                                                    },
                                                    title:Container(
                                                        padding: EdgeInsets.all(10),
                                                        decoration: (BoxDecoration(
                                                          borderRadius: BorderRadius.circular(8),
                                                          color: Colors.indigo[100],
                                                        )),
                                                        child: Text(serviceList[index].ServiceName,style: TextStyle(color: Colors.indigo[900]),)
                                                    )
                                                );
                                              }),
                                          const SizedBox(
                                            height: 10,
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                              );
                            }
                          }
                        },
                        child: Container(
                          margin: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: timeSlotsList[index].isEnable == 'false'? Colors.red.shade400 : selectedIndex == index ? Colors.grey : Colors.greenAccent.shade200,
                                borderRadius: BorderRadius.circular(15)
                            ),
                          height: 20,width: 100,
                            child: Center(child: Text(timeSlotsList[index].time,style: TextStyle(fontSize: 16,color:  selectedIndex == index ? Colors.white : Colors.grey.shade800,
                                fontWeight: FontWeight.w500, decoration: timeSlotsList[index].isEnable == 'false'? TextDecoration.lineThrough : TextDecoration.none),textAlign: TextAlign.center,))),
                      );
                    },
                  )
              ),
            ),
            Visibility(
              visible: verifyButton,
              child: InkWell(
                onTap: (){
                  if(selectedService.isNotEmpty){
                    showDialog<String>(
                        context: context,
                        builder: (context) =>TweenAnimationBuilder(
                          tween: Tween<double>(begin: 0, end: 1),
                          duration: Duration(milliseconds: 500),
                          builder: (BuildContext context, double value, Widget? child) {
                            return Opacity(opacity: value,
                              child: Padding(
                                padding: EdgeInsets.only(top: value * 1),
                                child: child,
                              ),
                            );
                          },
                          child: Dialog(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            insetPadding: EdgeInsets.all(20),
                            elevation: 16,
                            child: Padding(
                              padding: const EdgeInsets.all( 30.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(top: 25.0,bottom: 50),
                                    child: Text('VERIFY DATA',style: TextStyle(fontSize: 26,fontWeight: FontWeight.bold),),
                                  ),
                                  CommonRowPadding('DATE',current_date),
                                  divider,
                                  CommonRowPadding('TIME',selectedTimeSlots),
                                  divider,
                                  CommonRowPadding('Dr Name',careProfessionalName),
                                  divider,
                                  CommonRowPadding('Service Name',selectedService),
                                  divider,
                                  Padding(
                                    padding: const EdgeInsets.only(top: 40.0),
                                    child: InkWell(
                                      onTap: () async {

                                        EasyLoading.show(status: 'Loading...');

                                        var data = await saveAppointmentData();

                                        if(data.toString() == 'true'){
                                          showDialog<void> (
                                              barrierDismissible : false,
                                              context: context,
                                              builder:(context) =>TweenAnimationBuilder(
                                                  tween: Tween<double>(begin: 0, end: 1),
                                                  duration: Duration(milliseconds: 500),
                                                  builder: (BuildContext context, double value, Widget? child) {
                                                    return Opacity(opacity: value,
                                                      child: Padding(
                                                        padding: EdgeInsets.only(top: value * 1),
                                                        child: child,
                                                      ),
                                                    );
                                                  },
                                                  child: Dialog(
                                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                                    insetPadding: EdgeInsets.all(20),
                                                    elevation: 16,
                                                    child : Padding(
                                                      padding: const EdgeInsets.all(30.0),
                                                      child: Column(
                                                        mainAxisSize: MainAxisSize.min,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          ThemeButton(),
                                                          const Padding(
                                                            padding: EdgeInsets.all(10.0),
                                                            child: Text('Confirmation',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30),),
                                                          ),
                                                          const Padding(
                                                            padding: EdgeInsets.only(bottom: 25.0),
                                                            child: Text('Your booking has been placed successfully',style: TextStyle(fontSize: 15),textAlign: TextAlign.center,),
                                                          ),
                                                          CommonRowPadding('DATE',current_date),
                                                          divider,
                                                          CommonRowPadding('TIME',selectedTimeSlots),
                                                          divider,
                                                          CommonRowPadding('Dr Name',careProfessionalName),
                                                          divider,
                                                          CommonRowPadding('Service Name',selectedService),
                                                          divider,
                                                          InkWell(
                                                            onTap: (){
                                                              Get.offAll(HomePage());
                                                            },
                                                            child: Container(
                                                              padding: EdgeInsets.all(15),
                                                              margin: EdgeInsets.only(top: 35),
                                                              decoration: ColorFillContainer(Colors.lightGreen),
                                                              width: double.infinity,
                                                              child: Center(child: Text('OK',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold))),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                              )
                                          );
                                        }
                                        else{
                                          showToast("Internal Error. Contact the System Administrator. OR Try again !!!");
                                          Navigator.pop(context);
                                        }
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(15),
                                        decoration: ColorFillContainer(Colors.lightGreen),
                                        width: double.infinity,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text('BOOK APPOINTMENT NOW',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                                            Icon(Icons.arrow_forward,color: Colors.white,)
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                    );
                  }
                  else{
                    showToast('Please Select Service first !!!');
                  }
                },
                child: Container(
                    margin: EdgeInsets.only(left: 5,right: 5,bottom: 3),
                    padding: EdgeInsets.all(15),
                    decoration: ColorFillContainer(Colors.lightGreen),
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('VERIFY DATA',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                        Icon(Icons.arrow_forward,color: Colors.white,)
                      ],
                    )
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}