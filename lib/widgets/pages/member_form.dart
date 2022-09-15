import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weforza/exceptions/exceptions.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/model/member.dart';
import 'package:weforza/model/member_form_delegate.dart';
import 'package:weforza/model/member_payload.dart';
import 'package:weforza/model/member_validator.dart';
import 'package:weforza/model/profile_image_picker_delegate.dart';
import 'package:weforza/riverpod/file_handler_provider.dart';
import 'package:weforza/widgets/common/form_submit_button.dart';
import 'package:weforza/widgets/custom/profile_image/profile_image_picker.dart';
import 'package:weforza/widgets/platform/cupertino_form_field.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

class MemberForm extends ConsumerStatefulWidget {
  const MemberForm({
    super.key,
    this.member,
  });

  /// The member to edit in this form.
  /// If this is null, a new member will be created instead.
  final Member? member;

  @override
  MemberFormState createState() => MemberFormState();
}

class MemberFormState extends ConsumerState<MemberForm> with MemberValidator {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _aliasController;

  final _firstNameErrorController = BehaviorSubject.seeded('');
  final _lastNameErrorController = BehaviorSubject.seeded('');
  final _aliasErrorController = BehaviorSubject.seeded('');

  final _firstNameFocusNode = FocusNode();
  final _lastNameFocusNode = FocusNode();
  final _aliasFocusNode = FocusNode();

  late final MemberFormDelegate _delegate;
  late final ProfileImagePickerDelegate _profileImageDelegate;

  Future<void>? _future;

  /// Validate the iOS form inputs.
  bool _validateCupertinoForm() {
    final firstNameError = _firstNameErrorController.value;
    final lastNameError = _lastNameErrorController.value;
    final aliasError = _aliasErrorController.value;

    return firstNameError.isEmpty &&
        lastNameError.isEmpty &&
        aliasError.isEmpty;
  }

  void onFormSubmitted(BuildContext context) {
    final navigator = Navigator.of(context);
    final memberUuid = widget.member?.uuid;

    final model = MemberPayload(
      activeMember: widget.member?.active ?? true,
      alias: _aliasController.text,
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      profileImage: _profileImageDelegate.image,
      uuid: memberUuid,
    );

    if (memberUuid == null) {
      _future = _delegate.addMember(model).then((_) => navigator.pop());
    } else {
      _future = _delegate.editMember(model).then((_) => navigator.pop());
    }

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    final profileImagePath = widget.member?.profileImageFilePath;

    _profileImageDelegate = ProfileImagePickerDelegate(
      fileHandler: ref.read(fileHandlerProvider),
      currentImage: Future.value(
        profileImagePath == null ? null : File(profileImagePath),
      ),
    );

    _delegate = MemberFormDelegate(ref);

    _firstNameController = TextEditingController(
      text: widget.member?.firstName,
    );
    _lastNameController = TextEditingController(
      text: widget.member?.lastName,
    );
    _aliasController = TextEditingController(
      text: widget.member?.alias,
    );
  }

  Widget _buildAndroidLayout(BuildContext context) {
    final strings = S.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.member == null ? strings.AddMemberTitle : strings.EditMember,
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Column(
              children: <Widget>[
                Center(
                  child: ProfileImagePicker(
                    delegate: _profileImageDelegate,
                    size: 100,
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
                        Member.nameAndAliasMaxLength,
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
                        Member.nameAndAliasMaxLength,
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
                      Member.nameAndAliasMaxLength,
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

  Widget _buildIOSLayout(BuildContext context) {
    final strings = S.of(context);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(
          widget.member == null ? strings.AddMemberTitle : strings.EditMember,
        ),
        transitionBetweenRoutes: false,
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: ProfileImagePicker(
                      delegate: _profileImageDelegate,
                      size: 100,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: CupertinoFormField(
                      textCapitalization: TextCapitalization.words,
                      focusNode: _firstNameFocusNode,
                      textInputAction: TextInputAction.next,
                      controller: _firstNameController,
                      placeholder: strings.FirstName,
                      autocorrect: false,
                      keyboardType: TextInputType.text,
                      errorController: _firstNameErrorController,
                      onChanged: _resetSubmit,
                      validator: (value) => validateFirstOrLastName(
                        value: value,
                        requiredMessage: strings.FirstNameRequired,
                        maxLengthMessage: strings.FirstNameMaxLength(
                          Member.nameAndAliasMaxLength,
                        ),
                        illegalCharachterMessage:
                            strings.FirstNameIllegalCharacters,
                        isBlankMessage: strings.FirstNameBlank,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: CupertinoFormField(
                      textCapitalization: TextCapitalization.words,
                      focusNode: _lastNameFocusNode,
                      textInputAction: TextInputAction.next,
                      controller: _lastNameController,
                      placeholder: strings.LastName,
                      autocorrect: false,
                      keyboardType: TextInputType.text,
                      errorController: _lastNameErrorController,
                      onChanged: _resetSubmit,
                      validator: (value) => validateFirstOrLastName(
                        value: value,
                        requiredMessage: strings.LastNameRequired,
                        maxLengthMessage: strings.LastNameMaxLength(
                          Member.nameAndAliasMaxLength,
                        ),
                        illegalCharachterMessage:
                            strings.LastNameIllegalCharacters,
                        isBlankMessage: strings.LastNameBlank,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: CupertinoFormField(
                      focusNode: _aliasFocusNode,
                      textInputAction: TextInputAction.done,
                      controller: _aliasController,
                      autocorrect: false,
                      keyboardType: TextInputType.text,
                      placeholder: strings.Alias,
                      errorController: _aliasErrorController,
                      onChanged: _resetSubmit,
                      validator: (value) => validateAlias(
                        value: value,
                        maxLengthMessage: strings.AliasMaxLength(
                          Member.nameAndAliasMaxLength,
                        ),
                        illegalCharachterMessage:
                            strings.AliasIllegalCharacters,
                        isBlankMessage: strings.AliasBlank,
                      ),
                      onSubmitted: (value) => _aliasFocusNode.unfocus(),
                    ),
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
      ),
    );
  }

  Widget _buildErrorMessage(Object error, S translator) {
    if (error is MemberExistsException) {
      return Text(translator.MemberAlreadyExists);
    }

    return Text(translator.GenericError);
  }

  Widget _buildSubmitButton(BuildContext context) {
    final translator = S.of(context);

    final submitButtonLabel = widget.member == null
        ? translator.AddMemberSubmit
        : translator.EditMember;

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
      ios: () => _buildIOSLayout(context),
    );
  }

  @override
  void dispose() {
    _profileImageDelegate.dispose();
    _firstNameFocusNode.dispose();
    _lastNameFocusNode.dispose();
    _aliasFocusNode.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _aliasController.dispose();
    _firstNameErrorController.close();
    _lastNameErrorController.close();
    _aliasErrorController.close();
    super.dispose();
  }
}
