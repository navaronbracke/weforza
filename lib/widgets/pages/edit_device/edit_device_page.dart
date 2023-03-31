import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/blocs/edit_device_bloc.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/injection/injectionContainer.dart';
import 'package:weforza/repository/device_repository.dart';
import 'package:weforza/theme/app_theme.dart';
import 'package:weforza/widgets/custom/device_type_carousel.dart';
import 'package:weforza/widgets/pages/edit_device/edit_device_submit.dart';
import 'package:weforza/widgets/platform/cupertino_form_error_formatter.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';
import 'package:weforza/widgets/providers/selectedItemProvider.dart';

class EditDevicePage extends StatefulWidget {
  const EditDevicePage({Key? key}) : super(key: key);

  @override
  _EditDevicePageState createState() => _EditDevicePageState();
}

class _EditDevicePageState extends State<EditDevicePage> {
  late EditDeviceBloc bloc;

  final _formKey = GlobalKey<FormState>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final device = SelectedItemProvider.of(context).selectedDevice.value!;
    bloc = EditDeviceBloc(
      repository: InjectionContainer.get<DeviceRepository>(),
      deviceName: device.name,
      deviceCreationDate: device.creationDate,
      deviceOwnerId: device.ownerId,
      deviceType: device.type,
    );
  }

  @override
  Widget build(BuildContext context) => PlatformAwareWidget(
        android: () => _buildAndroidWidget(context),
        ios: () => _buildIosWidget(context),
      );

  Widget _buildAndroidWidget(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(S.of(context).EditDeviceTitle),
        automaticallyImplyLeading: true,
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildIosWidget(BuildContext context) {
    return CupertinoPageScaffold(
      resizeToAvoidBottomInset: false,
      navigationBar: CupertinoNavigationBar(
        middle: Text(S.of(context).EditDeviceTitle),
        automaticallyImplyLeading: true,
        transitionBetweenRoutes: false,
      ),
      child: SafeArea(
        bottom: false,
        child: _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      children: <Widget>[
        Flexible(
          flex: 3,
          child: _buildTypeCarousel(),
        ),
        Flexible(
          flex: 8,
          child: Column(
            children: <Widget>[
              _buildDeviceNameInput(),
              _buildSubmitButton(context),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTypeCarousel() {
    return DeviceTypeCarousel(
      controller: bloc.pageController,
      onPageChanged: bloc.onDeviceTypeChanged,
      currentPageStream: bloc.currentTypeStream,
    );
  }

  Widget _buildDeviceNameInput() {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
        child: PlatformAwareWidget(
          android: () => TextFormField(
            textInputAction: TextInputAction.done,
            keyboardType: TextInputType.text,
            autocorrect: false,
            controller: bloc.deviceNameController,
            validator: (value) => bloc.validateDeviceNameInput(
                value,
                S.of(context).ValueIsRequired(S.of(context).DeviceNameLabel),
                S
                    .of(context)
                    .DeviceNameMaxLength('${bloc.deviceNameMaxLength}'),
                S.of(context).DeviceNameCannotContainComma,
                S.of(context).DeviceNameBlank),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 5),
              labelText: S.of(context).DeviceNameLabel,
              helperText: ' ',
            ),
            autovalidateMode: AutovalidateMode.onUserInteraction,
          ),
          ios: () => Column(
            children: <Widget>[
              CupertinoTextField(
                textInputAction: TextInputAction.done,
                controller: bloc.deviceNameController,
                placeholder: S.of(context).DeviceNameLabel,
                autocorrect: false,
                keyboardType: TextInputType.text,
                onChanged: (value) {
                  setState(() {
                    bloc.validateDeviceNameInput(
                        value,
                        S
                            .of(context)
                            .ValueIsRequired(S.of(context).DeviceNameLabel),
                        S
                            .of(context)
                            .DeviceNameMaxLength('${bloc.deviceNameMaxLength}'),
                        S.of(context).DeviceNameCannotContainComma,
                        S.of(context).DeviceNameBlank);
                  });
                },
              ),
              Row(
                children: <Widget>[
                  Text(
                      CupertinoFormErrorFormatter.formatErrorMessage(
                          bloc.editDeviceError),
                      style: ApplicationTheme.iosFormErrorStyle),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return PlatformAwareWidget(
      android: () => EditDeviceSubmit(
        submitErrorStream: bloc.submitErrorStream,
        isSubmittingStream: bloc.submitStream,
        onSubmit: () async {
          final formState = _formKey.currentState;

          if (formState != null && formState.validate()) {
            await bloc
                .editDevice(
                    S.of(context).DeviceExists, S.of(context).GenericError)
                .then((editedDevice) {
              SelectedItemProvider.of(context).selectedDevice.value = null;
              Navigator.of(context).pop(editedDevice);
            }).catchError((e) {
              //the stream catches the error
            });
          }
        },
      ),
      ios: () => EditDeviceSubmit(
        submitErrorStream: bloc.submitErrorStream,
        isSubmittingStream: bloc.submitStream,
        onSubmit: () async {
          if (iosValidateAddDevice(context)) {
            await bloc
                .editDevice(
                    S.of(context).DeviceExists, S.of(context).GenericError)
                .then((editedDevice) {
              SelectedItemProvider.of(context).selectedDevice.value = null;
              Navigator.of(context).pop(editedDevice);
            }).catchError((e) {
              //the stream catches the error
            });
          } else {
            setState(() {});
          }
        },
      ),
      //the on submit sets reload to true
    );
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  bool iosValidateAddDevice(BuildContext context) {
    return bloc.validateDeviceNameInput(
            bloc.deviceNameController.text,
            S.of(context).ValueIsRequired(S.of(context).DeviceNameLabel),
            S.of(context).DeviceNameMaxLength('${bloc.deviceNameMaxLength}'),
            S.of(context).DeviceNameCannotContainComma,
            S.of(context).DeviceNameBlank) ==
        null;
  }
}
