import 'package:flutter/material.dart';
import 'package:weforza/generated/i18n.dart';
import 'package:weforza/model/device.dart';
import 'package:weforza/widgets/pages/memberDetails/memberDeviceItem.dart';
import 'package:weforza/widgets/platform/cupertinoIconButton.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

class MemberDevices extends StatelessWidget {
  MemberDevices({@required this.devices, @required this.onEditPressed }):
        assert(devices != null && onEditPressed != null);

  final List<Device> devices;
  final VoidCallback onEditPressed;

  @override
  Widget build(BuildContext context){
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 4),
                child: Text(S.of(context).DevicesHeader,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16)),
              ),
            ),
            _buildButton()
          ],
        ),
        Expanded(
          child: ListView.builder(
              itemBuilder: (context,index)=> MemberDeviceItem(devices[index]),
              itemCount: devices.length),
        ),
      ],
    );
  }

  Widget _buildButton(){
    return PlatformAwareWidget(
      android: () => IconButton(
        icon: Icon(Icons.edit),
        onPressed: onEditPressed,
      ),
      ios: () => CupertinoIconButton(
        icon: Icons.edit,
        onPressed: onEditPressed,
      ),
    );
  }
}
