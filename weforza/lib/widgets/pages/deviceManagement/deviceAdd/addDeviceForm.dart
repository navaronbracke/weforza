import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:weforza/blocs/addDeviceBloc.dart';
import 'package:weforza/theme/appTheme.dart';
import 'package:weforza/widgets/pages/deviceManagement/deviceAdd/addDeviceSubmit.dart';
import 'package:weforza/widgets/pages/deviceManagement/iDeviceManager.dart';
import 'package:weforza/widgets/pages/deviceManagement/deviceTypePicker.dart';
import 'package:weforza/widgets/platform/cupertinoFormErrorFormatter.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/widgets/providers/selectedItemProvider.dart';

class AddDeviceForm extends StatefulWidget {
  AddDeviceForm({
    @required ValueKey<bool> key,
    @required this.bloc,
    @required this.deviceManager,
  }): assert(key != null && bloc != null), super(key: key);

  final AddDeviceBloc bloc;
  final IDeviceManager deviceManager;

  @override
  _AddDeviceFormState createState() => _AddDeviceFormState();
}

class _AddDeviceFormState extends State<AddDeviceForm> {

  final TextEditingController _addDeviceController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

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
            controller: _addDeviceController,
            validator: (value) => widget.bloc.validateNewDeviceInput(
                value,
                S.of(context).ValueIsRequired(S.of(context).DeviceNameLabel),
                S.of(context).DeviceNameMaxLength(widget.bloc.deviceNameMaxLength.toString())
            ),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 5),
              labelText: S.of(context).DeviceNameLabel,
              helperText: " ",
            ),
            autovalidate: widget.bloc.autoValidateNewDeviceName,
            onChanged: (value) => setState((){
              widget.bloc.autoValidateNewDeviceName = true;
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
                        child: AddDeviceSubmit(onPressed: () async {
                          if(_formKey.currentState.validate()){
                            await widget.bloc.addDevice(
                                SelectedItemProvider.of(context).selectedMember.value.uuid,
                                S.of(context).DeviceAlreadyExists, S.of(context).AddDeviceError)
                                .then((device) => widget.deviceManager.onDeviceAdded(device))
                                .catchError((e){
                                  //do nothing, the stream catches it
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
            controller: _addDeviceController,
            placeholder: S.of(context).DeviceNameLabel,
            autocorrect: false,
            keyboardType: TextInputType.text,
            onChanged: (value) {
              setState(() {
                widget.bloc.validateNewDeviceInput(
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
                  CupertinoFormErrorFormatter.formatErrorMessage(widget.bloc.addDeviceError),
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
                        child: AddDeviceSubmit(onPressed: () async {
                          if(iosValidateAddDevice()){
                            await widget.bloc.addDevice(
                                SelectedItemProvider.of(context).selectedMember.value.uuid,
                                S.of(context).DeviceAlreadyExists, S.of(context).AddDeviceError)
                                .then((device) => widget.deviceManager.onDeviceAdded(device))
                                .catchError((e){
                              //do nothing, the stream catches it
                            });
                          }else {
                            setState((){
                              //trigger form error redraw on ios
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

  bool iosValidateAddDevice(){
    return widget.bloc.validateNewDeviceInput(
        _addDeviceController.text,
        S.of(context).ValueIsRequired(S.of(context).DeviceNameLabel),
        S.of(context).DeviceNameMaxLength(widget.bloc.deviceNameMaxLength.toString())) == null;
  }
}
