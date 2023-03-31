import 'package:flutter/material.dart';
import 'package:weforza/model/device_type.dart';
import 'package:weforza/theme/app_theme.dart';

class DeviceIcon extends StatelessWidget {
  const DeviceIcon({super.key, required this.type});

  final DeviceType type;

  @override
  Widget build(BuildContext context) {
    return Icon(type.icon, color: ApplicationTheme.deviceIconColor);
  }
}
