import 'package:drift/drift.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/database/database.dart';
import 'package:weforza/database/riders.dart';
import 'package:weforza/exceptions/exceptions.dart';
import 'package:weforza/file/file_uri_parser.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/model/image/profile_image_picker_delegate.dart';
import 'package:weforza/model/rider/rider_form_delegate.dart';
import 'package:weforza/model/rider/rider_validator.dart';
import 'package:weforza/riverpod/file/file_system_provider.dart';
import 'package:weforza/riverpod/image_picker_delegate_provider.dart';
import 'package:weforza/riverpod/repository/rider_repository_provider.dart';
import 'package:weforza/riverpod/rider/rider_list_provider.dart';
import 'package:weforza/riverpod/rider/selected_rider_provider.dart';
import 'package:weforza/widgets/common/focus_absorber.dart';
import 'package:weforza/widgets/common/form_submit_button.dart';
import 'package:weforza/widgets/common/generic_error.dart';
import 'package:weforza/widgets/custom/profile_image/profile_image_picker.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

class RiderForm extends ConsumerStatefulWidget {
  const new({super.key, this.rider});

  /// The rider to edit.
  ///
  /// If this is null, a new rider will be created instead.
  final Rider? rider;

  @override
  ConsumerState<RiderForm> createState() => _RiderFormState();
}

class _RiderFormState extends ConsumerState<RiderForm> with RiderValidator {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _aliasController;

  final _firstNameFocusNode = FocusNode();
  final _lastNameFocusNode = FocusNode();
  final _aliasFocusNode = FocusNode();

  late final RiderFormDelegate _delegate;
  late final ProfileImagePickerDelegate _profileImageDelegate;

  void onFormSubmitted(BuildContext context) {
    final formState = _formKey.currentState;

    if (formState == null || !formState.validate()) {
      return;
    }

    final navigator = Navigator.of(context);
    final riderId = widget.rider?.id;

    final model = RidersCompanion(
      alias: Value(_aliasController.text.trim()),
      firstName: Value(_firstNameController.text.trim()),
      lastName: Value(_lastNameController.text.trim()),
      isActive: Value(widget.rider?.isActive ?? true),
      profileImageUri: Value(_profileImageDelegate.selectedImage.valueOrNull),
      id: riderId == null ? const Value.absent() : Value(riderId),
    );

    if (riderId == null) {
      _delegate.addRider(
        model,
        whenComplete: () {
          // A new item was added to the list.
          ref.invalidate(riderListProvider);
          navigator.pop();
        },
      );
    } else {
      final notifier = ref.read(selectedRiderProvider.notifier);

      _delegate.editRider(
        model,
        whenComplete: (updatedRider) {
          // Update the selected rider.
          notifier.setSelectedRider(updatedRider);

          // An item in the list was updated.
          ref.invalidate(riderListProvider);
          navigator.pop();
        },
      );
    }
  }

  void _resetSubmit(String _) => _delegate.reset();

  Widget _buildErrorMessage(BuildContext context, Object? error) {
    const iOSPadding = EdgeInsetsDirectional.only(start: 20, end: 6);

    if (error == null) {
      return const GenericErrorLabel(message: '', iosPadding: iOSPadding);
    }

    final translator = S.of(context);

    if (error is RiderExistsException) {
      return GenericErrorLabel(message: translator.riderExists, iosPadding: iOSPadding);
    }

    return GenericErrorLabel(message: translator.genericError, iosPadding: iOSPadding);
  }

  @override
  void initState() {
    super.initState();

    _profileImageDelegate = ProfileImagePickerDelegate(
      imagePickerDelegate: ref.read(imagePickerDelegateProvider),
      // TODO: check if file exists
      // see https://github.com/navaronbracke/weforza/issues/423
      initialValue: FileUriParser(ref.read(fileSystemProvider)).validateUri(widget.rider?.profileImageUri),
    );

    _delegate = RiderFormDelegate(repository: ref.read(riderRepositoryProvider));

    _firstNameController = TextEditingController(text: widget.rider?.firstName);
    _lastNameController = TextEditingController(text: widget.rider?.lastName);
    _aliasController = TextEditingController(text: widget.rider?.alias);
  }

