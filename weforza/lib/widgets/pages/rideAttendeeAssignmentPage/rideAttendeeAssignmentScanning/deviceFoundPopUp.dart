
import 'package:flutter/widgets.dart';
import 'package:weforza/generated/l10n.dart';

class DeviceFoundPopup extends StatefulWidget {
  DeviceFoundPopup({@required String deviceName}):
        assert(deviceName != null && deviceName.isNotEmpty),
        super(key: ValueKey<String>(deviceName));

  @override
  _DeviceFoundPopupState createState() => _DeviceFoundPopupState();
}

class _DeviceFoundPopupState extends State<DeviceFoundPopup> with TickerProviderStateMixin {

  AnimationController _controller;
  Animation<double> fadeInAndOut;
  Animation<EdgeInsets> position;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: Duration(milliseconds: 1500),vsync: this);
    _initAnimations();
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    final text = S.of(context).DeviceFound((widget.key as ValueKey<String>).value);
    return Center(
      child: AnimatedBuilder(
        animation: _controller,
        child: Text(text),
        builder: (context,child){
          return Container(
            padding: position.value,
            child: Opacity(
              opacity: fadeInAndOut.value,
              child: child,
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _initAnimations(){
    position = TweenSequence<EdgeInsets>(
        <TweenSequenceItem<EdgeInsets>>[
          TweenSequenceItem<EdgeInsets>(
              tween: EdgeInsetsTween(begin: EdgeInsets.zero,end: EdgeInsets.only(bottom: 50))
                  .chain(CurveTween(curve: Curves.easeOutCirc)),
              weight: .3
          ),
          TweenSequenceItem<EdgeInsets>(
              tween: ConstantTween<EdgeInsets>(EdgeInsets.only(bottom: 50)),
              weight: .4
          ),
          TweenSequenceItem<EdgeInsets>(
              tween: EdgeInsetsTween(begin: EdgeInsets.only(bottom: 50),end: EdgeInsets.zero)
                  .chain(CurveTween(curve: Curves.ease)),
              weight: .3
          ),
        ]).animate(_controller);

    fadeInAndOut = TweenSequence<double>(
        <TweenSequenceItem<double>>[
          //Fade In
          TweenSequenceItem<double>(
              tween: Tween<double>(begin: 0,end: 1).chain(CurveTween(curve: Curves.easeOutCirc)),
              weight: .3
          ),
          //Wait
          TweenSequenceItem<double>(
              tween: ConstantTween(1),
              weight: .4
          ),
          //Fade Out
          TweenSequenceItem<double>(
              tween: Tween<double>(begin: 1,end: 0)
                  .chain(CurveTween(curve: Curves.ease)),
              weight: .3
          ),
        ]
    ).animate(_controller);
  }
}
