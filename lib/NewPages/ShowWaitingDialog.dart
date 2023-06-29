import 'dart:async';
import 'package:digipath_ircs/Global/Colors.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ShowWaitingDialogPage extends StatefulWidget {
  final int hour;
  final int minutes;
  final int seconds;
  const ShowWaitingDialogPage({Key? key, required this.hour, required this.minutes, required this.seconds}) : super(key: key);

  @override
  State<ShowWaitingDialogPage> createState() => _ShowWaitingDialogState(hour,minutes,seconds);
}

class _ShowWaitingDialogState extends State<ShowWaitingDialogPage>{

  late int hour;
  late int minutes;
  int seconds;

  _ShowWaitingDialogState(this.hour, this.minutes, this.seconds);

  Timer? countdownTimer;
  late Duration duration;

  @override
  void initState() {
    super.initState();
    duration = Duration(minutes: minutes);
    startTimer();
  }

  void startTimer() {
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) => setCountDown());
  }

  void setCountDown() {
    const reduceSecondsBy = 1;
    setState(() {
      final seconds = duration.inSeconds - reduceSecondsBy;
      if (seconds < 0) {
        countdownTimer!.cancel();
        Navigator.pop(context);
      } else {
        duration = Duration(seconds: seconds);
      }
    });
  }

  @override
  void dispose() {
    countdownTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String strDigits(int n) => n.toString().padLeft(2, '0');
    final days = strDigits(duration.inDays);
    // Step 7
    final hours = strDigits(duration.inHours.remainder(24));
    final minutes = strDigits(duration.inMinutes.remainder(60));
    final seconds = strDigits(duration.inSeconds.remainder(60));
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              color: globalLightBlue,
              shape: BoxShape.circle
            ),
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.all(10),
            child: Lottie.asset('assets/JSON/waiting.json',repeat: true,height: 200,width: 200)
          ),
          Padding(
            padding: const EdgeInsets.only(right: 30.0,left: 23,bottom: 10,top: 10),
            child: Text('You can join meeting after \t$hours : $minutes : $seconds',style: TextStyle(color: Colors.indigo[900],fontSize: 20,fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,),
          ),
        ],
      ),
    );
  }
}