  @override
  Widget build(BuildContext context) {
    return PlatformAwareWidget(android: _buildAndroidLayout, ios: _buildIosLayout);
  }

  Widget _buildAndroidLayout(BuildContext context) {
    final strings = S.of(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: Text(widget.rider == null ? strings.newRider : strings.editRider)),
      body: Form(
        key: _formKey,
        child: FocusAbsorber(
          child: Padding(
            padding: const .symmetric(horizontal: 16, vertical: 8),
            child: CustomScrollView(
              slivers: [
                SliverList(
                  delegate: SliverChildListDelegate.fixed([
                    Center(
                      child: Padding(
                        padding: const .symmetric(vertical: 16),
                        child: ProfileImagePicker(
                          delegate: _profileImageDelegate,
                          imagePreviewSize: 100,
                          pickingIndicator: const SizedBox.square(
                            dimension: 64,
                            child: Center(child: CircularProgressIndicator()),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const .only(top: 8),
                      child: TextFormField(
                        textCapitalization: .words,
                        focusNode: _firstNameFocusNode,
                        textInputAction: .next,
                        decoration: InputDecoration(
                          contentPadding: const .all(8),
                          labelText: strings.firstName,
                          // Prevent popping during validation.
                          helperText: ' ',
                        ),
                        controller: _firstNameController,
                        autocorrect: false,
                        keyboardType: .text,
                        onChanged: _resetSubmit,
                        validator: (value) => validateFirstOrLastName(
                          value: value,
                          requiredMessage: strings.firstNameRequired,
                          maxLengthMessage: strings.firstNameMaxLength(Riders.nameAndAliasLength.max),
                          illegalCharachterMessage: strings.firstNameIllegalCharacters,
                          isBlankMessage: strings.firstNameBlank,
                        ),
                        autovalidateMode: .onUserInteraction,
                      ),
                    ),
                    Padding(
                      padding: const .symmetric(vertical: 4),
                      child: TextFormField(
                        textCapitalization: .words,
                        focusNode: _lastNameFocusNode,
                        textInputAction: .next,
                        decoration: InputDecoration(
                          contentPadding: const .all(8),
                          labelText: strings.lastName,
                          // Prevent popping during validation.
                          helperText: ' ',
                        ),
                        controller: _lastNameController,
                        autocorrect: false,
                        keyboardType: .text,
                        onChanged: _resetSubmit,
                        validator: (value) => validateFirstOrLastName(
                          value: value,
                          requiredMessage: strings.lastNameRequired,
                          maxLengthMessage: strings.lastNameMaxLength(Riders.nameAndAliasLength.max),
                          illegalCharachterMessage: strings.lastNameIllegalCharacters,
                          isBlankMessage: strings.lastNameBlank,
                        ),
                        autovalidateMode: .onUserInteraction,
                      ),
                    ),
                    TextFormField(
                      focusNode: _aliasFocusNode,
                      textInputAction: .done,
                      decoration: InputDecoration(
                        contentPadding: const .all(8),
                        labelText: strings.alias,
                        // Prevent popping during validation.
                        helperText: ' ',
                      ),
                      controller: _aliasController,
                      autocorrect: false,
                      keyboardType: .text,
                      onChanged: _resetSubmit,
                      validator: (value) => validateAlias(
                        value: value,
                        maxLengthMessage: strings.aliasMaxLength(Riders.nameAndAliasLength.max),
                        illegalCharachterMessage: strings.aliasIllegalCharacters,
                        isBlankMessage: strings.aliasBlank,
                      ),
                      autovalidateMode: .onUserInteraction,
                      onFieldSubmitted: (value) => _aliasFocusNode.unfocus(),
                    ),
                    Padding(
                      padding: const .only(top: 12, bottom: 24),
                      child: Center(child: _buildSubmitButton(context)),
                    ),
                  ]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIosLayout(BuildContext context) {
    final strings = S.of(context);

    final backgroundColor = CupertinoDynamicColor.resolve(CupertinoColors.systemGroupedBackground, context);

    return CupertinoPageScaffold(
      backgroundColor: backgroundColor,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: backgroundColor,
        border: null,
        middle: Text(widget.rider == null ? strings.newRider : strings.editRider),
        transitionBetweenRoutes: false,
      ),
      child: SafeArea(
        child: Form(
          key: _formKey,
          child: FocusAbsorber(
            child: CustomScrollView(
              slivers: [
                SliverList(
                  delegate: SliverChildListDelegate.fixed([
                    CupertinoFormSection.insetGrouped(
                      children: [
                        Center(
                          child: Padding(
                            padding: const .fromSTEB(20, 6, 6, 6),
                            child: ProfileImagePicker(
                              delegate: _profileImageDelegate,
                              imagePreviewSize: 80,
                              pickingIndicator: const SizedBox.square(
                                dimension: 88,
                                child: Center(child: CupertinoActivityIndicator()),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    CupertinoFormSection.insetGrouped(
                      children: [
                        CupertinoTextFormFieldRow(
                          autovalidateMode: .onUserInteraction,
                          textCapitalization: .words,
                          focusNode: _firstNameFocusNode,
                          textInputAction: .next,
                          controller: _firstNameController,
                          maxLength: Riders.nameAndAliasLength.max,
                          placeholder: strings.firstName,
                          keyboardType: .text,
                          onChanged: _resetSubmit,
                          validator: (value) => validateFirstOrLastName(
                            value: value,
                            requiredMessage: strings.firstNameRequired,
                            maxLengthMessage: strings.firstNameMaxLength(Riders.nameAndAliasLength.max),
                            illegalCharachterMessage: strings.firstNameIllegalCharacters,
                            isBlankMessage: strings.firstNameBlank,
                          ),
                        ),
                        CupertinoTextFormFieldRow(
                          autovalidateMode: .onUserInteraction,
                          textCapitalization: .words,
                          focusNode: _lastNameFocusNode,
                          textInputAction: .next,
                          controller: _lastNameController,
                          maxLength: Riders.nameAndAliasLength.max,
                          placeholder: strings.lastName,
                          keyboardType: .text,
                          onChanged: _resetSubmit,
                          validator: (value) => validateFirstOrLastName(
                            value: value,
                            requiredMessage: strings.lastNameRequired,
                            maxLengthMessage: strings.lastNameMaxLength(Riders.nameAndAliasLength.max),
                            illegalCharachterMessage: strings.lastNameIllegalCharacters,
                            isBlankMessage: strings.lastNameBlank,
                          ),
                        ),
                        CupertinoTextFormFieldRow(
                          autovalidateMode: .onUserInteraction,
                          focusNode: _aliasFocusNode,
                          textInputAction: .done,
                          controller: _aliasController,
                          keyboardType: .text,
                          maxLength: Riders.nameAndAliasLength.max,
                          placeholder: strings.alias,
                          onChanged: _resetSubmit,
                          validator: (value) => validateAlias(
                            value: value,
                            maxLengthMessage: strings.aliasMaxLength(Riders.nameAndAliasLength.max),
                            illegalCharachterMessage: strings.aliasIllegalCharacters,
                            isBlankMessage: strings.aliasBlank,
                          ),
                          onFieldSubmitted: (value) => _aliasFocusNode.unfocus(),
                        ),
                        Padding(padding: const .only(top: 8), child: _buildSubmitButton(context)),
                      ],
                    ),
                  ]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    final translator = S.of(context);

    final submitButtonLabel = widget.rider == null ? translator.addRider : translator.editRider;

    return FormSubmitButton<void>(
      delegate: _delegate,
      errorBuilder: _buildErrorMessage,
      label: submitButtonLabel,
      onPressed: () => onFormSubmitted(context),
    );
  }

  @override
  void dispose() {
    _delegate.dispose();
    _profileImageDelegate.dispose();
    _firstNameFocusNode.dispose();
    _lastNameFocusNode.dispose();
    _aliasFocusNode.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _aliasController.dispose();
    super.dispose();
  }
}
