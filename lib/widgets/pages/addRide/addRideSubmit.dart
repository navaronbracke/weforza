import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/model/addRidesOrError.dart';
import 'package:weforza/widgets/platform/platformAwareLoadingIndicator.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

class AddRideSubmit extends StatelessWidget {
  const AddRideSubmit({
    Key? key,
    required this.stream,
    required this.onPressed,
  }) : super(key: key);

  final Stream<AddRidesOrError> stream;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AddRidesOrError>(
      stream: stream,
      initialData: AddRidesOrError.idle(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          if (snapshot.error is AddRidesOrError &&
              (snapshot.error as AddRidesOrError).noSelection) {
            return Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(S.of(context).AddRideEmptySelection),
                ),
                _buildButton(context),
              ],
            );
          }

          return Text(S.of(context).GenericError);
        } else {
          if (snapshot.data!.saving) {
            return const PlatformAwareLoadingIndicator();
          } else {
            return Column(
              children: <Widget>[
                //Show empty text widget to prevent popping
                const Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Text(''),
                ),
                _buildButton(context),
              ],
            );
          }
        }
      },
    );
  }

  Widget _buildButton(BuildContext context) => PlatformAwareWidget(
        android: () => ElevatedButton(
          child: Text(S.of(context).AddRideSubmit),
          onPressed: onPressed,
        ),
        ios: () => CupertinoButton.filled(
          child: Text(
            S.of(context).AddRideSubmit,
            style: const TextStyle(color: Colors.white),
          ),
          onPressed: onPressed,
        ),
      );
}
