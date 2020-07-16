import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:weforza/theme/appTheme.dart';
import 'package:weforza/widgets/platform/cupertinoIconButton.dart';
import 'package:weforza/widgets/platform/platformAwareLoadingIndicator.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

class SettingsSubmit extends StatelessWidget {
  SettingsSubmit({
    @required this.onSubmit,
    @required this.submitStream,
  }): assert(onSubmit != null && submitStream != null);

  final Stream<bool> submitStream;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      initialData: false,
      stream: submitStream,
      builder: (context,snapshot){
        if(snapshot.hasError){
          return SizedBox(width: 0,height: 0);
        }else{
          return snapshot.data ? Center(
              child: PlatformAwareLoadingIndicator()
          ): PlatformAwareWidget(
            android: () => IconButton(
              icon: Icon(Icons.done,color: Colors.white),
              onPressed: onSubmit,
            ),
            ios: () => CupertinoIconButton(
              onPressedColor: ApplicationTheme.primaryColor,
              idleColor: ApplicationTheme.accentColor,
              icon: Icons.done,
              onPressed: onSubmit,
            ),
          );
        }
      },
    );
  }
}
