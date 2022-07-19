import 'package:flutter/material.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/model/device_type.dart';
import 'package:weforza/theme/app_theme.dart';

/// This widget represents a carousel for selecting a device type.
class DeviceTypeCarousel extends StatelessWidget {
  const DeviceTypeCarousel({
    Key? key,
    required this.controller,
    required this.onPageChanged,
    required this.currentPageStream,
  }) : super(key: key);

  /// The controller that manages the currently selected page.
  final PageController controller;

  /// The Stream that provides the index of the current page.
  /// The [PageController.page] attribute is a double,
  /// thus the controller cannot provide the page index directly.
  final Stream<int> currentPageStream;

  /// The function that handles page changes.
  final void Function(int page) onPageChanged;

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
          shape: BoxShape.circle,
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
            onPageChanged: onPageChanged,
            controller: controller,
          ),
        ),
        Flexible(
          flex: 2,
          child: Center(
            child: StreamBuilder<int>(
              stream: currentPageStream,
              builder: (context, snapshot) {
                final children = <Widget>[];

                for (int i = 0; i < DeviceType.values.length; i++) {
                  children.add(_buildPageDot(i == snapshot.data));
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
