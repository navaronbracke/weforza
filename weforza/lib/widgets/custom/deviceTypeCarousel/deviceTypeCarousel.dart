
import 'package:flutter/material.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/model/device.dart';
import 'package:weforza/theme/appTheme.dart';
import 'package:weforza/widgets/common/deviceWidgetUtils.dart';

class DeviceTypeCarousel extends StatelessWidget {
  DeviceTypeCarousel({
    required this.controller,
    required this.onPageChanged,
    required this.currentPageStream,
  });

  final PageController controller;
  final void Function(int page) onPageChanged;
  final Stream<int> currentPageStream;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Flexible(
          flex: 9,
          child: PageView.builder(
            itemCount: DeviceType.values.length,
            itemBuilder: _buildIcon,
            onPageChanged: onPageChanged,
            controller: controller,
          ),
        ),
        Flexible(
          flex: 2,
          child: Center(
            child: StreamBuilder<int>(
              stream: currentPageStream,
              builder: (context, snapshot){
                final children = <Widget>[];
                for(int i = 0; i< DeviceType.values.length; i++){
                  children.add(_buildPageDot(i == snapshot.data));
                }
                return Row(
                  children: children,
                  mainAxisAlignment: MainAxisAlignment.center,
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPageDot(bool isCurrentPage){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Container(
        width: 10,height: 10,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isCurrentPage ? ApplicationTheme.deviceTypePickerCurrentDotColor
              : ApplicationTheme.deviceTypePickerDotColor
        ),
      ),
    );
  }

  Widget _buildIcon(BuildContext context, int index){
    return Column(
      children: <Widget>[
        Expanded(
          child: Center(
            child: LayoutBuilder(
              builder: (context, constraints){
                return Icon(
                  getDeviceTypeIconData(index),
                  color: ApplicationTheme.deviceTypePickerCurrentDotColor,
                  size: constraints.biggest.shortestSide * .9
                );
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Center(
              child: Text(
                _getLabel(context, index),
                style: TextStyle(fontSize: 14.0),
              )
          ),
        ),
      ],
    );
  }

  String _getLabel(BuildContext context, int index){
    switch(DeviceType.values[index]){
      case DeviceType.HEADSET: return S.of(context).DeviceHeadset;
      case DeviceType.WATCH: return S.of(context).DeviceWatch;
      case DeviceType.POWER_METER: return S.of(context).DevicePowerMeter;
      case DeviceType.CADENCE_METER: return S.of(context).DeviceCadenceMeter;
      case DeviceType.PHONE: return S.of(context).DevicePhone;
      case DeviceType.GPS: return S.of(context).DeviceGPS;
      case DeviceType.PULSE_MONITOR: return S.of(context).DevicePulseMonitor;
      default: return S.of(context).DeviceUnknown;
    }
  }
}
