import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:weforza/theme/appTheme.dart';
import 'package:weforza/widgets/platform/cupertinoIconButton.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

abstract class SettingsSubmitHandler {
  Stream<bool> get submitStream;

  VoidCallback onSubmit;
}

class SettingsSubmit extends StatelessWidget {
  SettingsSubmit({@required this.handler}): assert(handler != null);

  final SettingsSubmitHandler handler;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      initialData: false,
      stream: handler.submitStream,
      builder: (context,snapshot){
        if(snapshot.hasError){
          return SizedBox(width: 0,height: 0);
        }else{
          return PlatformAwareWidget(
            android: () => IconButton(
              icon: Icon(Icons.done,color: Colors.white),
              onPressed: snapshot.data ? (){} : handler.onSubmit,
            ),
            ios: () => CupertinoIconButton(
              onPressedColor: ApplicationTheme.primaryColor,
              idleColor: ApplicationTheme.accentColor,
              icon: Icons.done,
              onPressed: snapshot.data ? (){} : handler.onSubmit,
            ),
          );
        }
      },
    );
  }
}
