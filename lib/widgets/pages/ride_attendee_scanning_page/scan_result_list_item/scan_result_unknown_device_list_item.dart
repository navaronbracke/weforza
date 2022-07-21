import 'package:flutter/material.dart';

class ScanResultUnknownDeviceListItem extends StatelessWidget {
  const ScanResultUnknownDeviceListItem({
    Key? key,
    required this.deviceName,
  }) : super(key: key);

  final String deviceName;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.only(right: 4),
            child: Icon(
              Icons.device_unknown,
              color: Colors.black,
            ),
          ),
          SelectableText(
            deviceName,
            scrollPhysics: const ClampingScrollPhysics(),
          ),
        ],
      ),
    );
  }
}
