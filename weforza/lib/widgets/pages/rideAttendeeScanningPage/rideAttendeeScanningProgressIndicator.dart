import 'package:flutter/material.dart';
import 'package:weforza/theme/appTheme.dart';

///This Widget will show a progress indicator
///that shows how much time is left until the scan stops.
class RideAttendeeScanningProgressIndicator extends StatefulWidget {
  RideAttendeeScanningProgressIndicator({
    @required this.getDuration,
    @required this.valueNotifier
  }): assert(valueNotifier != null && getDuration != null);

  @override
  _RideAttendeeScanningProgressIndicatorState createState() => _RideAttendeeScanningProgressIndicatorState();

  ///This lambda will allow to get the duration on demand.
  ///
  final int Function() getDuration;
  ///This notifier notifies when the scanning started.
  final ValueNotifier<bool> valueNotifier;
}

class _RideAttendeeScanningProgressIndicatorState extends State<RideAttendeeScanningProgressIndicator> with SingleTickerProviderStateMixin {
  AnimationController _controller;

  final Color progressbarColor = ApplicationTheme.rideAttendeeScanProgressbarColor;
  final Color progressbarBackgroundColor = ApplicationTheme.rideAttendeeScanProgressbarBackgroundColor;

  Animation<double> _animation;
  int _duration;

  @override
  void initState() {
    _duration = widget.getDuration();//Load the duration (from settings)
    _controller = AnimationController(vsync: this, duration: Duration(seconds: _duration));
    _animation = Tween(begin: 1.0,end: 0.0).animate(_controller);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: widget.valueNotifier,
      builder: (context, value, child){
        if(value){
          //Make sure to start the animation
          _controller.forward();
          return AnimatedBuilder(
            animation: _animation,
            builder: (context, child){
              return PreferredSize(
                preferredSize: Size(double.infinity,1.0),
                child: Material(
                  child: LinearProgressIndicator(
                    value: _animation.value,
                    valueColor: AlwaysStoppedAnimation<Color>(progressbarColor),
                    backgroundColor: progressbarBackgroundColor,
                  ),
                ),
              );
            },
          );
        }else{
          //Show nothing when not scanning.
          return SizedBox.shrink();
        }
      },
    );
  }
}