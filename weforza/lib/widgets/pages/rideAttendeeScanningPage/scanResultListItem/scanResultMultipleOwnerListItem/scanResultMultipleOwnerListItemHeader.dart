import 'package:flutter/material.dart';

class ScanResultMultipleOwnerListItemHeader extends StatelessWidget {
  ScanResultMultipleOwnerListItemHeader({
    @required this.onTap,
    @required this.ownerLabelTextStyle,
    @required this.deviceNameStyle,
    @required this.deviceOwnedByLabel,
    @required this.iconBuilder,
    @required this.deviceName
  }): assert(
    onTap != null && deviceName != null && deviceName.isNotEmpty &&
    iconBuilder != null && deviceOwnedByLabel != null &&
        deviceOwnedByLabel.isNotEmpty && ownerLabelTextStyle != null
  );

  /// The on tap function for tapping the header.
  final void Function() onTap;

  /// This function creates the menu icon.
  final Widget Function() iconBuilder;

  /// The device name that should be displayed.
  final String deviceName;

  /// The text that denotes who is selected as the device owner.
  final String deviceOwnedByLabel;

  /// The text style for the selectable device name.
  /// Is required as constructor argument but can be null.
  final TextStyle deviceNameStyle;

  /// The text style for the owner label.
  final TextStyle ownerLabelTextStyle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SelectableText(
                      deviceName,
                      style: deviceNameStyle,
                      scrollPhysics: ClampingScrollPhysics()
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      deviceOwnedByLabel,
                      style: ownerLabelTextStyle,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: SizedBox(
                width: 30,
                height: 30,
                child: Center(
                  child: iconBuilder(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
