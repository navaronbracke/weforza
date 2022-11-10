import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/model/device_type.dart';
import 'package:weforza/widgets/common/device_icon.dart';

/// This widget represents a carousel for selecting a device type.
class DeviceTypeCarousel extends StatelessWidget {
  const DeviceTypeCarousel({super.key, required this.controller});

  /// The controller that manages the currently selected page.
  final PageController controller;

  Widget _buildIcon(DeviceType deviceType, S translator) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Center(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return DeviceIcon(
                  size: constraints.biggest.shortestSide * .9,
                  type: deviceType,
                );
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Center(
            child: Text(
              deviceType.getLabel(translator),
              style: const TextStyle(fontSize: 14.0),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final translator = S.of(context);

    return Column(
      children: <Widget>[
        Flexible(
          flex: 9,
          child: PageView.builder(
            itemCount: DeviceType.values.length,
            itemBuilder: (_, index) {
              return _buildIcon(DeviceType.values[index], translator);
            },
            controller: controller,
          ),
        ),
        Flexible(
          flex: 2,
          child: Center(
            child: AnimatedBuilder(
              animation: controller,
              builder: (context, child) {
                final page = controller.page?.round() ?? controller.initialPage;

                final children = <Widget>[];

                for (int i = 0; i < DeviceType.values.length; i++) {
                  children.add(_DeviceTypeCarouselDot(selected: i == page));
                }

                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: children,
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _DeviceTypeCarouselDot extends StatelessWidget {
  const _DeviceTypeCarouselDot({required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    Color color;

    final theme = Theme.of(context);

    switch (theme.platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        color = selected
            ? theme.primaryColor
            : theme.disabledColor.withOpacity(0.2);
        break;
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        final cupertinoTheme = CupertinoTheme.of(context);
        color = selected
            ? cupertinoTheme.primaryColor
            : CupertinoColors.systemGrey4;
        break;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(6)),
          color: color,
        ),
      ),
    );
  }
}
