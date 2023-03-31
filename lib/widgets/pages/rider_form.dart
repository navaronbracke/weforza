import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/exceptions/exceptions.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/model/profile_image_picker_delegate.dart';
import 'package:weforza/model/rider/rider.dart';
import 'package:weforza/model/rider/rider_form_delegate.dart';
import 'package:weforza/model/rider/rider_model.dart';
import 'package:weforza/model/rider/rider_validator.dart';
import 'package:weforza/riverpod/file_handler_provider.dart';
import 'package:weforza/riverpod/repository/member_repository_provider.dart';
import 'package:weforza/riverpod/rider/rider_list_provider.dart';
import 'package:weforza/riverpod/rider/selected_rider_provider.dart';
import 'package:weforza/widgets/common/form_submit_button.dart';
import 'package:weforza/widgets/common/generic_error.dart';
import 'package:weforza/widgets/custom/profile_image/profile_image_picker.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

class RiderForm extends ConsumerStatefulWidget {
  const RiderForm({super.key, this.rider});

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
    final riderUuid = widget.rider?.uuid;

    final model = RiderModel(
      active: widget.rider?.active ?? true,
      alias: _aliasController.text,
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      profileImage: _profileImageDelegate.selectedImage.valueOrNull,
      uuid: riderUuid,
    );

    if (riderUuid == null) {
      _delegate.addRider(model, whenComplete: () {
        // A new item was added to the list.
        ref.invalidate(riderListProvider);
        navigator.pop();
      });
    } else {
      final notifier = ref.read(selectedRiderProvider.notifier);

      _delegate.editRider(model, whenComplete: (updatedRider) {
        // Update the selected rider.
        notifier.setSelectedMember(updatedRider);

        // An item in the list was updated.
        ref.invalidate(riderListProvider);
        navigator.pop();
      });
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
      return GenericErrorLabel(
        message: translator.RiderExists,
        iosPadding: iOSPadding,
      );
    }

