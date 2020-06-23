import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:weforza/blocs/editDeviceBloc.dart';
import 'package:weforza/model/device.dart';
import 'package:weforza/theme/appTheme.dart';
import 'package:weforza/widgets/pages/deviceManagement/deviceEdit/editDeviceSubmit.dart';
import 'package:weforza/widgets/pages/deviceManagement/deviceTypePicker.dart';
import 'package:weforza/widgets/pages/deviceManagement/iDeviceManager.dart';
import 'package:weforza/widgets/platform/cupertinoFormErrorFormatter.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';
import 'package:weforza/generated/l10n.dart';

class EditDeviceForm extends StatefulWidget {
  EditDeviceForm({
    @required this.bloc,
    @required this.deviceManager,
    @required this.onSuccess,
  }): assert(bloc != null && onSuccess != null && deviceManager != null);

  final void Function(Device editedDevice) onSuccess;
  final EditDeviceBloc bloc;
  final IDeviceManager deviceManager;

  @override
  _EditDeviceFormState createState() => _EditDeviceFormState();
}

class _EditDeviceFormState extends State<EditDeviceForm> {

  TextEditingController _editDeviceController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _editDeviceController = TextEditingController(text: widget.bloc.newDeviceName);
  }

  @override
  Widget build(BuildContext context) => PlatformAwareWidget(
    android: () => _buildAndroidLayout(context),
    ios: () => _buildIosLayout(context),
  );

  Widget _buildAndroidLayout(BuildContext context){
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            textInputAction: TextInputAction.done,
            keyboardType: TextInputType.text,
            autocorrect: false,
            controller: _editDeviceController,
            validator: (value) => widget.bloc.validateDeviceNameInput(
                value,
                S.of(context).ValueIsRequired(S.of(context).DeviceNameLabel),
                S.of(context).DeviceNameMaxLength(widget.bloc.deviceNameMaxLength.toString())
            ),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 5),
              labelText: S.of(context).DeviceNameLabel,
              helperText: " ",
            ),
            autovalidate: widget.bloc.autoValidateDeviceName,
            onChanged: (value) => setState((){
              widget.bloc.autoValidateDeviceName = true;
            }),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Center(
                    child: DeviceTypePicker(valueChangedHandler: widget.bloc),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: Center(
                        child: EditDeviceSubmit(onPressed: () async {
                          if(_formKey.currentState.validate()){
                            await widget.bloc.editDevice(S.of(context).DeviceAlreadyExists, S.of(context).AddDeviceError)
                                .then((device) => widget.onSuccess(device))
                                .catchError((e){
                              //the stream catches it
                            });
                          }
                        },stream: widget.bloc.submitStream)
                    )
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Center(
              child: StreamBuilder<String>(
                stream: widget.bloc.submitErrorStream,
                initialData: "",
                builder: (context,snapshot)=> Text(snapshot.data),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIosLayout(BuildContext context){
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          CupertinoTextField(
            textInputAction: TextInputAction.done,
            controller: _editDeviceController,
            placeholder: S.of(context).DeviceNameLabel,
            autocorrect: false,
            keyboardType: TextInputType.text,
            onChanged: (value) {
              setState(() {
                widget.bloc.validateDeviceNameInput(
                    value,
                    S.of(context).ValueIsRequired(S.of(context).DeviceNameLabel),
                    S.of(context).DeviceNameMaxLength(widget.bloc.deviceNameMaxLength.toString())
                );
              });
            },
          ),
          Row(
            children: <Widget>[
              Text(
                  CupertinoFormErrorFormatter.formatErrorMessage(widget.bloc.editDeviceError),
                  style: ApplicationTheme.iosFormErrorStyle
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Center(
                    child: DeviceTypePicker(valueChangedHandler: widget.bloc),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: Center(
                        child: EditDeviceSubmit(onPressed: () async {
                          if(iosValidateEditDevice()){
                            await widget.bloc.editDevice(S.of(context).DeviceAlreadyExists, S.of(context).AddDeviceError)
                                .then((device) => widget.onSuccess(device))
                                .catchError((e){
                              //the stream catches it
                            });
                          }
                        },stream: widget.bloc.submitStream)
                    )
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Center(
              child: StreamBuilder<String>(
                stream: widget.bloc.submitErrorStream,
                initialData: "",
                builder: (context,snapshot)=> Text(snapshot.data),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool iosValidateEditDevice(){
    return widget.bloc.validateDeviceNameInput(
        _editDeviceController.text,
        S.of(context).ValueIsRequired(S.of(context).DeviceNameLabel),
        S.of(context).DeviceNameMaxLength(widget.bloc.deviceNameMaxLength.toString())) == null;
  }
}
