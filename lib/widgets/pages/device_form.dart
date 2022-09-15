import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weforza/exceptions/exceptions.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/model/device.dart';
import 'package:weforza/model/device_form_delegate.dart';
import 'package:weforza/model/device_payload.dart';
import 'package:weforza/model/device_type.dart';
import 'package:weforza/model/device_validator.dart';
import 'package:weforza/riverpod/member/selected_member_devices_provider.dart';
import 'package:weforza/widgets/common/form_submit_button.dart';
import 'package:weforza/widgets/custom/device_type_carousel.dart';
import 'package:weforza/widgets/platform/cupertino_form_field.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

class DeviceForm extends ConsumerStatefulWidget {
  const DeviceForm({
    super.key,
    this.device,
    required this.ownerUuid,
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

  final _deviceNameErrorController = BehaviorSubject.seeded('');

  final _deviceNameFocusNode = FocusNode();

  late final DeviceFormDelegate _delegate;

  Future<void>? _future;

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
    final navigator = Navigator.of(context);

    final selectedDeviceType = _deviceTypeController.page!.toInt();

    final model = DevicePayload(
      creationDate: widget.device?.creationDate,
      name: _deviceNameController.text,
      ownerId: widget.ownerUuid,
      type: DeviceType.values[selectedDeviceType],
    );

    if (model.creationDate == null) {
      // Notify the animated list that a device was inserted.
      _future = _delegate
          .addDevice(model)
          .then((_) => navigator.pop(true))
          .catchError(Future.error);
    } else {
      _future = _delegate.editDevice(model).catchError(Future.error);
    }

    setState(() {});
  }

  /// Validate the iOS form inputs.
  bool _validateCupertinoForm() {
    return _deviceNameErrorController.value.isEmpty;
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
      android: () => TextFormField(
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
      ios: () => CupertinoFormField(
        controller: _deviceNameController,
        errorController: _deviceNameErrorController,
        focusNode: _deviceNameFocusNode,
        keyboardType: TextInputType.text,
        placeholder: translator.DeviceName,
        textInputAction: TextInputAction.done,
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

  Widget _buildErrorMessage(Object error, S translator) {
    if (error is DeviceExistsException) {
      return Text(translator.DeviceExists);
    }

    return Text(translator.GenericError);
  }

  Widget _buildSubmitButton(BuildContext context) {
    final translator = S.of(context);

    final submitButtonLabel =
        widget.device == null ? translator.AddDevice : translator.EditDevice;

    return PlatformAwareWidget(
      android: () => FormSubmitButton(
        errorMessageBuilder: (error) => _buildErrorMessage(error, translator),
        label: submitButtonLabel,
        future: _future,
        onPressed: () {
          final formState = _formKey.currentState;

          if (formState != null && formState.validate()) {
            onFormSubmitted(context);
          }
        },
      ),
      ios: () => FormSubmitButton(
        errorMessageBuilder: (error) => _buildErrorMessage(error, translator),
        label: submitButtonLabel,
        future: _future,
        onPressed: () {
          if (_validateCupertinoForm()) {
            onFormSubmitted(context);
          }
        },
      ),
    );
  }

  void _resetSubmit(String _) {
    if (_future == null) {
      return;
    }

    setState(() {
      _future = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PlatformAwareWidget(
      android: () => _buildAndroidLayout(context),
      ios: () => _buildIosLayout(context),
    );
  }

  @override
  void dispose() {
    _deviceNameController.dispose();
    _deviceNameFocusNode.dispose();
    _deviceNameErrorController.close();
    _deviceTypeController.dispose();
    super.dispose();
  }
}
