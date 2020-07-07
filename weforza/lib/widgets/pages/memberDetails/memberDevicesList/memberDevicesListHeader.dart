import 'package:flutter/material.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/theme/appTheme.dart';
import 'package:weforza/widgets/platform/cupertinoIconButton.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

class MemberDevicesListHeader extends StatelessWidget {
  MemberDevicesListHeader({ @required this.onPressed }):
        assert(onPressed != null);

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => PlatformAwareWidget(
    android: () => _buildAndroidWidget(context),
    ios: () => _buildIosWidget(context),
  );

  Widget _buildAndroidWidget(BuildContext context){
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 4),
              child: Text(
                S.of(context).DevicesListHeader,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.add,
              color: ApplicationTheme.memberDevicesListHeaderAddDeviceButtonColor,
              size: 26,
            ),
            onPressed: onPressed,
          )
        ],
      ),
    );
  }

  Widget _buildIosWidget(BuildContext context){
    return Row(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: 4),
            child: Text(
              S.of(context).DevicesListHeader,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20
              ),
            ),
          ),
        ),
        CupertinoIconButton(
          onPressedColor: ApplicationTheme.memberDevicesListHeaderAddDeviceButtonPressedColor,
          idleColor: ApplicationTheme.memberDevicesListHeaderAddDeviceButtonIdleColor,
          icon: Icons.add,
          onPressed: onPressed,
          size: 26
        )
      ],
    );
  }
}
