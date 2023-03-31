import 'package:flutter/material.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/model/device.dart';
import 'package:weforza/theme/app_theme.dart';

class DeviceTypeCarousel extends StatelessWidget {
  const DeviceTypeCarousel({
    Key? key,
    required this.controller,
    required this.onPageChanged,
    required this.currentPageStream,
  }) : super(key: key);

  final PageController controller;
  final void Function(int page) onPageChanged;
  final Stream<int> currentPageStream;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Flexible(
          flex: 9,
          child: PageView.builder(
            itemCount: DeviceType.values.length,
            itemBuilder: _buildIcon,
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

  Widget _buildPageDot(bool isCurrentPage) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isCurrentPage
                ? ApplicationTheme.deviceTypePickerCurrentDotColor
                : ApplicationTheme.deviceTypePickerDotColor),
      ),
    );
  }

  Widget _buildIcon(BuildContext context, int index) {
    final deviceType = DeviceType.values[index];

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
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Center(
            child: Text(
              deviceType.getLabel(S.of(context)),
              style: const TextStyle(fontSize: 14.0),
            ),
          ),
        ),
      ],
    );
  }
}
