import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/widgets/platform/platform_aware_loading_indicator.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

class AddDeviceSubmit extends StatelessWidget {
  const AddDeviceSubmit({
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
    final translator = S.of(context);

    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Center(
            child: StreamBuilder<String>(
              initialData: '',
              stream: submitErrorStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text(translator.GenericError);
                }

                return Text(snapshot.data ?? '');
              },
            ),
          ),
        ),
        Center(
          child: StreamBuilder<bool>(
            initialData: false,
            stream: isSubmittingStream,
            builder: (context, snapshot) {
              final value = snapshot.data ?? false;

              if (value) {
                return const PlatformAwareLoadingIndicator();
              }

              return PlatformAwareWidget(
                android: () => ElevatedButton(
                  child: Text(translator.AddDevice),
                  onPressed: onSubmit,
                ),
                ios: () => CupertinoButton.filled(
                  child: Text(
                    translator.AddDevice,
                    style: const TextStyle(color: Colors.white),
                  ),
                  onPressed: onSubmit,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
