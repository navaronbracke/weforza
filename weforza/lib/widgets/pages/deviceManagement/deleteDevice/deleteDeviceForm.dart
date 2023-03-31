
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weforza/blocs/deleteDeviceBloc.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/widgets/pages/deviceManagement/iDeviceManager.dart';
import 'package:weforza/widgets/platform/platformAwareLoadingIndicator.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';
import 'package:weforza/widgets/providers/reloadDataProvider.dart';

class DeleteDeviceForm extends StatelessWidget {
  DeleteDeviceForm({@required this.deviceManager, @required this.bloc}):
        assert(deviceManager != null && bloc != null);

  final DeleteDeviceBloc bloc;
  final IDeviceManager deviceManager;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: StreamBuilder<bool>(
        initialData: false,
        stream: bloc.isDeletedStream,
        builder: (context,snapshot){
          if(snapshot.hasError){
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(snapshot.error as String),
                SizedBox(height: 10),
                PlatformAwareWidget(
                  android: () => FlatButton(
                    child: Text(S.of(context).DialogOk),
                    onPressed: () => deviceManager.requestAddForm(),
                  ),
                  ios: () => CupertinoButton(
                    child: Text(S.of(context).DialogOk),
                    onPressed: () => deviceManager.requestAddForm(),
                  ),
                ),
              ],
            );
          }else{
            return snapshot.data ? Center(child: PlatformAwareLoadingIndicator()) : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(S.of(context).DeleteDeviceDescription(bloc.device.name)),
                SizedBox(height: 10),
                _buildButtons(context),
              ],
            );
          }
        },
      ),
    );
  }

  //DialogDelete,Cancel and new error text
  Widget _buildButtons(BuildContext context){
    return PlatformAwareWidget(
      android: () => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FlatButton(
            child: Text(S.of(context).DialogCancel),
            onPressed: ()=> deviceManager.requestAddForm(),
          ),
          SizedBox(width: 20),
          FlatButton(
            child: Text(
                S.of(context).DialogDelete,
                style: TextStyle(color: Colors.red)
            ),
            onPressed: () async {
              await bloc.deleteDevice(S.of(context).DeleteDeviceError(bloc.device.name)).then((_){
                deviceManager.onDeviceRemoved(bloc.device,bloc.itemIndex);
                ReloadDataProvider.of(context).reloadDevices.value = true;
              }).catchError((error){
                //the error is caught by the stream.
              });
            },
          ),
        ],
      ),
      ios: () => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CupertinoButton(
            child: Text(S.of(context).DialogCancel),
            onPressed: ()=> deviceManager.requestAddForm(),
          ),
          SizedBox(width: 20),
          CupertinoButton(
            child: Text(
                S.of(context).DialogDelete,
                style: TextStyle(color: Colors.red)
            ),
            onPressed: () async {
              await bloc.deleteDevice(S.of(context).DeleteDeviceError(bloc.device.name)).then((_){
                deviceManager.onDeviceRemoved(bloc.device,bloc.itemIndex);
                ReloadDataProvider.of(context).reloadDevices.value = true;
              }).catchError((error){
                //the error is caught by the stream.
              });
            },
          ),
        ],
      ),
    );
  }
}
