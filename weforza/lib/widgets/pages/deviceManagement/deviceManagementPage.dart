import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weforza/generated/i18n.dart';
import 'package:weforza/model/device.dart';
import 'package:weforza/widgets/pages/deviceManagement/deviceManagementInput.dart';
import 'package:weforza/widgets/pages/deviceManagement/deviceList/deviceManagementList.dart';
import 'package:weforza/widgets/pages/deviceManagement/iDeviceManager.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

class DeviceManagementPage extends StatefulWidget {
  DeviceManagementPage({@required this.devices}): assert(devices != null);

  final List<Device> devices;

  @override
  _DeviceManagementPageState createState() => _DeviceManagementPageState();
}

class _DeviceManagementPageState extends State<DeviceManagementPage> implements IDeviceManager {
  final GlobalKey<DeviceManagementInputState> input = GlobalKey();
  final GlobalKey<DeviceManagementListState> list = GlobalKey();

  final _showAddDeviceButtonController = BehaviorSubject<bool>();


  @override
  Widget build(BuildContext context) => WillPopScope(
    onWillPop: () {
      FocusScope.of(context).unfocus();
      return Future.value(true);
    },
    child: PlatformAwareWidget(
      android: () => _buildAndroidWidget(context),
      ios: () => _buildIosWidget(context),
    ),
  );

  Widget _buildAndroidWidget(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(S.of(context).DeviceOverviewTitle),
        ),
        body: _buildBody()
    );
  }

  Widget _buildIosWidget(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          transitionBetweenRoutes: false,
          middle: Text(S.of(context).DeviceOverviewTitle),
        ),
        child: SafeArea(bottom: false,child: _buildBody())
    );
  }

  Widget _buildBody(){
    return Column(
      children: <Widget>[
        DeviceManagementInput(key: input,deviceManager: this),
        Expanded(
          child: DeviceManagementList(key: list,deviceManager: this),
        ),
      ],
    );
  }

  @override
  void requestAddForm() => input.currentState.requestAddForm();

  @override
  void requestEditForm(Device device, void Function(Device editedDevice) onSuccess) =>
      input.currentState.requestEditForm(device, onSuccess);

  @override
  void hideAddDeviceButton() => _showAddDeviceButtonController.add(false);

  @override
  Stream<bool> get isShowingAddDeviceForm => _showAddDeviceButtonController.stream;

  @override
  void onDeviceAdded(Device device) {
    widget.devices.add(device);
    list.currentState.insertItem(0);
  }

  @override
  void showAddDeviceButton() => _showAddDeviceButtonController.add(true);

  @override
  List<Device> get devices => widget.devices;

  @override
  void dispose() {
    _showAddDeviceButtonController.close();
    super.dispose();
  }

  @override
  void updateDevice(Device device, int index) {
    devices[index] = device;
    list.currentState.setState((){});
  }

  @override
  void onDeviceRemoved(Device device, int index) {
    devices.removeAt(index);
    list.currentState.removeItem(index);
    requestAddForm();
  }

  @override
  void requestDeleteForm(Device device, int index) {
    input.currentState.requestDeleteForm(device, index);
  }
}


