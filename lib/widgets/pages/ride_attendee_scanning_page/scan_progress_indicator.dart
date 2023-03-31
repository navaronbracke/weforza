import 'package:flutter/material.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';
import 'package:weforza/widgets/theme.dart';

/// This widget represents a progress indicator for a device scan.
class ScanProgressIndicator extends StatelessWidget {
  /// The default constructor.
  const ScanProgressIndicator({
    super.key,
    required this.animationController,
    required this.isScanning,
  });

  /// The controller that drives the progress bar animation.
  final AnimationController animationController;

  /// The stream that indicates if there is a running scan.
  final Stream<bool> isScanning;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: isScanning,
      builder: (context, snapshot) {
        final value = snapshot.data;

        if (value == null || !value) {
          // If there is no running scan yet,
          // reserve the height of the progress indicator as blank space.
          return const SizedBox(height: 4);
        }

        return PreferredSize(
          preferredSize: const Size(double.infinity, 1.0),
          child: Material(
            child: AnimatedBuilder(
              animation: animationController,
              builder: (context, child) {
                final progress = animationController.value;

                return PlatformAwareWidget(
                  android: () {
                    final theme = AppTheme.scanProgressIndicator.android;

                    return LinearProgressIndicator(
                      backgroundColor: theme.backgroundColor,
                      value: progress,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        theme.progressColor,
                      ),
                    );
                  },
                  ios: () {
                    final theme = AppTheme.scanProgressIndicator.ios;

                    return LinearProgressIndicator(
                      backgroundColor: theme.backgroundColor,
                      value: progress,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        theme.progressColor,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}
