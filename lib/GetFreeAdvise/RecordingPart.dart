import 'dart:io';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lottie/lottie.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import '../Animation/CirclePainter.dart';

class RecordingPart extends StatefulWidget {
  const RecordingPart({Key? key}) : super(key: key);

  @override
  State<RecordingPart> createState() => _TestPageState();
}

class _TestPageState extends State<RecordingPart> with TickerProviderStateMixin{
  String statusText = "";
  bool isComplete = false;
  String recordFilePath = '';
  String filename = 'Long pressed & hold the mic button for start recording...';
  String duration = '0';
  late AnimationController controller;
  late AnimationController buttonController;
  late Animation<double> animation;
  bool micButton = false;
  String audioStatus = 'play';
  late AudioPlayer audioPlayer = AudioPlayer();
  final record = Record();
  bool isPlaying = false;
  late bool hasPermission;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    buttonController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat();

    animation = Tween<double>(begin: 0.0, end: 1.0).animate(controller);
    getPermission();
  }

  void getPermission() async{
    if (!await Permission.microphone.isGranted) {
      hasPermission = false;
    }
    else{
      hasPermission = true;
    }
    print('Permission Is ::: $hasPermission');
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    controller.dispose();
    buttonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
              onLongPress: () async{
                if(hasPermission){
                  setState(() {
                    micButton = true;
                  });
                  controller.reset();
                  audioPlayer.stop();
                  startRecord();
                  print('start recording :::::::::');
                }
                else{
                  hasPermission = await checkPermission();
                }
              },
              onLongPressEnd:(_){
                if(micButton){
                  stopRecord();
                  setState(() {
                    micButton = false;
                    print('stop recording ::::::::');
                  });
                }
              },
              child:micButton? CustomPaint(
                  painter: CirclePainter(buttonController, color: Colors.grey.shade400),
                  child: Icon(Icons.mic,size: 30,color: Colors.red,)
              ) : Icon(Icons.mic,size: 30,color: Colors.indigo,)
          ),
          micButton?Lottie.asset('assets/JSON/rec_animation.json',repeat: true,height: 40):
          recordFilePath.isNotEmpty? Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(Icons.music_note_rounded,color: Colors.indigo,),
              Text(recordFilePath.isEmpty?filename: filename.toUpperCase(),textAlign: TextAlign.center, style: TextStyle(fontSize: 15,color: Colors.indigo,fontWeight: FontWeight.w600)),
            ],
          ): Flexible(child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(filename.toUpperCase(),textAlign: TextAlign.center, style: TextStyle(fontSize: 15,color: Colors.indigo,fontWeight: FontWeight.w600)),
          )),
          isComplete?InkWell(
            onTap: (){
              setState(() {
                filename = 'Long pressed & hold the mic button for start recording...';
                isComplete = false;
                audioStatus = 'play';
                controller.reset();
                audioPlayer.stop();
                recordFilePath = '';
              });
            },
            child: Icon(Icons.delete,size: 25,color: Colors.indigo,)
          ):SizedBox(width: 30,)
        ],
      ),
      SizedBox(height: 10,),
      Visibility(
        visible: isComplete,
        child: Column(
          children: [
            InkWell(
                 onTap: (){
                  if(!(audioPlayer.playing)){
                    controller.forward();
                    play();
                    setState(() {
                      print('Playing :::::::: ');
                      audioStatus = 'playing';
                    });
                  }
                  else{
                    setState(() {
                      print('Pause :::::::::');
                      audioStatus = 'pause';
                      controller.reverse();
                      audioPlayer.pause();
                    });
                  }
                  },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedIcon(icon: AnimatedIcons.play_pause, progress: animation,size: 25,color: Colors.indigo),
                    SizedBox(width: 10,),
                    Text(audioStatus.toUpperCase(),style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600,color: Colors.indigo),)
                  ],
                )
            ),
            SizedBox(height: 10,),
            Visibility(
              visible: duration  != '0.00',
              child: Text('Duration is : $duration Seconds', style: TextStyle(fontSize: 15,color: Colors.indigo,fontWeight: FontWeight.w600),)),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(left: 30.0, right: 30,top: 15),
        child: Column(
          children: [
            Visibility(
                visible: (audioStatus == 'playing' || audioStatus == 'pause' || micButton != false),
                child: Lottie.asset('assets/JSON/sound_wave.json',repeat: true,animate: audioStatus == 'pause'?false : true,reverse: true)
            ),
          ],
        ),
      ),
    ]
    );
  }

  Future<bool> checkPermission() async {
    if (!await Permission.microphone.isGranted) {
      PermissionStatus status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        return false;
      }
    }
    return true;
  }

  void startRecord() async {
      statusText = "Recording...";
      recordFilePath = await getFilePath();
      isComplete = false;
      await record.start(
        path: recordFilePath,
        encoder: AudioEncoder.aacLc, // by default
        bitRate: 128000, // by default
        samplingRate: 44100, // by default
      );

      if(recordFilePath.isNotEmpty){
        setState(() {
          isPlaying = false;
          audioStatus = 'play';
        });
      }
  }

  void stopRecord() async{
    await record.stop();
    audioPlayer = AudioPlayer();
    await audioPlayer.setUrl(recordFilePath, preload: true);
    int? time =  audioPlayer.duration?.inMilliseconds.toInt();
    print('time::::::: $time');

    double second = time!/1000;
    print('second :::::::::: $second');
    duration = second.toStringAsFixed(2);

    setState((){
      statusText = "Record complete";
      isComplete = true;
    });
 }

  void play() async{

    if (recordFilePath != '' && File(recordFilePath).existsSync()) {
      if(isPlaying == false){
        audioPlayer = AudioPlayer();
        isPlaying = true;
        await audioPlayer.setUrl(recordFilePath, preload: true);
        audioPlayer.play();

        audioPlayer.processingStateStream.listen((state) async {
          print('State ::::: $state');
          if (state == ProcessingState.completed) {
            setState(() {
              isPlaying = false;
              audioPlayer = AudioPlayer();
              controller.reverse();
              audioStatus = 'Play';
            });
          }
        });
      }
      else{
        print('Re-Playing ::::::');
        audioPlayer.play();
      }
    }
  }

  int i = 0;

  Future<String> getFilePath() async {
    Directory storageDirectory = await getApplicationDocumentsDirectory();
    String sdPath = "${storageDirectory.path}/record";
    var d = Directory(sdPath);
    if (!d.existsSync()) {
      d.createSync(recursive: true);
    }
    filename = 'Recording.mp3';
    return "$sdPath/Answer_${i++}.mp3";
  }
}
