import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weforza/model/device.dart';
import 'package:weforza/widgets/common/device_icon.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

class MemberDevicesListDisabledItem extends StatelessWidget {
  const MemberDevicesListDisabledItem({
    Key? key,
    required this.device,
  }) : super(key: key);

  final Device device;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: DeviceIcon(type: device.type),
          ),
          Expanded(child: Text(device.name, overflow: TextOverflow.ellipsis)),
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
  Widget _buildButtonWhitespace() {
    return PlatformAwareWidget(
      android: () => SizedBox.fromSize(size: const Size.square(40)),
      ios: () => SizedBox.fromSize(size: const Size.square(24)),
    );
  }
}
