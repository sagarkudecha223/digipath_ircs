import 'package:digipath_ircs/Design/GlobalAppBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_week/flutter_calendar_week.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/route_manager.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import '../../Global/Toast.dart';
import '../../ModalClass/TimeSlotsModal.dart';
import 'ConfirmTimeSlotpage.dart';

class FixTimeSlotPage extends StatefulWidget {
  const FixTimeSlotPage({Key? key}) : super(key: key);

  @override
  State<FixTimeSlotPage> createState() => _FixTimeSlotPageState();
}

class _FixTimeSlotPageState extends State<FixTimeSlotPage> {

  String date =DateFormat('yyyy-MM-dd').format(DateTime.now());
  int time =DateTime.now().hour;
  String current_date = DateFormat('dd-MMM-yyyy').format(DateTime.now());
  late final CalendarWeekController _controller = CalendarWeekController();
  bool todaySelect = true;
  List<TimeSlotsModal> timeSlotsList = <TimeSlotsModal>[];
  late int selectedIndex = 100;

  @override
  void initState() {
    super.initState();
    readJson(true);
  }

  Future<void> readJson(bool isToday) async {

    EasyLoading.show(status: 'Loading...');
    selectedIndex = 100;
    timeSlotsList.clear();

      final String response = await rootBundle.loadString('assets/JSON/initialTimeSlots.json');
      final List<dynamic> data = await json.decode(response);

      for(int i=0 ; i<data.length ; i++){
        String startTime = data[i]['startTime'].toString();
        String endTime = data[i]['endTime'].toString();
        String isEnable = data[i]['booked'].toString();
        DateTime jsonDateTime = DateFormat('h:mm a').parse(startTime);
        String formattedTime = DateFormat.jm().format(DateTime.now());
        DateTime currentTime = DateFormat('h:mm a').parse(formattedTime);

        late String convert;

        if(startTime.contains('PM')){
          convert = startTime.replaceAll('PM', 'P.M.');
        }else {
          convert = startTime.replaceAll('AM', 'A.M.');
        }
        print(convert);

        if(isToday == true){
          if( (jsonDateTime.compareTo(currentTime))>0){
            isEnable = 'true';
          }
          else{
            isEnable = 'false';
          }
        }
        timeSlotsList.add(TimeSlotsModal(SlotInterval: endTime, ScheduleTimeSlotIDP: '', time: startTime, isEnable: isEnable, isVisible: ''));
      }
      setState(() {
        EasyLoading.dismiss();
      });
    }

  @override
  void dispose() {
    EasyLoading.dismiss();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GlobalAppBar(context,''),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
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
                    bool todayDate = DateTime.now().isBefore(datetime);
                    current_date = DateFormat('dd-MMM-yyyy').format(datetime);
                    print('$date....$current_date');

                    setState(() {
                      if(todayDate == false){
                        todaySelect = true;
                        readJson(todaySelect);
                      }
                      else{
                        todaySelect = false;
                        readJson(todaySelect);
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
                )
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.only(top:30,left: 5,right: 5),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15)
                ),
                height: double.infinity,
                width: double.infinity,
                child: GridView.builder(
                  itemCount: timeSlotsList.length,
                  padding: const EdgeInsets.symmetric(vertical: 0,horizontal: 0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 3.5 / 2,
                      crossAxisSpacing: 0,
                      mainAxisSpacing: 0
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: (){
                        setState(() {
                          if(timeSlotsList[index].isEnable == 'false'){
                            showToast('This Time Slots is unavailable');
                          }else{
                            selectedIndex = index;
                            Get.to(ConfirmTimeSlotPage(startTime: timeSlotsList[index].time, endTime: timeSlotsList[index].SlotInterval, current_date: current_date,));
                          }
                        });
                      },
                      child: Container(
                          margin: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: timeSlotsList[index].isEnable == 'false'? Colors.red.shade300 : selectedIndex == index ? Colors.grey : Colors.greenAccent.shade200,
                              borderRadius: BorderRadius.circular(15)
                          ),
                          height: 20,width: 100,
                          child: Center(child: Text(timeSlotsList[index].time,style: TextStyle(fontSize: 16,color:  selectedIndex == index ? Colors.white : Colors.grey.shade800,
                              fontWeight: FontWeight.w500),textAlign: TextAlign.center,))
                      ),
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
