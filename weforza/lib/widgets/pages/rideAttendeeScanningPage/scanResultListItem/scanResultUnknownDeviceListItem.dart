import 'package:flutter/material.dart';

class ScanResultUnknownDeviceListItem extends StatelessWidget {
  ScanResultUnknownDeviceListItem({
    required this.deviceName
  });

  final String deviceName;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: Icon(Icons.device_unknown),
          ),
          SelectableText(deviceName, scrollPhysics: ClampingScrollPhysics()),
        ],
      ),
    );
  }
}
