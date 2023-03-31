import 'package:flutter/material.dart';
import 'package:weforza/theme/appTheme.dart';

class ImportMembersComplete extends StatefulWidget {
  @override
  _ImportMembersCompleteState createState() => _ImportMembersCompleteState();
}

class _ImportMembersCompleteState extends State<ImportMembersComplete> with SingleTickerProviderStateMixin {
  AnimationController _controller;

  Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this,duration: Duration(milliseconds: 400));
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints)=> AnimatedBuilder(
          animation: _animation,
          builder: (context, child) => Icon(
                Icons.done,
                color: ApplicationTheme.importMembersDoneIconColor,
                size: _animation.value * constraints.biggest.shortestSide
            ),
        ),
    );
  }
}
