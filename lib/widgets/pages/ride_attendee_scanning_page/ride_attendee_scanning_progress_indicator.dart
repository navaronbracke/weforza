import 'package:flutter/material.dart';
import 'package:weforza/theme/app_theme.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

///This Widget will show a progress indicator
///that shows how much time is left until the scan stops.
class RideAttendeeScanningProgressIndicator extends StatelessWidget {
  const RideAttendeeScanningProgressIndicator({
    Key? key,
    required this.getDuration,
    required this.isScanning,
  }) : super(key: key);

  ///This lambda will allow to get the duration on demand.
  ///The output of this function is not available immediately, hence the function.
  final int Function() getDuration;

  ///This notifier notifies when the scanning started.
  final Stream<bool> isScanning;

  final double _kProgressIndicatorHeight = 4;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: isScanning,
      builder: (context, snapshot) {
        final value = snapshot.data;

        if (value == null || !value) {
          //Show nothing when not scanning.
          //Fill the space with a 4dp blank sized box. 4dp is the default height of the progress indicator.
          return SizedBox(height: _kProgressIndicatorHeight);
        }

        // The duration is accessible at this point.
        return _RideAttendeeScanningProgressIndicatorAnimatable(
            duration: getDuration());
      },
    );
  }
}

/// The internal widget that wraps an AnimatedBuilder for the progress bar.
/// This allows for the animation properties to be marked with late instead of being nullable.
class _RideAttendeeScanningProgressIndicatorAnimatable extends StatefulWidget {
  const _RideAttendeeScanningProgressIndicatorAnimatable({
    required this.duration,
  }) : assert(duration > 0);

  final int duration;

  @override
  _RideAttendeeScanningProgressIndicatorAnimatableState createState() =>
      _RideAttendeeScanningProgressIndicatorAnimatableState();
}

class _RideAttendeeScanningProgressIndicatorAnimatableState
    extends State<_RideAttendeeScanningProgressIndicatorAnimatable>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: Duration(seconds: widget.duration));
    _animation = Tween(begin: 1.0, end: 0.0).animate(_controller);
    //Make sure to start the animation
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return PreferredSize(
          preferredSize: const Size(double.infinity, 1.0),
          child: Material(child: _buildIndicator(_animation.value)),
        );
      },
    );
  }

  Widget _buildIndicator(double progress) {
    return PlatformAwareWidget(
      android: () => LinearProgressIndicator(
        value: progress,
        valueColor: const AlwaysStoppedAnimation<Color>(
            ApplicationTheme.androidRideAttendeeScanProgressbarColor),
        backgroundColor:
            ApplicationTheme.androidRideAttendeeScanProgressbarBackgroundColor,
      ),
      ios: () => LinearProgressIndicator(
        value: progress,
        valueColor: const AlwaysStoppedAnimation<Color>(
            ApplicationTheme.iosRideAttendeeScanProgressbarColor),
        backgroundColor:
            ApplicationTheme.iosRideAttendeeScanProgressbarBackgroundColor,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
