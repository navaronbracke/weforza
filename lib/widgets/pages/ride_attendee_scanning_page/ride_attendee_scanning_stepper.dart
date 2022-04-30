import 'package:flutter/material.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/theme/app_theme.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

/// This Widget represents the stepper at the top of the scanning page.
/// It shows if the user is in the scanning step or the manual assignment step.
class RideAttendeeScanningStepper extends StatelessWidget {
  const RideAttendeeScanningStepper({
    Key? key,
    required this.stream,
  }) : super(key: key);

  final Stream<bool> stream;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      initialData: true,
      stream: stream,
      builder: (context, snapshot) => PlatformAwareWidget(
        android: () => _buildAndroidWidget(context, snapshot.data!),
        ios: () => _buildIosWidget(context, snapshot.data!),
      ),
    );
  }

  Widget _buildAndroidWidget(BuildContext context, bool isScanningStep) {
    final translator = S.of(context);

    return Row(
      children: <Widget>[
        Text(
          translator.Scan.toUpperCase(),
          style: TextStyle(
            color: isScanningStep
                ? ApplicationTheme.androidScanStepperCurrentColor
                : ApplicationTheme.androidScanStepperOtherColor,
          ),
        ),
        SizedBox(
          width: 50,
          child: Center(
            child: Icon(
              Icons.arrow_forward_ios,
              color: ApplicationTheme.androidScanStepperArrowColor,
            ),
          ),
        ),
        Text(
          translator.ByHand.toUpperCase(),
          style: TextStyle(
            color: isScanningStep
                ? ApplicationTheme.androidScanStepperOtherColor
                : ApplicationTheme.androidScanStepperCurrentColor,
          ),
        ),
      ],
    );
  }

  Widget _buildIosWidget(BuildContext context, bool isScanningStep) {
    final translator = S.of(context);

    return Row(
      children: <Widget>[
        Text(
          translator.Scan.toUpperCase(),
          style: TextStyle(
            color: isScanningStep
                ? ApplicationTheme.iosScanStepperCurrentColor
                : ApplicationTheme.iosScanStepperOtherColor,
          ),
        ),
        const SizedBox(
          width: 50,
          child: Center(
            child: Icon(
              Icons.arrow_forward_ios,
              color: ApplicationTheme.iosScanStepperArrowColor,
            ),
          ),
        ),
        Text(
          translator.ByHand.toUpperCase(),
          style: TextStyle(
            color: isScanningStep
                ? ApplicationTheme.iosScanStepperOtherColor
                : ApplicationTheme.iosScanStepperCurrentColor,
          ),
        ),
      ],
    );
  }
}
