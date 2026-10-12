import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show ValueListenable;
import 'package:flutter/material.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

/// This widget represents a progress indicator for a device scan.
class ScanProgressIndicator extends StatelessWidget {
  /// The default constructor.
  const ScanProgressIndicator({required this.animationController, required this.isScanningListenable, super.key});

  /// The controller that drives the progress bar animation.
  final AnimationController animationController;

  /// The [ValueListenable] that provides updates to the scanning state.
  final ValueListenable<bool> isScanningListenable;

  @override
  Widget build(BuildContext context) {
    final progressIndicator = PreferredSize(
      preferredSize: const Size(double.infinity, 1.0),
      child: Material(
        child: AnimatedBuilder(
          animation: animationController,
          builder: (context, _) {
            final progress = animationController.value;

            return PlatformAwareWidget(
              android: (_) {
                return _BrightnessAwareProgressIndicator(
                  progress: progress,
                  color: Colors.green,
                  backgroundColor: Colors.green.withValues(alpha: 0.4),
                );
              },
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

    return ValueListenableBuilder<bool>(
      valueListenable: isScanningListenable,
      builder: (context, isScanning, _) => isScanning ? progressIndicator : const SizedBox.shrink(),
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
    return LinearProgressIndicator(
      backgroundColor: switch (MediaQuery.platformBrightnessOf(context)) {
        Brightness.dark => darkBackgroundColor ?? backgroundColor,
        Brightness.light => backgroundColor,
      },
      value: progress,
      valueColor: AlwaysStoppedAnimation<Color>(color),
    );
  }
}
