import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/exceptions/exceptions.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/model/device/device.dart';
import 'package:weforza/model/device/device_form_delegate.dart';
import 'package:weforza/model/device/device_model.dart';
import 'package:weforza/model/device/device_type.dart';
import 'package:weforza/model/device/device_validator.dart';
import 'package:weforza/riverpod/rider/selected_rider_devices_provider.dart';
import 'package:weforza/widgets/common/focus_absorber.dart';
import 'package:weforza/widgets/common/form_submit_button.dart';
import 'package:weforza/widgets/common/generic_error.dart';
import 'package:weforza/widgets/custom/device_type_carousel.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

class DeviceForm extends ConsumerStatefulWidget {
  const DeviceForm({required this.ownerUuid, super.key, this.device});

  /// The device to edit in this form.
  /// If this is null, a new device will be created instead.
  final Device? device;

  /// The UUID of the rider that owns this device.
  final String ownerUuid;

  @override
  DeviceFormState createState() => DeviceFormState();
}

class DeviceFormState extends ConsumerState<DeviceForm> with DeviceValidator {
  final _deviceNameKey = GlobalKey<FormFieldState<String>>();

  late final TextEditingController _deviceNameController;
  late final PageController _deviceTypeController;

  final _deviceNameFocusNode = FocusNode();

  late final DeviceFormDelegate _delegate;

  @override
  void initState() {
    super.initState();

    _delegate = DeviceFormDelegate(notifier: ref.read(selectedRiderDevicesProvider.notifier));

    final deviceType = widget.device?.type ?? DeviceType.unknown;

    _deviceNameController = TextEditingController(text: widget.device?.name);
    _deviceTypeController = PageController(initialPage: deviceType.index);
  }

  void onFormSubmitted(BuildContext context) {
    final formState = _deviceNameKey.currentState;

    if (formState == null || !formState.validate()) {
      return;
    }

    final navigator = Navigator.of(context);

    final selectedDeviceType = _deviceTypeController.page!.toInt();

    final model = DeviceModel(
      creationDate: widget.device?.creationDate,
      name: _deviceNameController.text.trim(),
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
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: Text(widget.device == null ? translator.addDevice : translator.editDevice)),
      body: FocusAbsorber(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: CustomScrollView(
            slivers: [
              SliverList(
                delegate: SliverChildListDelegate.fixed([
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: DeviceTypeCarousel(controller: _deviceTypeController, height: 120),
                  ),
                  _buildDeviceNameInput(context),
                  Padding(
                    padding: const EdgeInsets.only(top: 16, bottom: 24),
                    child: Center(child: _buildSubmitButton(context)),
                  ),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIosLayout(BuildContext context) {
    final translator = S.of(context);

    final backgroundColor = CupertinoDynamicColor.resolve(CupertinoColors.systemGroupedBackground, context);

    return CupertinoPageScaffold(
      backgroundColor: backgroundColor,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: backgroundColor,
        border: null,
        middle: Text(widget.device == null ? translator.addDevice : translator.editDevice),
        transitionBetweenRoutes: false,
      ),
      child: SafeArea(
        bottom: false,
        child: FocusAbsorber(
          child: CustomScrollView(
            slivers: [
              SliverList(
                delegate: SliverChildListDelegate.fixed([
                  CupertinoFormSection.insetGrouped(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: DeviceTypeCarousel(controller: _deviceTypeController, height: 120),
                      ),
                    ],
                  ),
                  CupertinoFormSection.insetGrouped(
                    children: [_buildDeviceNameInput(context), _buildSubmitButton(context)],
                  ),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDeviceNameInput(BuildContext context) {
    final translator = S.of(context);

    return PlatformAwareWidget(
      android: (_) {
        return TextFormField(
          key: _deviceNameKey,
          focusNode: _deviceNameFocusNode,
          textInputAction: TextInputAction.done,
          keyboardType: TextInputType.text,
          autocorrect: false,
          controller: _deviceNameController,
          onChanged: _resetSubmit,
          validator: (value) {
            return validateDeviceName(
              value: value,
              requiredMessage: translator.deviceNameRequired,
              maxLengthMessage: translator.deviceNameMaxLength(Device.nameMaxLength),
              illegalCharachterMessage: translator.deviceNameCannotContainComma,
              isBlankMessage: translator.deviceNameBlank,
            );
          },
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 4),
            labelText: translator.deviceName,
            helperText: ' ',
          ),
          autovalidateMode: AutovalidateMode.onUserInteraction,
        );
      },
      ios: (_) {
        return CupertinoTextFormFieldRow(
          key: _deviceNameKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          controller: _deviceNameController,
          focusNode: _deviceNameFocusNode,
          keyboardType: TextInputType.text,
          placeholder: translator.deviceName,
          textInputAction: TextInputAction.done,
          maxLength: Device.nameMaxLength,
          onChanged: _resetSubmit,
          validator: (value) {
            return validateDeviceName(
              value: value,
              requiredMessage: translator.deviceNameRequired,
              maxLengthMessage: translator.deviceNameMaxLength(Device.nameMaxLength),
              illegalCharachterMessage: translator.deviceNameCannotContainComma,
              isBlankMessage: translator.deviceNameBlank,
            );
          },
        );
      },
    );
  }

  Widget _buildErrorMessage(BuildContext context, Object? error) {
    const iOSPadding = EdgeInsetsDirectional.only(start: 20, top: 6, end: 6);

    if (error == null) {
      return const GenericErrorLabel(message: '', iosPadding: iOSPadding);
    }

    final translator = S.of(context);

    if (error is DeviceExistsException) {
      return GenericErrorLabel(message: translator.deviceExists, iosPadding: iOSPadding);
    }

    return GenericErrorLabel(message: translator.genericError, iosPadding: iOSPadding);
  }

  Widget _buildSubmitButton(BuildContext context) {
    final translator = S.of(context);

    final label = widget.device == null ? translator.addDevice : translator.editDevice;

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
    return PlatformAwareWidget(android: _buildAndroidLayout, ios: _buildIosLayout);
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