    return GenericErrorLabel(
      message: translator.GenericError,
      iosPadding: iOSPadding,
    );
  }

  @override
  void initState() {
    super.initState();
    final profileImagePath = widget.rider?.profileImageFilePath;

    final profileImageFile =
        profileImagePath == null ? null : File(profileImagePath);

    _profileImageDelegate = ProfileImagePickerDelegate(
      fileHandler: ref.read(fileHandlerProvider),
      initialValue:
          profileImageFile?.existsSync() ?? false ? profileImageFile : null,
    );

    _delegate = RiderFormDelegate(
      repository: ref.read(memberRepositoryProvider),
    );

    _firstNameController = TextEditingController(
      text: widget.rider?.firstName,
    );
    _lastNameController = TextEditingController(
      text: widget.rider?.lastName,
    );
    _aliasController = TextEditingController(
      text: widget.rider?.alias,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlatformAwareWidget(
      android: _buildAndroidLayout,
      ios: _buildIosLayout,
    );
  }

  Widget _buildAndroidLayout(BuildContext context) {
    final strings = S.of(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          widget.rider == null ? strings.NewRider : strings.EditRider,
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Column(
              children: <Widget>[
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
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
                  padding: const EdgeInsets.only(top: 8),
                  child: TextFormField(
                    textCapitalization: TextCapitalization.words,
                    focusNode: _firstNameFocusNode,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(8),
                      labelText: strings.FirstName,
                      // Prevent popping during validation.
                      helperText: ' ',
                    ),
                    controller: _firstNameController,
                    autocorrect: false,
                    keyboardType: TextInputType.text,
                    onChanged: _resetSubmit,
                    validator: (value) => validateFirstOrLastName(
                      value: value,
                      requiredMessage: strings.FirstNameRequired,
                      maxLengthMessage: strings.FirstNameMaxLength(
                        Rider.nameAndAliasMaxLength,
                      ),
                      illegalCharachterMessage:
                          strings.FirstNameIllegalCharacters,
                      isBlankMessage: strings.FirstNameBlank,
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: TextFormField(
                    textCapitalization: TextCapitalization.words,
                    focusNode: _lastNameFocusNode,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(8),
                      labelText: strings.LastName,
                      // Prevent popping during validation.
                      helperText: ' ',
                    ),
                    controller: _lastNameController,
                    autocorrect: false,
                    keyboardType: TextInputType.text,
                    onChanged: _resetSubmit,
                    validator: (value) => validateFirstOrLastName(
                      value: value,
                      requiredMessage: strings.LastNameRequired,
                      maxLengthMessage: strings.LastNameMaxLength(
                        Rider.nameAndAliasMaxLength,
                      ),
                      illegalCharachterMessage:
                          strings.LastNameIllegalCharacters,
                      isBlankMessage: strings.LastNameBlank,
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                ),
                TextFormField(
                  focusNode: _aliasFocusNode,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(8),
                    labelText: strings.Alias,
                    // Prevent popping during validation.
                    helperText: ' ',
                  ),
                  controller: _aliasController,
                  autocorrect: false,
                  keyboardType: TextInputType.text,
                  onChanged: _resetSubmit,
                  validator: (value) => validateAlias(
                    value: value,
                    maxLengthMessage: strings.AliasMaxLength(
                      Rider.nameAndAliasMaxLength,
                    ),
                    illegalCharachterMessage: strings.AliasIllegalCharacters,
                    isBlankMessage: strings.AliasBlank,
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onFieldSubmitted: (value) => _aliasFocusNode.unfocus(),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 12, bottom: 24),
                  child: Center(child: _buildSubmitButton(context)),
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

    final backgroundColor = CupertinoDynamicColor.resolve(
      CupertinoColors.systemGroupedBackground,
      context,
    );

    return CupertinoPageScaffold(
      backgroundColor: backgroundColor,
      resizeToAvoidBottomInset: false,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: backgroundColor,
        border: null,
        middle: Text(
          widget.rider == null ? strings.NewRider : strings.EditRider,
        ),
        transitionBetweenRoutes: false,
      ),
      child: SafeArea(
        child: Form(
          key: _formKey,
          child: CustomScrollView(
            slivers: [
              SliverList(
                delegate: SliverChildListDelegate.fixed([
                  CupertinoFormSection.insetGrouped(
                    children: [
                      Center(
                        child: Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(20, 6, 6, 6),
                          child: ProfileImagePicker(
                            delegate: _profileImageDelegate,
                            imagePreviewSize: 80,
                            pickingIndicator: const SizedBox.square(
                              dimension: 88,
                              child: Center(
                                child: CupertinoActivityIndicator(),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  CupertinoFormSection.insetGrouped(
                    children: [
                      CupertinoTextFormFieldRow(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        textCapitalization: TextCapitalization.words,
                        focusNode: _firstNameFocusNode,
                        textInputAction: TextInputAction.next,
                        controller: _firstNameController,
                        maxLength: Rider.nameAndAliasMaxLength,
                        placeholder: strings.FirstName,
                        keyboardType: TextInputType.text,
                        onChanged: _resetSubmit,
                        validator: (value) => validateFirstOrLastName(
                          value: value,
                          requiredMessage: strings.FirstNameRequired,
                          maxLengthMessage: strings.FirstNameMaxLength(
                            Rider.nameAndAliasMaxLength,
                          ),
                          illegalCharachterMessage:
                              strings.FirstNameIllegalCharacters,
                          isBlankMessage: strings.FirstNameBlank,
                        ),
                      ),
                      CupertinoTextFormFieldRow(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        textCapitalization: TextCapitalization.words,
                        focusNode: _lastNameFocusNode,
                        textInputAction: TextInputAction.next,
                        controller: _lastNameController,
                        maxLength: Rider.nameAndAliasMaxLength,
                        placeholder: strings.LastName,
                        keyboardType: TextInputType.text,
                        onChanged: _resetSubmit,
                        validator: (value) => validateFirstOrLastName(
                          value: value,
                          requiredMessage: strings.LastNameRequired,
                          maxLengthMessage: strings.LastNameMaxLength(
                            Rider.nameAndAliasMaxLength,
                          ),
                          illegalCharachterMessage:
                              strings.LastNameIllegalCharacters,
                          isBlankMessage: strings.LastNameBlank,
                        ),
                      ),
                      CupertinoTextFormFieldRow(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        focusNode: _aliasFocusNode,
                        textInputAction: TextInputAction.done,
                        controller: _aliasController,
                        keyboardType: TextInputType.text,
                        maxLength: Rider.nameAndAliasMaxLength,
                        placeholder: strings.Alias,
                        onChanged: _resetSubmit,
                        validator: (value) => validateAlias(
                          value: value,
                          maxLengthMessage: strings.AliasMaxLength(
                            Rider.nameAndAliasMaxLength,
                          ),
                          illegalCharachterMessage:
                              strings.AliasIllegalCharacters,
                          isBlankMessage: strings.AliasBlank,
                        ),
                        onFieldSubmitted: (value) => _aliasFocusNode.unfocus(),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: _buildSubmitButton(context),
                      ),
                    ],
                  ),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    final translator = S.of(context);

    final submitButtonLabel =
        widget.rider == null ? translator.AddRider : translator.EditRider;

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
