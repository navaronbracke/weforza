import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/model/device.dart';
import 'package:weforza/theme/appTheme.dart';
import 'package:weforza/widgets/platform/cupertinoIconButton.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

///This interface defines a contract for handling the changes in [DeviceTypePicker].
abstract class DeviceTypePickerHandler {
  DeviceType get currentValue;

  void onTypeForwardPressed();

  void onTypeBackPressed();
}

class DeviceTypePicker extends StatefulWidget {
  DeviceTypePicker({@required this.valueChangedHandler}): assert(valueChangedHandler != null);

  final DeviceTypePickerHandler valueChangedHandler;

  @override
  _DeviceTypePickerState createState() => _DeviceTypePickerState();
}

class _DeviceTypePickerState extends State<DeviceTypePicker> {

  Map<DeviceType,String> _items;

  void _initializeItems(BuildContext context){
    _items = {
      DeviceType.UNKNOWN: S.of(context).DeviceUnknown,
      DeviceType.PULSE_MONITOR: S.of(context).DevicePulseMonitor,
      DeviceType.GPS: S.of(context).DeviceGPS,
      DeviceType.HEADSET: S.of(context).DeviceHeadset,
      DeviceType.PHONE: S.of(context).DevicePhone,
      DeviceType.TABLET: S.of(context).DeviceTablet,
      DeviceType.WATCH: S.of(context).DeviceWatch
    };
  }

  @override
  Widget build(BuildContext context){
    _initializeItems(context);
    return PlatformAwareWidget(
      android: () => _buildAndroidWidget(context),
      ios: () => _buildIosWidget(context),
    );
  }

  Widget _buildAndroidWidget(BuildContext context) {
    final value = widget.valueChangedHandler.currentValue;
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Center(child: Text("${S.of(context).DeviceTypeLabel}     (${value.index + 1} / ${DeviceType.values.length})")),
              ),
            ],
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.arrow_back_ios),
              color: ApplicationTheme.choiceArrowIdleColor,
              splashColor: ApplicationTheme.choiceArrowOnPressedColor,
              onPressed: () => setState(() => widget.valueChangedHandler.onTypeBackPressed()),
            ),
            Expanded(
              child: Center(
                child: Text(_items[value]),
              ),
            ),
            IconButton(
              icon: Icon(Icons.arrow_forward_ios),
              color: ApplicationTheme.choiceArrowIdleColor,
              splashColor: ApplicationTheme.choiceArrowOnPressedColor,
              onPressed: () => setState(()=> widget.valueChangedHandler.onTypeForwardPressed()),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildIosWidget(BuildContext context) {
    final value = widget.valueChangedHandler.currentValue;
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Center(child: Text("${S.of(context).DeviceTypeLabel}     (${value.index + 1} / ${DeviceType.values.length})")),
              ),
            ],
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CupertinoIconButton(
              icon: Icons.arrow_back_ios,
              idleColor: ApplicationTheme.choiceArrowIdleColor,
              onPressedColor: ApplicationTheme.choiceArrowOnPressedColor,
              onPressed: () => setState(() => widget.valueChangedHandler.onTypeBackPressed()),
            ),
            Expanded(
              child: Center(
                child: Text(_items[value]),
              ),
            ),
            CupertinoIconButton(
              icon: Icons.arrow_forward_ios,
              idleColor: ApplicationTheme.choiceArrowIdleColor,
              onPressedColor: ApplicationTheme.choiceArrowOnPressedColor,
              onPressed: () => setState(()=> widget.valueChangedHandler.onTypeForwardPressed()),
            ),
          ],
        ),
      ],
    );
  }
}
