import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:weforza/generated/i18n.dart';
import 'package:weforza/theme/appTheme.dart';

abstract class ShowAllScanDevicesHandler {
  bool get currentValue;

  void Function(bool value) onChanged;
}

class ShowAllScanDevicesOption extends StatefulWidget {
  ShowAllScanDevicesOption(this.handler): assert(handler != null);

  final ShowAllScanDevicesHandler handler;

  @override
  _ShowAllScanDevicesOptionState createState() => _ShowAllScanDevicesOptionState();
}

class _ShowAllScanDevicesOptionState extends State<ShowAllScanDevicesOption> {
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Row(
        children: <Widget>[
          Expanded(
            child: Text(S.of(context).SettingsShowAllDevicesOptionLabel, softWrap: true, style: ApplicationTheme.settingsOptionHeaderStyle),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Switch.adaptive(value: widget.handler.currentValue, onChanged: (value){
              setState(() {
                widget.handler.onChanged(value);
              });
            }),
          ),
        ],
      ),
      Text(S.of(context).SettingsShowAllDevicesOptionDescription,
          softWrap: true,
          style: ApplicationTheme.settingsOptionHeaderStyle.copyWith(fontSize: 11)
      ),
    ],
  );
}
