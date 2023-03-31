import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/blocs/add_device_bloc.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/injection/injectionContainer.dart';
import 'package:weforza/repository/device_repository.dart';
import 'package:weforza/theme/appTheme.dart';
import 'package:weforza/widgets/custom/deviceTypeCarousel/deviceTypeCarousel.dart';
import 'package:weforza/widgets/pages/addDevice/addDeviceSubmit.dart';
import 'package:weforza/widgets/platform/cupertinoFormErrorFormatter.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';
import 'package:weforza/widgets/providers/reloadDataProvider.dart';
import 'package:weforza/widgets/providers/selectedItemProvider.dart';

class AddDevicePage extends StatefulWidget {
  const AddDevicePage({Key? key}) : super(key: key);

  @override
  _AddDevicePageState createState() => _AddDevicePageState();
}

class _AddDevicePageState extends State<AddDevicePage> {
  late AddDeviceBloc bloc;

  final _formKey = GlobalKey<FormState>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    bloc = AddDeviceBloc(
        repository: InjectionContainer.get<DeviceRepository>(),
        ownerId: SelectedItemProvider.of(context).selectedMember.value!.uuid);
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
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
        title: Text(S.of(context).AddDeviceTitle),
        automaticallyImplyLeading: true,
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildIosWidget(BuildContext context) {
    return CupertinoPageScaffold(
      resizeToAvoidBottomInset: false,
      navigationBar: CupertinoNavigationBar(
        middle: Text(S.of(context).AddDeviceTitle),
        automaticallyImplyLeading: true,
        transitionBetweenRoutes: false,
      ),
      child: SafeArea(
        bottom: false,
        child: _buildBody(context),
      ),
    );
  }

  Widget _buildTypeCarousel() {
    return DeviceTypeCarousel(
      controller: bloc.pageController,
      onPageChanged: bloc.onDeviceTypeChanged,
      currentPageStream: bloc.currentTypeStream,
    );
  }

  Widget _buildDeviceNameInput(BuildContext context) {
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
            validator: (value) => bloc.validateNewDeviceInput(
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
                    bloc.validateNewDeviceInput(
                      value,
                      S
                          .of(context)
                          .ValueIsRequired(S.of(context).DeviceNameLabel),
                      S
                          .of(context)
                          .DeviceNameMaxLength('${bloc.deviceNameMaxLength}'),
                      S.of(context).DeviceNameCannotContainComma,
                      S.of(context).DeviceNameBlank,
                    );
                  });
                },
              ),
              Row(
                children: <Widget>[
                  Text(
                      CupertinoFormErrorFormatter.formatErrorMessage(
                          bloc.addDeviceError),
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
      android: () => AddDeviceSubmit(
        isSubmittingStream: bloc.submitStream,
        submitErrorStream: bloc.submitErrorStream,
        onSubmit: () async {
          final formState = _formKey.currentState;

          if (formState != null && formState.validate()) {
            await bloc
                .addDevice(
                    S.of(context).DeviceExists, S.of(context).GenericError)
                .then((_) {
              ReloadDataProvider.of(context).reloadDevices.value = true;
              Navigator.of(context).pop();
            }).catchError((e) {
              //the stream catches the error
            });
          }
        },
      ),
      ios: () => AddDeviceSubmit(
        isSubmittingStream: bloc.submitStream,
        submitErrorStream: bloc.submitErrorStream,
        onSubmit: () async {
          if (iosValidateAddDevice(context)) {
            await bloc
                .addDevice(
                    S.of(context).DeviceExists, S.of(context).GenericError)
                .then((_) {
              ReloadDataProvider.of(context).reloadDevices.value = true;
              Navigator.of(context).pop();
            }).catchError((e) {
              //the stream catches the error
            });
          } else {
            setState(() {});
          }
        },
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
              _buildDeviceNameInput(context),
              _buildSubmitButton(context),
            ],
          ),
        ),
      ],
    );
  }

  bool iosValidateAddDevice(BuildContext context) {
    return bloc.validateNewDeviceInput(
            bloc.deviceNameController.text,
            S.of(context).ValueIsRequired(S.of(context).DeviceNameLabel),
            S.of(context).DeviceNameMaxLength('${bloc.deviceNameMaxLength}'),
            S.of(context).DeviceNameCannotContainComma,
            S.of(context).DeviceNameBlank) ==
        null;
  }
}
