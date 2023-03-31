
import 'package:flutter/material.dart';

// This widget provides a generic layout for a
// left aligned, selectable, device name and an icon on the right.
class ScanResultListItemWithDeviceNameAndIconSlot extends StatelessWidget {
  ScanResultListItemWithDeviceNameAndIconSlot({
    @required this.deviceName,
    @required this.iconBuilder
  }): assert(iconBuilder != null && deviceName != null && deviceName.isNotEmpty);

  final String deviceName;
  final Widget Function() iconBuilder;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Row(
        children: [
          Expanded(
            child: SelectableText(
                deviceName, scrollPhysics: ClampingScrollPhysics()
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5),
            child: SizedBox(
              width: 30, height: 30, child: Center(child: iconBuilder()),
            ),
          ),
        ],
      ),
    );
  }
}