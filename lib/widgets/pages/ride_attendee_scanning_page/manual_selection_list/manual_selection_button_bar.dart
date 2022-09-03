import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/model/ride_attendee_scanning/ride_attendee_scanning_delegate.dart';
import 'package:weforza/theme/app_theme.dart';
import 'package:weforza/widgets/platform/cupertino_bottom_bar.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

/// This widget represents the button bar
/// at the bottom of the manual selection list.
class ManualSelectionButtonBar extends StatelessWidget {
  const ManualSelectionButtonBar({
    super.key,
    required this.delegate,
    required this.saveButton,
    required this.showScannedResultsToggle,
  });

  final RideAttendeeScanningDelegate delegate;

  final Widget saveButton;

  final Widget showScannedResultsToggle;

  Widget _buildAndroidLayout() {
    return BottomAppBar(
      color: ApplicationTheme.primaryColor,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 36, child: Center(child: saveButton)),
            Row(
              children: [
                const _RidersIcon(),
                _AttendeeCounter(
                  countStream: delegate.attendeeCountStream,
                  initialCount: delegate.attendeeCount,
                  textStyle: const TextStyle(color: Colors.white),
                ),
                const Expanded(child: _ScannedRidersLabel()),
                showScannedResultsToggle,
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIosLayout() {
    return CupertinoBottomBar(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: SizedBox(height: 44, child: Center(child: saveButton)),
            ),
            Row(
              children: [
                const _RidersIcon(),
                _AttendeeCounter(
                  countStream: delegate.attendeeCountStream,
                  initialCount: delegate.attendeeCount,
                  textStyle: const TextStyle(
                    color: CupertinoColors.label,
                    fontSize: 15,
                  ),
                ),
                const Expanded(child: _ScannedRidersLabel()),
                showScannedResultsToggle,
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlatformAwareWidget(
      android: _buildAndroidLayout,
      ios: _buildIosLayout,
    );
  }
}

class _AttendeeCounter extends StatelessWidget {
  const _AttendeeCounter({
    required this.countStream,
    required this.initialCount,
    required this.textStyle,
  });

  /// The stream of count updates.
  final Stream<int> countStream;

  /// The initially displayed count.
  final int? initialCount;

  /// The style for the label.
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      initialData: initialCount,
      stream: countStream,
      builder: (context, snapshot) {
        final count = snapshot.data;

        if (count == null) {
          return Text('-', style: textStyle);
        }

        if (count > 999) {
          return Text('999+', style: textStyle);
        }

        return Text('$count', style: textStyle);
      },
    );
  }
}

class _RidersIcon extends StatelessWidget {
  const _RidersIcon();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: PlatformAwareWidget(
        android: () => const Icon(Icons.people, color: Colors.white),
        ios: () => const Icon(
          CupertinoIcons.person_2_fill,
          color: CupertinoColors.label,
        ),
      ),
    );
  }
}

class _ScannedRidersLabel extends StatelessWidget {
  const _ScannedRidersLabel();

  @override
  Widget build(BuildContext context) {
    final label = S.of(context).ScannedRiders;
    const maxLines = 2;
    const overflow = TextOverflow.ellipsis;
    const softWrap = true;
    const textAlign = TextAlign.right;

    return PlatformAwareWidget(
      android: () => Text(
        label,
        maxLines: maxLines,
        overflow: overflow,
        softWrap: softWrap,
        style: const TextStyle(color: Colors.white),
        textAlign: textAlign,
      ),
      ios: () => Text(
        label,
        maxLines: maxLines,
        overflow: overflow,
        softWrap: softWrap,
        style: const TextStyle(color: CupertinoColors.label, fontSize: 15),
        textAlign: textAlign,
      ),
    );
  }
}
