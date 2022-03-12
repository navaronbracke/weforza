import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/widgets/platform/platform_aware_loading_indicator.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

class EditDeviceSubmit extends StatelessWidget {
  const EditDeviceSubmit({
    Key? key,
    required this.isSubmittingStream,
    required this.submitErrorStream,
    required this.onSubmit,
  }) : super(key: key);

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
              initialData: '',
              stream: submitErrorStream,
              builder: (context, snapshot) {
                return snapshot.hasError
                    ? Text(S.of(context).GenericError)
                    : Text(snapshot.data!);
              },
            ),
          ),
        ),
        Center(
            child: StreamBuilder<bool>(
          initialData: false,
          stream: isSubmittingStream,
          builder: (context, snapshot) => snapshot.data!
              ? const PlatformAwareLoadingIndicator()
              : PlatformAwareWidget(
                  android: () => ElevatedButton(
                    child: Text(S.of(context).SaveChanges),
                    onPressed: onSubmit,
                  ),
                  ios: () => CupertinoButton.filled(
                    child: Text(
                      S.of(context).SaveChanges,
                      style: const TextStyle(color: Colors.white),
                    ),
                    onPressed: onSubmit,
                  ),
                ),
        )),
      ],
    );
  }
}
