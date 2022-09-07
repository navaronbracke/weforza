import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/model/device.dart';
import 'package:weforza/model/device_form_delegate.dart';
import 'package:weforza/model/device_payload.dart';
import 'package:weforza/model/device_type.dart';
import 'package:weforza/model/device_validator.dart';
import 'package:weforza/widgets/custom/device_type_carousel.dart';
import 'package:weforza/widgets/pages/device_form/device_form_submit_button.dart';
import 'package:weforza/widgets/platform/cupertino_form_field.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

class DeviceForm extends ConsumerStatefulWidget {
  const DeviceForm({
    Key? key,
    this.device,
    required this.ownerUuid,
  }) : super(key: key);

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

  @override
  void initState() {
    super.initState();

    _delegate = DeviceFormDelegate(ref);
    final deviceType = widget.device?.type ?? DeviceType.unknown;

    _deviceNameController = TextEditingController(text: widget.device?.name);
    _deviceTypeController = PageController(initialPage: deviceType.index);
  }

  /// This function handles the submit of a valid form.
  void _onFormSubmitted(BuildContext context) async {
    final selectedDeviceType = _deviceTypeController.page!.toInt();

    final model = DevicePayload(
      creationDate: widget.device?.creationDate,
      name: _deviceNameController.text,
      ownerId: widget.ownerUuid,
      type: DeviceType.values[selectedDeviceType],
    );

    try {
      if (model.creationDate == null) {
        await _delegate.addDevice(model);
      } else {
        await _delegate.editDevice(model);
      }

      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (_) {
      // Ignore errors, the submit button handles them.
      // Errors are only thrown to not end up in the block after await.
    }
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
        onChanged: _delegate.resetSubmit,
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
        onChanged: _delegate.resetSubmit,
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

  Widget _buildSubmitButton(BuildContext context) {
    final translator = S.of(context);

    final submitButtonLabel =
        widget.device == null ? translator.AddDevice : translator.EditDevice;

    return PlatformAwareWidget(
      android: () => DeviceFormSubmitButton(
        initialData: _delegate.isSubmitting,
        onPressed: () {
          final formState = _formKey.currentState;

          if (formState != null && formState.validate()) {
            _onFormSubmitted(context);
          }
        },
        stream: _delegate.isSubmittingStream,
        submitButtonLabel: submitButtonLabel,
      ),
      ios: () => DeviceFormSubmitButton(
        initialData: _delegate.isSubmitting,
        onPressed: () {
          if (_validateCupertinoForm()) {
            _onFormSubmitted(context);
          }
        },
        stream: _delegate.isSubmittingStream,
        submitButtonLabel: submitButtonLabel,
      ),
    );
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
    _delegate.dispose();
    _deviceNameController.dispose();
    _deviceNameFocusNode.dispose();
    _deviceNameErrorController.close();
    _deviceTypeController.dispose();
    super.dispose();
  }
}
