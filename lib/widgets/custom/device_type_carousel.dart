import 'package:flutter/material.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/model/device_type.dart';
import 'package:weforza/theme/app_theme.dart';

/// This widget represents a carousel for selecting a device type.
class DeviceTypeCarousel extends StatelessWidget {
  const DeviceTypeCarousel({
    Key? key,
    required this.controller,
  }) : super(key: key);

  /// The controller that manages the currently selected page.
  final PageController controller;

  Widget _buildIcon(DeviceType deviceType, S translator) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Center(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Icon(
                  deviceType.icon,
                  color: ApplicationTheme.deviceTypePickerCurrentDotColor,
                  size: constraints.biggest.shortestSide * .9,
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

  Widget _buildPageDot(bool isCurrentPage) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(6)),
          color: isCurrentPage
              ? ApplicationTheme.deviceTypePickerCurrentDotColor
              : ApplicationTheme.deviceTypePickerDotColor,
        ),
      ),
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
                  children.add(_buildPageDot(i == page));
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
