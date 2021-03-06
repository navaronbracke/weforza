
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weforza/model/device.dart';
import 'package:weforza/widgets/common/deviceWidgetUtils.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

class MemberDevicesListDisabledItem extends StatelessWidget {
  MemberDevicesListDisabledItem({
    required this.device,
  });

  final Device device;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: getDeviceIcon(device.type),
          ),
          Expanded(
              child: Text(device.name, overflow: TextOverflow.ellipsis)
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5),
            child: _buildButtonWhitespace(),
          ),
        ],
      ),
    );
  }

  //During deletion we shouldn't show the edit button.
  //However simply 'removing the button' might look ugly.
  //Hence we show whitespace instead, that is the size of the button.
  Widget _buildButtonWhitespace() => PlatformAwareWidget(
    android: () => SizedBox.fromSize(size: Size.square(40)),
    ios: () => SizedBox.fromSize(size: Size.square(24)),
  );
}
