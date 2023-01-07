import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/exceptions/exceptions.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/model/device.dart';
import 'package:weforza/model/device_form_delegate.dart';
import 'package:weforza/model/device_model.dart';
import 'package:weforza/model/device_type.dart';
import 'package:weforza/model/device_validator.dart';
import 'package:weforza/riverpod/member/selected_member_devices_provider.dart';
import 'package:weforza/widgets/common/form_submit_button.dart';
import 'package:weforza/widgets/common/generic_error.dart';
import 'package:weforza/widgets/custom/device_type_carousel.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

class DeviceForm extends ConsumerStatefulWidget {
  const DeviceForm({
    required this.ownerUuid,
    super.key,
    this.device,
  });

  /// The device to edit in this form.
  /// If this is null, a new device will be created instead.
  final Device? device;

  /// The UUID of the member that owns this device.
  final String ownerUuid;

  @override
  DeviceFormState createState() => DeviceFormState();
}

class DeviceFormState extends ConsumerState<DeviceForm> with DeviceValidator {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _deviceNameController;
  late final PageController _deviceTypeController;

  final _deviceNameFocusNode = FocusNode();

  late final DeviceFormDelegate _delegate;

  @override
  void initState() {
    super.initState();

    _delegate = DeviceFormDelegate(
      notifier: ref.read(selectedMemberDevicesProvider.notifier),
    );

    final deviceType = widget.device?.type ?? DeviceType.unknown;

    _deviceNameController = TextEditingController(text: widget.device?.name);
    _deviceTypeController = PageController(initialPage: deviceType.index);
  }

  void onFormSubmitted(BuildContext context) {
    final formState = _formKey.currentState;

    if (formState == null || !formState.validate()) {
      return;
    }

    final navigator = Navigator.of(context);

    final selectedDeviceType = _deviceTypeController.page!.toInt();

    final model = DeviceModel(
      creationDate: widget.device?.creationDate,
      name: _deviceNameController.text,
      ownerId: widget.ownerUuid,
      type: DeviceType.values[selectedDeviceType],
    );

    if (model.creationDate == null) {
      _delegate.addDevice(model, whenComplete: navigator.pop);
    } else {
      _delegate.editDevice(model, whenComplete: navigator.pop);
    }
  }

  Widget _buildAndroidLayout(BuildContext context) {
    final translator = S.of(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          widget.device == null ? translator.AddDevice : translator.EditDevice,
        ),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildIosLayout(BuildContext context) {
    final translator = S.of(context);

    return CupertinoPageScaffold(
      resizeToAvoidBottomInset: false,
      navigationBar: CupertinoNavigationBar(
        middle: Text(
          widget.device == null ? translator.AddDevice : translator.EditDevice,
        ),
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
          child: DeviceTypeCarousel(controller: _deviceTypeController),
        ),
        Flexible(
          flex: 8,
          child: Column(
            children: <Widget>[
              Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  child: _buildDeviceNameInput(context),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 24),
                child: Center(child: _buildSubmitButton(context)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDeviceNameInput(BuildContext context) {
    final translator = S.of(context);

    return PlatformAwareWidget(
      android: (_) => TextFormField(
        focusNode: _deviceNameFocusNode,
        textInputAction: TextInputAction.done,
        keyboardType: TextInputType.text,
        autocorrect: false,
        controller: _deviceNameController,
        onChanged: _resetSubmit,
        validator: (value) => validateDeviceName(
          value: value,
          requiredMessage: translator.DeviceNameRequired,
          maxLengthMessage: translator.DeviceNameMaxLength(
            Device.nameMaxLength,
          ),
          illegalCharachterMessage: translator.DeviceNameCannotContainComma,
          isBlankMessage: translator.DeviceNameBlank,
        ),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 4,
          ),
          labelText: translator.DeviceName,
          helperText: ' ',
        ),
        autovalidateMode: AutovalidateMode.onUserInteraction,
      ),
      ios: (_) => CupertinoTextFormFieldRow(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: _deviceNameController,
        focusNode: _deviceNameFocusNode,
        keyboardType: TextInputType.text,
        placeholder: translator.DeviceName,
        textInputAction: TextInputAction.done,
        maxLength: Device.nameMaxLength,
        onChanged: _resetSubmit,
        validator: (value) => validateDeviceName(
          value: value,
          requiredMessage: translator.DeviceNameRequired,
          maxLengthMessage: translator.DeviceNameMaxLength(
            Device.nameMaxLength,
          ),
          illegalCharachterMessage: translator.DeviceNameCannotContainComma,
          isBlankMessage: translator.DeviceNameBlank,
        ),
      ),
    );
  }

  Widget _buildErrorMessage(BuildContext context, Object? error) {
    if (error == null) {
      return const Text('');
    }

    final translator = S.of(context);

    if (error is DeviceExistsException) {
      return GenericErrorLabel(message: translator.DeviceExists);
    }

    return GenericErrorLabel(message: translator.GenericError);
  }

  Widget _buildSubmitButton(BuildContext context) {
    final translator = S.of(context);

    final label =
        widget.device == null ? translator.AddDevice : translator.EditDevice;

    return FormSubmitButton<void>(
      delegate: _delegate,
      errorBuilder: _buildErrorMessage,
      label: label,
      onPressed: () => onFormSubmitted(context),
    );
  }

  void _resetSubmit(String _) => _delegate.reset();

  @override
  Widget build(BuildContext context) {
    return PlatformAwareWidget(
      android: _buildAndroidLayout,
      ios: _buildIosLayout,
    );
  }

  @override
  void dispose() {
    _delegate.dispose();
    _deviceNameController.dispose();
    _deviceNameFocusNode.dispose();
    _deviceTypeController.dispose();
    super.dispose();
  }
}
