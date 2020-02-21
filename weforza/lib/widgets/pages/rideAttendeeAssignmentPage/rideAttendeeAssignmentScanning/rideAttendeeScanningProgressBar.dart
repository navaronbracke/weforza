import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:weforza/theme/appTheme.dart';
import 'package:weforza/widgets/pages/rideAttendeeAssignmentPage/rideAttendeeAssignmentScanning/rideAttendeeScanningStartTrigger.dart';

///This widget should get its size from its parent
class RideAttendeeScanningProgressBar extends StatefulWidget {
  RideAttendeeScanningProgressBar({@required this.duration}): assert(duration != null && duration > 0);

  final int duration;

  @override
  _RideAttendeeScanningProgressBarState createState() => _RideAttendeeScanningProgressBarState();
}

class _RideAttendeeScanningProgressBarState extends State<RideAttendeeScanningProgressBar> with SingleTickerProviderStateMixin {
  
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this,duration: Duration(seconds: widget.duration));
  }
  
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: RideAttendeeScanStartTrigger.of(context).isStarted,
      builder: (context,isStarted,child){
        if(isStarted){
          _controller.addStatusListener((status){
            if(status == AnimationStatus.completed){
              //Show the empty sized box when complete
              RideAttendeeScanStartTrigger.of(context).isStarted.value = false;
            }
          });
          _controller.forward();
          return LayoutBuilder(
            builder: (context,constraints){
              final width = constraints.biggest.width;
              final animation = Tween(begin: width,end: 0).animate(_controller);
              return AnimatedBuilder(
                animation: animation,
                builder: (context,child){
                  return CustomPaint(
                    size: Size(width,10),
                    foregroundPainter: _ProgressBarPainter(0, animation.value),
                  );
                },
              );
            },
          );
        }
        return SizedBox(height: 10,width: 10);
      },
    );
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class _ProgressBarPainter extends CustomPainter {
  _ProgressBarPainter(this.begin,this.end);

  final double begin;
  final double end;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawLine(
        Offset(begin,0),
        Offset(end,0),
        Paint()..color = ApplicationTheme.scanProgressBarStrokeColor
        ..strokeWidth = 5
        ..strokeCap = StrokeCap.round
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => this != oldDelegate;
  
}
