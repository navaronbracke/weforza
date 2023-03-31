import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:weforza/blocs/addMemberBloc.dart';
import 'package:weforza/file/fileHandler.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/repository/memberRepository.dart';
import 'package:weforza/injection/injectionContainer.dart';
import 'package:weforza/theme/appTheme.dart';
import 'package:weforza/widgets/custom/profileImage/profileImagePicker.dart';
import 'package:weforza/widgets/pages/addMember/addMemberSubmit.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';
import 'package:weforza/widgets/platform/cupertinoFormErrorFormatter.dart';
import 'package:weforza/widgets/providers/reloadDataProvider.dart';

///This [Widget] represents the form for adding a member.
class AddMemberPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() =>
      _AddMemberPageState(
        AddMemberBloc(InjectionContainer.get<MemberRepository>()),
          InjectionContainer.get<IFileHandler>()
      );
}

///This is the [State] class for [AddMemberPage].
class _AddMemberPageState extends State<AddMemberPage> {
  _AddMemberPageState(this._bloc, this._fileHandler);

  final IFileHandler _fileHandler;
  ///The key for the form.
  final _formKey = GlobalKey<FormState>();

  ///The BLoC in charge of the form.
  final AddMemberBloc _bloc;

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _aliasController = TextEditingController();

  ///The input labels.
  late String _firstNameLabel;
  late String _lastNameLabel;
  late String _aliasLabel;

  ///Error messages.
  late String _firstNameRequiredMessage;
  late String _lastNameRequiredMessage;
  late String _firstNameMaxLengthMessage;
  late String _firstNameIllegalCharactersMessage;
  late String _firstNameBlankMessage;
  late String _lastNameMaxLengthMessage;
  late String _lastNameIllegalCharactersMessage;
  late String _lastNameBlankMessage;
  late String _aliasMaxLengthMessage;
  late String _aliasIllegalCharactersMessage;
  late String _aliasBlankMessage;

  ///The [FocusNode]s for the inputs
  FocusNode _firstNameFocusNode = FocusNode();
  FocusNode _lastNameFocusNode = FocusNode();
  FocusNode _aliasFocusNode = FocusNode();

  ///Initialize localized strings for the form.
  ///This requires a [BuildContext] for the lookup.
  void _initStrings(BuildContext context) {
    final S translator = S.of(context);
    _firstNameLabel = translator.PersonFirstNameLabel;
    _lastNameLabel = translator.PersonLastNameLabel;
    _aliasLabel = translator.PersonAliasLabel;

    _firstNameRequiredMessage = translator.ValueIsRequired(_firstNameLabel);
    _lastNameRequiredMessage = translator.ValueIsRequired(_lastNameLabel);

    _firstNameMaxLengthMessage =
        translator.FirstNameMaxLength("${_bloc.nameAndAliasMaxLength}");
    _firstNameIllegalCharactersMessage = translator.FirstNameIllegalCharacters;
    _firstNameBlankMessage = translator.FirstNameBlank;

    _lastNameMaxLengthMessage =
        translator.LastNameMaxLength("${_bloc.nameAndAliasMaxLength}");
    _lastNameIllegalCharactersMessage = translator.LastNameIllegalCharacters;
    _lastNameBlankMessage = translator.LastNameBlank;

    _aliasMaxLengthMessage =
        translator.AliasMaxLength("${_bloc.nameAndAliasMaxLength}");
    _aliasIllegalCharactersMessage = translator.AliasIllegalCharacters;
    _aliasBlankMessage = translator.AliasBlank;
  }

  ///Validate all current form input for IOS.
  bool _iosAllFormInputValidator(){
    final firstNameValid =  _bloc.validateFirstName(
        _firstNameController.text,
        _firstNameRequiredMessage,
        _firstNameMaxLengthMessage,
        _firstNameIllegalCharactersMessage,
        _firstNameBlankMessage) == null;
    final lastNameValid = _bloc.validateLastName(
            _lastNameController.text,
            _lastNameRequiredMessage,
            _lastNameMaxLengthMessage,
            _lastNameIllegalCharactersMessage,
            _lastNameBlankMessage) == null;
    final aliasValid = _bloc.validateAlias(
        _aliasController.text,
        _aliasMaxLengthMessage,
        _aliasIllegalCharactersMessage,
        _aliasBlankMessage) == null;
    return firstNameValid && lastNameValid && aliasValid;
  }

