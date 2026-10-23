import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/model/ride_attendee_scanning/ride_attendee_scanning_delegate.dart';
import 'package:weforza/model/ride_attendee_scanning/scanned_ride_attendee.dart';
import 'package:weforza/widgets/platform/cupertino_bottom_bar.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

/// This widget represents the bottom bar for the manual selection page.
///
/// It provides a counter for the ride attendees,
/// a button to save the current scan results
/// and a toggle for the visibility of the scanned results.
class ManualSelectionBottomBar extends StatelessWidget {
  const new({required this.delegate, required this.saveButton, required this.showScannedResultsToggle, super.key});

  /// The delegate that mannages the scan results.
  final RideAttendeeScanningDelegate delegate;

  /// The button that saves the scan results when tapped.
  final Widget saveButton;

  /// The toggle for the visibility of the scanned results.
  final Widget showScannedResultsToggle;

  Widget _buildAndroidLayout(BuildContext context, BoxConstraints constraints) {
    final attendeeCounter = _buildAttendeeCounter(Icon(Icons.people, color: ColorScheme.of(context).primary));

    final scannedResultsToggle = Row(
      mainAxisSize: .min,
      children: [
        Text(S.of(context).scannedRiders, maxLines: 2, overflow: .ellipsis, softWrap: true, textAlign: .right),
        showScannedResultsToggle,
      ],
    );

    Widget child = BottomAppBar(
      child: Row(
        children: [
          attendeeCounter,
          Expanded(child: Center(child: saveButton)),
          scannedResultsToggle,
        ],
      ),
    );

    if (constraints.biggest.width < 400) {
      child = BottomAppBar(
        height: 104,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Column(
          mainAxisSize: .min,
          children: [
            saveButton,
            Row(mainAxisAlignment: .spaceBetween, children: [attendeeCounter, scannedResultsToggle]),
          ],
        ),
      );
    }

    return child;
  }

  Widget _buildAttendeeCounter(Widget icon, {TextStyle? textStyle}) {
    return Row(
      mainAxisSize: .min,
      children: [
        Padding(padding: const .only(right: 4), child: icon),
        ValueListenableBuilder<Set<ScannedRideAttendee>>(
          valueListenable: delegate.attendeesListenable,
          builder: (context, value, _) => switch (value.length) {
            > 999 => Text('999+', style: textStyle),
            _ => Text('${value.length}', style: textStyle),
          },
        ),
      ],
    );
  }

  Widget _buildIosLayout(BuildContext context, BoxConstraints constraints) {
    final labelTextStyle = TextStyle(
      color: const CupertinoDynamicColor.withBrightness(
        color: CupertinoColors.label,
        darkColor: CupertinoColors.white,
      ).resolveFrom(context),
      fontSize: 15,
    );

    final attendeeCounter = _buildAttendeeCounter(
      const Icon(CupertinoIcons.person_2_fill, color: CupertinoColors.activeBlue),
      textStyle: labelTextStyle,
    );

    final scannedResultsToggle = Row(
      mainAxisSize: .min,
      children: [
        Text(
          S.of(context).scannedRiders,
          maxLines: 2,
          overflow: .ellipsis,
          softWrap: true,
          style: labelTextStyle,
          textAlign: .right,
        ),
        showScannedResultsToggle,
      ],
    );

    Widget child = Row(
      children: [
        attendeeCounter,
        Expanded(child: Center(child: saveButton)),
        scannedResultsToggle,
      ],
    );

    if (constraints.biggest.width < 400) {
      child = Column(
        mainAxisSize: .min,
        children: [
          saveButton,
          Row(mainAxisAlignment: .spaceBetween, children: [attendeeCounter, scannedResultsToggle]),
        ],
      );
    }

    return CupertinoBottomBar(
      child: Padding(padding: const .symmetric(horizontal: 8, vertical: 4), child: child),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        return PlatformAwareWidget(
          android: (ctx) => _buildAndroidLayout(ctx, constraints),
          ios: (ctx) => _buildIosLayout(ctx, constraints),
        );
      },
    );
  }
}
