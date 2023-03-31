import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/theme/appTheme.dart';
import 'package:weforza/widgets/platform/platformAwareLoadingIndicator.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

class AddDeviceSubmit extends StatelessWidget {
  AddDeviceSubmit({
    @required this.isSubmittingStream,
    @required this.submitErrorStream,
    @required this.onSubmit,
  }): assert(
    isSubmittingStream != null && submitErrorStream != null && onSubmit != null
  );

  final Stream<String> submitErrorStream;
  final Stream<bool> isSubmittingStream;
  final void Function() onSubmit;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Center(
            child: StreamBuilder<String>(
              initialData: "",
              stream: submitErrorStream,
              builder: (context, snapshot){
                return snapshot.hasError ?
                Text(S.of(context).AddDeviceGenericError):
                Text(snapshot.data);
              },
            ),
          ),
        ),
        Center(
          child: StreamBuilder<bool>(
            initialData: false,
            stream: isSubmittingStream,
            builder: (context,snapshot) => snapshot.data ? PlatformAwareLoadingIndicator() :
            PlatformAwareWidget(
                android: () => RaisedButton(
                  color: ApplicationTheme.primaryColor,
                  child: Text(
                    S.of(context).AddDeviceSubmit,
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: onSubmit,
                ),
                ios: () => CupertinoButton.filled(
                    child: Text(
                      S.of(context).AddDeviceSubmit,
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: onSubmit,
                ),
            ),
          )
        ),
      ],
    );
  }
}
