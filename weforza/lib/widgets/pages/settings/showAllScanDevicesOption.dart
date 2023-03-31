import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:weforza/generated/i18n.dart';
import 'package:weforza/theme/appTheme.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

abstract class ShowAllScanDevicesHandler {
  bool get currentValue;

  void Function(bool value) onChanged;
}

class ShowAllScanDevicesOption extends StatefulWidget {
  ShowAllScanDevicesOption(this.handler) : assert(handler != null);

  final ShowAllScanDevicesHandler handler;

  @override
  _ShowAllScanDevicesOptionState createState() =>
      _ShowAllScanDevicesOptionState();
}

class _ShowAllScanDevicesOptionState extends State<ShowAllScanDevicesOption> {
  @override
  Widget build(BuildContext context) => PlatformAwareWidget(
    android: () => _buildAndroidWidget(context),
    ios: () => _buildIosWidget(context)
  );

  Widget _buildAndroidWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Text(S.of(context).SettingsShowAllDevicesOptionLabel,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  style: ApplicationTheme.settingsOptionHeaderStyle),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Switch(
                value: widget.handler.currentValue,
                onChanged: (value) => setState(() => widget.handler.onChanged(value)),
              ),
            ),
          ],
        ),
        Text(S.of(context).SettingsShowAllDevicesOptionDescription,
            softWrap: true,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: ApplicationTheme.settingsOptionHeaderStyle
                .copyWith(fontSize: 12)),
      ],
    );
  }

  Widget _buildIosWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Text(S.of(context).SettingsShowAllDevicesOptionLabel,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  style: ApplicationTheme.settingsOptionHeaderStyle.copyWith(
                    fontSize: 16
                  )),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: CupertinoSwitch(
                value: widget.handler.currentValue,
                onChanged: (value) => setState(() => widget.handler.onChanged(value)),
              ),
            ),
          ],
        ),
        Text(S.of(context).SettingsShowAllDevicesOptionDescription,
            softWrap: true,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: ApplicationTheme.settingsOptionHeaderStyle
                .copyWith(fontSize: 14)),
      ],
    );
  }
}
