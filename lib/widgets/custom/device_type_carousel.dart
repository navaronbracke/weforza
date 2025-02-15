import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/model/device/device_type.dart';
import 'package:weforza/widgets/common/device_icon.dart';

/// This widget represents a carousel for selecting a device type.
class DeviceTypeCarousel extends StatelessWidget {
  const DeviceTypeCarousel({required this.controller, required this.height, super.key});

  /// The controller that manages the currently selected device type index.
  final PageController controller;

  /// The height for the entire carousel.
  final double height;

  Widget _buildIcon(DeviceType deviceType, S translator) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Center(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return DeviceIcon(size: constraints.biggest.shortestSide, type: deviceType);
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Center(child: Text(deviceType.getLabel(translator), style: const TextStyle(fontSize: 14.0))),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final translator = S.of(context);

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: height),
      child: Column(
        children: [
          Expanded(
            child: PageView.builder(
              itemCount: DeviceType.values.length,
              itemBuilder: (_, index) => _buildIcon(DeviceType.values[index], translator),
              controller: controller,
            ),
          ),
          AnimatedBuilder(
            animation: controller,
            builder: (context, child) {
              int? page;

              // When hot-reloading, the old page view might still be attached.
              // Accessing `controller.page` will throw in that case.
              if (controller.positions.length == 1) {
                page = controller.page?.round() ?? controller.initialPage;
              }

              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int i = 0; i < DeviceType.values.length; i++) _DeviceTypeCarouselDot(selected: i == page),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _DeviceTypeCarouselDot extends StatelessWidget {
  const _DeviceTypeCarouselDot({required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    Color color;

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        final theme = Theme.of(context);

        Color disabledColor;

        switch (theme.brightness) {
          case Brightness.dark:
            disabledColor = theme.disabledColor.withOpacity(0.3);
            break;
          case Brightness.light:
            disabledColor = theme.disabledColor.withOpacity(0.2);
            break;
        }

        color = selected ? ColorScheme.of(context).primary : disabledColor;
        break;
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        final cupertinoTheme = CupertinoTheme.of(context);
        color = selected ? cupertinoTheme.primaryColor : CupertinoColors.systemGrey4;
        break;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(6)), color: color),
      ),
    );
  }
}