  void addMember(BuildContext context) async {
    await _bloc.addMember().then((_){
      ReloadDataProvider.of(context).reloadMembers.value = true;
      Navigator.pop(context);
    }).catchError((e) {
      _bloc.onError(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    _initStrings(context);
    return PlatformAwareWidget(
      android: () => _buildAndroidLayout(context),
      ios: () => _buildIOSLayout(context),
    );
  }

  Widget _buildIOSLayout(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(S.of(context).AddMemberTitle),
        transitionBetweenRoutes: false,
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.all(5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: ProfileImagePicker(
                      initialImage: _bloc.initialImage,
                      fileHandler: _fileHandler,
                      onClearSelectedImage: _bloc.clearSelectedImage,
                      setSelectedImage: _bloc.setSelectedImage,
                      errorMessage: S.of(context).GenericError,
                      size: 100,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: CupertinoTextField(
                      textCapitalization: TextCapitalization.words,
                      focusNode: _firstNameFocusNode,
                      textInputAction: TextInputAction.next,
                      controller: _firstNameController,
                      placeholder: _firstNameLabel,
                      autocorrect: false,
                      keyboardType: TextInputType.text,
                      onChanged: (value) {
                        setState(() {
                          _bloc.validateFirstName(
                              value,
                              _firstNameRequiredMessage,
                              _firstNameMaxLengthMessage,
                              _firstNameIllegalCharactersMessage,
                              _firstNameBlankMessage);
                        });
                      },
                      onSubmitted: (value){
                        _focusChange(context, _firstNameFocusNode, _lastNameFocusNode);
                      },
                    ),
                  ),
                  Text(
                      CupertinoFormErrorFormatter.formatErrorMessage(_bloc.firstNameError),
                      style: ApplicationTheme.iosFormErrorStyle
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: CupertinoTextField(
                      textCapitalization: TextCapitalization.words,
                      focusNode: _lastNameFocusNode,
                      textInputAction: TextInputAction.next,
                      controller: _lastNameController,
                      placeholder: _lastNameLabel,
                      autocorrect: false,
                      keyboardType: TextInputType.text,
                      onChanged: (value) {
                        setState(() {
                          _bloc.validateLastName(
                              value,
                              _lastNameRequiredMessage,
                              _lastNameMaxLengthMessage,
                              _lastNameIllegalCharactersMessage,
                              _lastNameBlankMessage);
                        });
                      },
                      onSubmitted: (value){
                        _focusChange(context, _lastNameFocusNode, _aliasFocusNode);
                      },
                    ),
                  ),
                  Text(
                      CupertinoFormErrorFormatter.formatErrorMessage(_bloc.lastNameError),
                      style: ApplicationTheme.iosFormErrorStyle
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: CupertinoTextField(
                      focusNode: _aliasFocusNode,
                      textInputAction: TextInputAction.done,
                      controller: _aliasController,
                      autocorrect: false,
                      keyboardType: TextInputType.text,
                      placeholder: _aliasLabel,
                      onChanged: (value) {
                        setState(() {
                          _bloc.validateAlias(
                              value,
                              _aliasMaxLengthMessage,
                              _aliasIllegalCharactersMessage,
                              _aliasBlankMessage);
                        });
                      },
                      onSubmitted: (value){
                        _aliasFocusNode.unfocus();
                      },
                    ),
                  ),
                  Text(
                      CupertinoFormErrorFormatter.formatErrorMessage(
                          _bloc.aliasError),
                      style: ApplicationTheme.iosFormErrorStyle),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 15, 0, 30),
                    child: Center(
                      child: AddMemberSubmit(
                          stream: _bloc.submitStream,
                          onPressed: () {
                            if (_iosAllFormInputValidator()) {
                              addMember(context);
                            }
                          }
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAndroidLayout(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).AddMemberTitle),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.all(5),
            child: Column(
              children: <Widget>[
                Center(
                  child: ProfileImagePicker(
                    initialImage: _bloc.initialImage,
                    fileHandler: _fileHandler,
                    onClearSelectedImage: _bloc.clearSelectedImage,
                    setSelectedImage: _bloc.setSelectedImage,
                    errorMessage: S.of(context).GenericError,
                    size: 100,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: TextFormField(
                    textCapitalization: TextCapitalization.words,
                    focusNode: _firstNameFocusNode,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10),
                      labelText: _firstNameLabel,
                      helperText: " ",//Prevent popping up and down after validation
                    ),
                    controller: _firstNameController,
                    autocorrect: false,
                    keyboardType: TextInputType.text,
                    validator: (value) => _bloc.validateFirstName(
                        value,
                        _firstNameRequiredMessage,
                        _firstNameMaxLengthMessage,
                        _firstNameIllegalCharactersMessage,
                        _firstNameBlankMessage),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onFieldSubmitted: (value){
                      _focusChange(context, _firstNameFocusNode, _lastNameFocusNode);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: TextFormField(
                    textCapitalization: TextCapitalization.words,
                    focusNode: _lastNameFocusNode,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10),
                      labelText: _lastNameLabel,
                      helperText: " ",//Prevent popping up and down after validation
                    ),
                    controller: _lastNameController,
                    autocorrect: false,
                    keyboardType: TextInputType.text,
                    validator: (value) => _bloc.validateLastName(
                        value,
                        _lastNameRequiredMessage,
                        _lastNameMaxLengthMessage,
                        _lastNameIllegalCharactersMessage,
                        _lastNameBlankMessage),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onFieldSubmitted: (value){
                      _focusChange(context, _lastNameFocusNode, _aliasFocusNode);
                    },
                  ),
                ),
                TextFormField(
                  focusNode: _aliasFocusNode,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10),
                    labelText: _aliasLabel,
                    helperText: " ",//Prevent popping up and down after validation
                  ),
                  controller: _aliasController,
                  autocorrect: false,
                  keyboardType: TextInputType.text,
                  validator: (value) => _bloc.validateAlias(
                      value,
                      _aliasMaxLengthMessage,
                      _aliasIllegalCharactersMessage,
                      _aliasBlankMessage),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onFieldSubmitted: (value){
                    _aliasFocusNode.unfocus();
                  },
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 15, 0, 30),
                  child: Center(
                    child: AddMemberSubmit(
                        stream: _bloc.submitStream,
                        onPressed: () {
                          final formState = _formKey.currentState;

                          if (formState != null && formState.validate()) {
                            addMember(context);
                          }
                        }
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _focusChange(BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  ///Dispose of this object.
  @override
  void dispose() {
    _bloc.dispose();
    _firstNameFocusNode.dispose();
    _lastNameFocusNode.dispose();
    _aliasFocusNode.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _aliasController.dispose();
    super.dispose();
  }
}
