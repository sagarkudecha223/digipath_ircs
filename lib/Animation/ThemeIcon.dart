import 'package:flutter/material.dart';
import 'CirclePainter.dart';

class ThemeButton extends StatefulWidget {
  const ThemeButton({Key? key}) : super(key: key);

  @override
  State<ThemeButton> createState() => _ThemeButtonState();
}

class _ThemeButtonState extends State<ThemeButton> with SingleTickerProviderStateMixin{

  late AnimationController _controller;
  Color color =  Colors.green.shade700;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _controller,
        builder: (BuildContext context, _){
          return CustomPaint(
            painter: CirclePainter(_controller, color: color),
            child: Icon(Icons.verified_rounded,color:Colors.white,size: 80,),
          );
        }
    );
  }
}