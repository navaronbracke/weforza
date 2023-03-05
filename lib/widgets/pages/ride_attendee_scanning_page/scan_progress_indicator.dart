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

  Widget _buildProgressIndicator(double progress, Color color) {
    return LinearProgressIndicator(
      backgroundColor: color.withOpacity(0.4),
      value: progress,
      valueColor: AlwaysStoppedAnimation<Color>(color),
    );
  }

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
                  android: (_) => _buildProgressIndicator(
                    progress,
                    Colors.green,
                  ),
                  ios: (_) => _buildProgressIndicator(
                    progress,
                    CupertinoColors.systemGreen,
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
