import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:weforza/blocs/addDeviceBloc.dart';
import 'package:weforza/blocs/deleteDeviceBloc.dart';
import 'package:weforza/blocs/editDeviceBloc.dart';
import 'package:weforza/injection/injector.dart';
import 'package:weforza/model/device.dart';
import 'package:weforza/repository/deviceRepository.dart';
import 'package:weforza/widgets/pages/deviceManagement/deleteDevice/deleteDeviceForm.dart';
import 'package:weforza/widgets/pages/deviceManagement/deviceAdd/addDeviceForm.dart';
import 'package:weforza/widgets/pages/deviceManagement/deviceEdit/editDeviceForm.dart';
import 'package:weforza/widgets/pages/deviceManagement/iDeviceManager.dart';


class DeviceManagementInput extends StatefulWidget {
  DeviceManagementInput({
    @required Key key,
    @required this.deviceManager
  }): assert(key != null && deviceManager != null), super(key: key);

  final IDeviceManager deviceManager;

  @override
  DeviceManagementInputState createState() => DeviceManagementInputState();
}

class DeviceManagementInputState extends State<DeviceManagementInput> {

  Widget inputWidget;

  bool _addFormKey = false;

  @override
  Widget build(BuildContext context) {
    //Initialize with an add form
    if(inputWidget == null){
      widget.deviceManager.hideAddDeviceButton();
      inputWidget = AddDeviceForm(
        key: ValueKey<bool>(_addFormKey),
        deviceManager: widget.deviceManager,
        bloc: AddDeviceBloc(InjectionContainer.get<DeviceRepository>()),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: inputWidget,
    );
  }

  void requestAddForm(){
    _addFormKey = !_addFormKey;
    widget.deviceManager.hideAddDeviceButton();
    setState(() {
      inputWidget = AddDeviceForm(
        key: ValueKey<bool>(_addFormKey),
        deviceManager: widget.deviceManager,
        bloc: AddDeviceBloc(InjectionContainer.get<DeviceRepository>()),
      );
    });
  }

  void requestEditForm(Device device, void Function(Device editedDevice) onSuccess){
    widget.deviceManager.showAddDeviceButton();
    setState(() {
      inputWidget = EditDeviceForm(
        bloc: EditDeviceBloc(device,InjectionContainer.get<DeviceRepository>()),
        deviceManager: widget.deviceManager,
        onSuccess: onSuccess
      );
    });
  }

  void requestDeleteForm(Device device, int index){
    widget.deviceManager.showAddDeviceButton();
    setState(() {
      inputWidget = DeleteDeviceForm(
          deviceManager: widget.deviceManager,
          bloc: DeleteDeviceBloc(device,index,InjectionContainer.get<DeviceRepository>())
      );
    });
  }
}
