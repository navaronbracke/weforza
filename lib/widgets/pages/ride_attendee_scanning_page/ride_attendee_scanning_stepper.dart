import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/model/ride_attendee_scanning/ride_attendee_scanning_state.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

/// This widget represents the stepper at the top of the scanning page.
/// It displays the two labels of the scanning process,
/// `Scan` and `Manual`, separated by an arrow.
class RideAttendeeScanningStepper extends StatelessWidget {
  /// The default constructor.
  const RideAttendeeScanningStepper({
    required this.initialData,
    required this.scrollController,
    required this.stream,
    super.key,
  });

  /// The initial value for the stepper.
  final RideAttendeeScanningState initialData;

  /// The controller for the horizontal scrollview that wraps the stepper.
  final ScrollController scrollController;

  /// The stream that indicates the current step in the scanning process.
  final Stream<RideAttendeeScanningState> stream;

  @override
  Widget build(BuildContext context) {
    final translator = S.of(context);
    final scanLabel = translator.scan.toUpperCase();
    final manualLabel = translator.manual.toUpperCase();

    final separator = PlatformAwareWidget(
      android: (_) => const Icon(Icons.chevron_right_rounded, size: 48),
      ios: (_) => const Icon(
        CupertinoIcons.chevron_forward,
        color: CupertinoColors.inactiveGray,
        size: 32,
      ),
    );

    return Scrollbar(
      thumbVisibility: false,
      trackVisibility: false,
      controller: scrollController,
      child: SingleChildScrollView(
        controller: scrollController,
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        child: StreamBuilder<RideAttendeeScanningState>(
          initialData: initialData,
          stream: stream,
          builder: (context, snapshot) {
            // Every step before the manual selection should highlight the `Scan` label.
            final isScanStep =
                snapshot.data != RideAttendeeScanningState.manualSelection;

            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _RideAttendeeScanningStepperLabel(
                  isSelected: isScanStep,
                  text: scanLabel,
                ),
                separator,
                _RideAttendeeScanningStepperLabel(
                  isSelected: !isScanStep,
                  text: manualLabel,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _RideAttendeeScanningStepperLabel extends StatelessWidget {
  const _RideAttendeeScanningStepperLabel({
    required this.isSelected,
    required this.text,
  });

  /// Whether this label is selected.
  final bool isSelected;

  /// The text for the label.
  final String text;

  @override
  Widget build(BuildContext context) {
    Color selectedColor;
    Color unselectedColor;

    switch (Theme.of(context).platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        selectedColor = Colors.lime.shade300;
        unselectedColor = Colors.white;
        break;
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        selectedColor = CupertinoColors.activeGreen;
        unselectedColor = CupertinoColors.inactiveGray;
        break;
    }

    return Text(
      text,
      style: TextStyle(color: isSelected ? selectedColor : unselectedColor),
    );
  }
}
