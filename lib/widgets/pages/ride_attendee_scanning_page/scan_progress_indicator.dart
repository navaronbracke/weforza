import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

/// This widget represents a progress indicator for a device scan.
class ScanProgressIndicator extends StatelessWidget {
  /// The default constructor.
  const ScanProgressIndicator({
    required this.animationController,
    required this.isScanning,
    required this.isScanningStream,
    super.key,
  });

  /// The controller that drives the progress bar animation.
  final AnimationController animationController;

  /// Whether a device scan is currently in progress.
  final bool isScanning;

  /// The stream of changes to the scanning state.
  final Stream<bool> isScanningStream;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      initialData: isScanning,
      stream: isScanningStream,
      builder: (context, snapshot) {
        final value = snapshot.data;

        if (value == null || !value) {
          // If there is no running scan, do not reserve space for the progress bar.
          return const SizedBox.shrink();
        }

        return PreferredSize(
          preferredSize: const Size(double.infinity, 1.0),
          child: Material(
            child: AnimatedBuilder(
              animation: animationController,
              builder: (context, child) {
                final progress = animationController.value;

                return PlatformAwareWidget(
                  android: (_) => _BrightnessAwareProgressIndicator(
                    progress: progress,
                    color: Colors.green,
                    backgroundColor: Colors.green.withOpacity(0.4),
                  ),
                  ios: (context) {
                    final theme = CupertinoTheme.of(context);

                    return _BrightnessAwareProgressIndicator(
                      progress: progress,
                      color: theme.primaryColor,
                      backgroundColor: CupertinoColors.white,
                      darkBackgroundColor: CupertinoColors.inactiveGray,
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

class _BrightnessAwareProgressIndicator extends StatelessWidget {
  const _BrightnessAwareProgressIndicator({
    required this.backgroundColor,
    required this.color,
    required this.progress,
    this.darkBackgroundColor,
  });

  /// The background color when the brightness is [Brightness.light].
  final Color backgroundColor;

  /// The background color when the brightness is [Brightness.dark].
  /// If this is null, defaults to [backgroundColor].
  final Color? darkBackgroundColor;

  /// The color for the progress.
  final Color color;

  /// The progress value.
  final double progress;

  @override
  Widget build(BuildContext context) {
    Color effectiveBackgroundColor;

    switch (MediaQuery.platformBrightnessOf(context)) {
      case Brightness.dark:
        effectiveBackgroundColor = darkBackgroundColor ?? backgroundColor;
        break;
      case Brightness.light:
        effectiveBackgroundColor = backgroundColor;
        break;
    }

    return LinearProgressIndicator(
      backgroundColor: effectiveBackgroundColor,
      value: progress,
      valueColor: AlwaysStoppedAnimation<Color>(color),
    );
  }
}
