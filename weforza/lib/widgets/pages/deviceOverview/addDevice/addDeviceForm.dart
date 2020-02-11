import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:weforza/blocs/addDeviceBloc.dart';
import 'package:weforza/model/device.dart';
import 'package:weforza/widgets/pages/deviceOverview/addDevice/addDeviceSubmit.dart';
import 'package:weforza/widgets/pages/deviceOverview/deviceTypePicker.dart';
import 'package:weforza/widgets/platform/orientationAwareWidget.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';
import 'package:weforza/generated/i18n.dart';

class AddDeviceForm extends StatefulWidget {
  AddDeviceForm(this.bloc): assert(bloc != null);

  final AddDeviceBloc bloc;

  @override
  _AddDeviceFormState createState() => _AddDeviceFormState();
}

class _AddDeviceFormState extends State<AddDeviceForm> {

  final TextEditingController _addDeviceController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) => PlatformAwareWidget(
    android: () => OrientationAwareWidget(
      portrait: () => _buildAndroidPortraitLayout(context),
      landscape: () => _buildAndroidLandscapeLayout(context),
    ),
    ios: () => OrientationAwareWidget(
      portrait: () => _buildIosPortraitLayout(context),
      landscape: () => _buildIosLandscapeLayout(context),
    ),
  );

  Widget _buildAndroidPortraitLayout(BuildContext context){
    return Column(
      children: <Widget>[
        Form(
          key: _formKey,
          child: TextFormField(
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
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
          child: Row(
            children: <Widget>[
              Flexible(
                child: Center(
                  child: DeviceTypePicker(
                      initialValue: DeviceType.UNKNOWN,
                      onValueChanged: (value)=> widget.bloc.type = value
                  ),
                ),
              ),
              Flexible(
                child: Center(
                  child: AddDeviceSubmit(onPressed: (){
                    if(_formKey.currentState.validate()){
                      //TODO add device, its valid here
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
    );
  }

  Widget _buildAndroidLandscapeLayout(BuildContext context){
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
          child: Form(
            key: _formKey,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextFormField(
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
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 4, 0),
                  child: Center(
                    child: DeviceTypePicker(
                        initialValue: DeviceType.UNKNOWN,
                        onValueChanged: (value)=> widget.bloc.type = value
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Center(
                      child: AddDeviceSubmit(onPressed: (){
                        if(_formKey.currentState.validate()){
                          //TODO add device, its valid here
                        }
                      },stream: widget.bloc.submitStream)
                  ),
                )
              ],
            ),
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
    );
  }

  Widget _buildIosPortraitLayout(BuildContext context){
    //TODO ios layout
  }

  Widget _buildIosLandscapeLayout(BuildContext context){
    //TODO ios layout
  }
}
