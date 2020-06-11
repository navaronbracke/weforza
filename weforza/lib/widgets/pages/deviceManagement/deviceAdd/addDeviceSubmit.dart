import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/widgets/platform/platformAwareLoadingIndicator.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

class AddDeviceSubmit extends StatelessWidget {
  AddDeviceSubmit({@required this.stream,@required this.onPressed}):
        assert(stream != null && onPressed != null);

  final Stream<bool> stream;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      initialData: false,
      builder: (context,snapshot){
        return (snapshot.data) ? PlatformAwareLoadingIndicator() : PlatformAwareWidget(
          android: () => FlatButton(
            child: Text(S.of(context).AddDeviceSubmit),
            onPressed: onPressed,
          ),
          ios: () => CupertinoButton(
            child: Text(S.of(context).AddDeviceSubmit),
            onPressed: onPressed,
          ),
        );
      },
    );
  }
}