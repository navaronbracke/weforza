import 'package:flutter/material.dart';
import 'package:weforza/model/device.dart';
import 'package:weforza/theme/app_theme.dart';

class DeviceIcon extends StatelessWidget {
  const DeviceIcon({Key? key, required this.type}) : super(key: key);

  final DeviceType type;

  @override
  Widget build(BuildContext context) {
    return Icon(type.icon, color: ApplicationTheme.deviceIconColor);
  }
}
