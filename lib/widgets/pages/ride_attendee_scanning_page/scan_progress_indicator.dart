import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

/// This widget represents a progress indicator for a device scan.
class ScanProgressIndicator extends StatelessWidget {
  /// The default constructor.
  const new({required this.isScanning, required this.isScanningStream, required this.scanTimerAnimation, super.key});

  /// The animation that drives the progress bar.
  final Animation<double> scanTimerAnimation;

  /// Whether the device scan is currently in progress.
  final bool isScanning;

  /// The [Stream] that provides updates to the scanning state.
  final Stream<bool> isScanningStream;

  @override
  Widget build(BuildContext context) {
    final progressIndicator = PreferredSize(
      preferredSize: const Size(double.infinity, 1.0),
      child: Material(
        child: AnimatedBuilder(
          animation: scanTimerAnimation,
          builder: (context, _) => PlatformAwareWidget(
            android: (_) => _BrightnessAwareProgressIndicator(
              progress: scanTimerAnimation.value,
              color: Colors.green,
              backgroundColor: Colors.green.withValues(alpha: 0.4),
            ),
            ios: (context) => _BrightnessAwareProgressIndicator(
              progress: scanTimerAnimation.value,
              color: CupertinoTheme.of(context).primaryColor,
              backgroundColor: CupertinoColors.white,
              darkBackgroundColor: CupertinoColors.inactiveGray,
            ),
          ),
        ),
      ),
    );

    return StreamBuilder<bool>(
      initialData: isScanning,
      stream: isScanningStream,
      builder: (context, snapshot) => snapshot.data ?? false ? progressIndicator : const SizedBox.shrink(),
    );
  }
}

class _BrightnessAwareProgressIndicator extends StatelessWidget {
  const new({required this.backgroundColor, required this.color, required this.progress, this.darkBackgroundColor});

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
        .dark => darkBackgroundColor ?? backgroundColor,
        .light => backgroundColor,
      },
      value: progress,
      valueColor: AlwaysStoppedAnimation<Color>(color),
    );
  }
}
