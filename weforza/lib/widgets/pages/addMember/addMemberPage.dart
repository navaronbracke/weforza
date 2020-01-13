import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:weforza/blocs/addMemberBloc.dart';
import 'package:weforza/repository/memberRepository.dart';
import 'package:weforza/widgets/custom/profileImage/iProfileImagePicker.dart';
import 'package:weforza/generated/i18n.dart';
import 'package:weforza/injection/injector.dart';
import 'package:weforza/theme/appTheme.dart';
import 'package:weforza/widgets/custom/profileImage/profileImagePicker.dart';
import 'package:weforza/widgets/platform/platformAwareLoadingIndicator.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';
import 'package:weforza/widgets/platform/cupertinoFormErrorFormatter.dart';

///This [Widget] represents the form for adding a member.
class AddMemberPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() =>
      _AddMemberPageState(AddMemberBloc(InjectionContainer.get<MemberRepository>()));
}

///This is the [State] class for [AddMemberPage].
class _AddMemberPageState extends State<AddMemberPage>
    implements PlatformAwareWidget, PlatformAndOrientationAwareWidget, IProfileImagePicker {
  _AddMemberPageState(this._bloc): assert(_bloc != null);

  ///The key for the form.
  final _formKey = GlobalKey<FormState>();

  ///The BLoC in charge of the form.
  final AddMemberBloc _bloc;

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  ///The input labels.
  String _firstNameLabel;
  String _lastNameLabel;
  String _phoneLabel;

  ///Error messages.
  String _firstNameRequiredMessage;
  String _lastNameRequiredMessage;
  String _phoneRequiredMessage;
  String _firstNameMaxLengthMessage;
  String _firstNameIllegalCharactersMessage;
  String _firstNameBlankMessage;
  String _lastNameMaxLengthMessage;
  String _lastNameIllegalCharactersMessage;
  String _lastNameBlankMessage;
  String _phoneIllegalCharactersMessage;
  String _phoneMinLengthMessage;
  String _phoneMaxLengthMessage;

  ///The [FocusNode]s for the inputs
  FocusNode _firstNameFocusNode = FocusNode();
  FocusNode _lastNameFocusNode = FocusNode();
  FocusNode _phoneFocusNode = FocusNode();

  ///Initialize localized strings for the form.
  ///This requires a [BuildContext] for the lookup.
  void _initStrings(BuildContext context) {
    final S translator = S.of(context);
    _firstNameLabel = translator.PersonFirstNameLabel;
    _lastNameLabel = translator.PersonLastNameLabel;
    _phoneLabel = translator.PersonTelephoneLabel;

    _firstNameRequiredMessage = translator.ValueIsRequired(_firstNameLabel);
    _lastNameRequiredMessage = translator.ValueIsRequired(_lastNameLabel);
    _phoneRequiredMessage = translator.ValueIsRequired(_phoneLabel);

    _firstNameMaxLengthMessage =
        translator.FirstNameMaxLength("${_bloc.firstNameMaxLength}");
    _firstNameIllegalCharactersMessage = translator.FirstNameIllegalCharacters;
    _firstNameBlankMessage = translator.FirstNameBlank;

    _lastNameMaxLengthMessage =
        translator.LastNameMaxLength("${_bloc.lastNameMaxLength}");
    _lastNameIllegalCharactersMessage = translator.LastNameIllegalCharacters;
    _lastNameBlankMessage = translator.LastNameBlank;

    _phoneIllegalCharactersMessage = translator.PhoneIllegalCharacters;
    _phoneMinLengthMessage =
        translator.PhoneMinLength("${_bloc.phoneMinLength}");
    _phoneMaxLengthMessage =
        translator.PhoneMaxLength("${_bloc.phoneMaxLength}");
  }

  ///Validate all current form input for IOS.
  bool iosAllFormInputValidator(){
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
    final phoneValid = _bloc.validatePhone(
            _phoneController.text,
            _phoneRequiredMessage,
            _phoneIllegalCharactersMessage,
            _phoneMinLengthMessage,
            _phoneMaxLengthMessage) == null;
    return firstNameValid && lastNameValid && phoneValid;
  }

  @override
  Widget build(BuildContext context) {
    _initStrings(context);
    return PlatformAwareWidgetBuilder.build(context, this);
  }

  @override
  Widget buildAndroidWidget(BuildContext context) {
    return OrientationAwareWidgetBuilder.build(
        context,
        buildAndroidPortraitLayout(context),
        buildAndroidLandscapeLayout(context));
  }

  @override
  Widget buildIosWidget(BuildContext context) {
    return OrientationAwareWidgetBuilder.build(context,
        buildIOSPortraitLayout(context), buildIOSLandscapeLayout(context));
  }

  @override
  Widget buildAndroidLandscapeLayout(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).AddMemberTitle),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Form(
              key: _formKey,
              child: Row(
                children: <Widget>[
                  Flexible(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 30),
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            focusNode: _firstNameFocusNode,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(10),
                              labelText: _firstNameLabel,
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
                            autovalidate: _bloc.autoValidateFirstName,
                            onChanged: (value) => setState(
                                () => _bloc.autoValidateFirstName = true),
                            onFieldSubmitted: (value){
                              _focusChange(context,_firstNameFocusNode,_lastNameFocusNode);
                            },
                          ),
                          SizedBox(height: 5),
                          TextFormField(
                            focusNode: _lastNameFocusNode,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(10),
                              labelText: _lastNameLabel,
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
                            autovalidate: _bloc.autoValidateLastName,
                            onChanged: (value) => setState(
                                () => _bloc.autoValidateLastName = true),
                            onFieldSubmitted: (value){
                              _focusChange(context,_lastNameFocusNode,_phoneFocusNode);
                            },
                          ),
                          SizedBox(height: 5),
                          TextFormField(
                            focusNode: _phoneFocusNode,
                            textInputAction: TextInputAction.done,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(10),
                              labelText: _phoneLabel,
                            ),
                            controller: _phoneController,
                            autocorrect: false,
                            keyboardType: TextInputType.phone,
                            validator: (value) => _bloc.validatePhone(
                                value,
                                _phoneRequiredMessage,
                                _phoneIllegalCharactersMessage,
                                _phoneMinLengthMessage,
                                _phoneMaxLengthMessage),
                            autovalidate: _bloc.autoValidatePhone,
                            onChanged: (value) =>
                                setState(() => _bloc.autoValidatePhone = true),
                            inputFormatters: [
                              WhitelistingTextInputFormatter.digitsOnly
                            ],
                            onFieldSubmitted: (value){
                              _phoneFocusNode.unfocus();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          StreamBuilder<ProfileImagePickingState>(
                            initialData: ProfileImagePickingState.IDLE,
                            stream: _bloc.imagePickingStream,
                            builder: (context,snapshot){
                              if(snapshot.hasError){
                                return Center(child: Text(S.of(context).AddMemberPickImageError,softWrap: true));
                              }else{
                                return snapshot.data == ProfileImagePickingState.LOADING ? SizedBox(
                                  width: 80,
                                  height: 80,
                                  child: Center(
                                    child: PlatformAwareLoadingIndicator(),
                                  ),
                                ) : Center(child: ProfileImagePicker(this,_bloc.image,ApplicationTheme.profileImagePlaceholderIconColor,ApplicationTheme.profileImagePlaceholderIconBackgroundColor,75));
                              }
                            },
                          ),
                          SizedBox(height: 20),
                          StreamBuilder<bool>(
                            initialData: false,
                            stream: _bloc.alreadyExistsStream,
                            builder: (context,snapshot){
                              return snapshot.hasError ? Text(S.of(context).AddMemberError) :
                              snapshot.data ? Text(S.of(context).AddMemberAlreadyExists) : Text("");
                            },
                          ),
                          RaisedButton(
                            color: Theme.of(context).primaryColor,
                            child: Text(S.of(context).AddMemberSubmit, style: TextStyle(color: Colors.white)),
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                if(await _bloc.addMember()){
                                  Navigator.pop(context,true);
                                }
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget buildIOSLandscapeLayout(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(S.of(context).AddMemberTitle),
        transitionBetweenRoutes: false,
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _formKey,
                  child: Row(
                    children: <Widget>[
                      Flexible(
                        flex: 4,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 30),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              CupertinoTextField(
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
                                  _focusChange(context,_firstNameFocusNode,_lastNameFocusNode);
                                },
                              ),
                              Text(
                                  CupertinoFormErrorFormatter.formatErrorMessage(
                                      _bloc.firstNameError),
                                  style: ApplicationTheme.iosFormErrorStyle),
                              SizedBox(height: 5),
                              CupertinoTextField(
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
                                  _focusChange(context,_lastNameFocusNode,_phoneFocusNode);
                                },
                              ),
                              Text(
                                  CupertinoFormErrorFormatter.formatErrorMessage(
                                      _bloc.lastNameError),
                                  style: ApplicationTheme.iosFormErrorStyle),
                              SizedBox(height: 5),
                              CupertinoTextField(
                                focusNode: _phoneFocusNode,
                                textInputAction: TextInputAction.unspecified,
                                controller: _phoneController,
                                autocorrect: false,
                                keyboardType: TextInputType.phone,
                                placeholder: _phoneLabel,
                                inputFormatters: [
                                  WhitelistingTextInputFormatter.digitsOnly
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    _bloc.validatePhone(
                                        value,
                                        _phoneRequiredMessage,
                                        _phoneIllegalCharactersMessage,
                                        _phoneMinLengthMessage,
                                        _phoneMaxLengthMessage);
                                  });
                                },
                                onSubmitted: (value){
                                  _phoneFocusNode.unfocus();
                                },
                              ),
                              Text(
                                  CupertinoFormErrorFormatter.formatErrorMessage(
                                      _bloc.phoneError),
                                  style: ApplicationTheme.iosFormErrorStyle),
                            ],
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 3,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              StreamBuilder<ProfileImagePickingState>(
                                initialData: ProfileImagePickingState.IDLE,
                                stream: _bloc.imagePickingStream,
                                builder: (context,snapshot){
                                  if(snapshot.hasError){
                                    return Center(child: Text(S.of(context).AddMemberPickImageError,softWrap: true));
                                  }else{
                                    return snapshot.data == ProfileImagePickingState.LOADING ? SizedBox(
                                      width: 80,
                                      height: 80,
                                      child: Center(
                                        child: PlatformAwareLoadingIndicator(),
                                      ),
                                    ) : Center(child: ProfileImagePicker(this,_bloc.image,ApplicationTheme.profileImagePlaceholderIconColor,ApplicationTheme.profileImagePlaceholderIconBackgroundColor,75));
                                  }
                                },
                              ),
                              SizedBox(height: 20),
                              StreamBuilder<bool>(
                                initialData: false,
                                stream: _bloc.alreadyExistsStream,
                                builder: (context,snapshot){
                                  return snapshot.hasError ? Text(S.of(context).AddMemberError) :
                                  snapshot.data ? Text(S.of(context).AddMemberAlreadyExists) : Text("");
                                },
                              ),
                              CupertinoButton.filled(child: Text(S.of(context).AddMemberSubmit, style: TextStyle(color: Colors.white)),
                                  pressedOpacity: 0.5,
                                  onPressed: () async {
                                    if(iosAllFormInputValidator()){
                                      if(await _bloc.addMember()){
                                        Navigator.pop(context,true);
                                      }
                                    }else{
                                      setState(() {});
                                    }
                                  }),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget buildIOSPortraitLayout(BuildContext context) {
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
                  CupertinoTextField(
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
                  Text(
                      CupertinoFormErrorFormatter.formatErrorMessage(
                          _bloc.firstNameError),
                      style: ApplicationTheme.iosFormErrorStyle),
                  SizedBox(height: 5),
                  CupertinoTextField(
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
                      _focusChange(context, _lastNameFocusNode, _phoneFocusNode);
                    },
                  ),
                  Text(
                      CupertinoFormErrorFormatter.formatErrorMessage(
                          _bloc.lastNameError),
                      style: ApplicationTheme.iosFormErrorStyle),
                  SizedBox(height: 5),
                  CupertinoTextField(
                    focusNode: _phoneFocusNode,
                    textInputAction: TextInputAction.unspecified,
                    controller: _phoneController,
                    autocorrect: false,
                    keyboardType: TextInputType.phone,
                    placeholder: _phoneLabel,
                    inputFormatters: [
                      WhitelistingTextInputFormatter.digitsOnly
                    ],
                    onChanged: (value) {
                      setState(() {
                        _bloc.validatePhone(
                            value,
                            _phoneRequiredMessage,
                            _phoneIllegalCharactersMessage,
                            _phoneMinLengthMessage,
                            _phoneMaxLengthMessage);
                      });
                    },
                    onSubmitted: (value){
                      _phoneFocusNode.unfocus();
                    },
                  ),
                  Text(
                      CupertinoFormErrorFormatter.formatErrorMessage(
                          _bloc.phoneError),
                      style: ApplicationTheme.iosFormErrorStyle),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 15, 0, 30),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          StreamBuilder<ProfileImagePickingState>(
                            initialData: ProfileImagePickingState.IDLE,
                            stream: _bloc.imagePickingStream,
                            builder: (context,snapshot){
                              if(snapshot.hasError){
                                return Center(child: Text(S.of(context).AddMemberPickImageError,softWrap: true));
                              }else{
                                return snapshot.data == ProfileImagePickingState.LOADING ? SizedBox(
                                  width: 80,
                                  height: 80,
                                  child: Center(
                                    child: PlatformAwareLoadingIndicator(),
                                  ),
                                ) : Center(child: ProfileImagePicker(this,_bloc.image,ApplicationTheme.profileImagePlaceholderIconColor,ApplicationTheme.profileImagePlaceholderIconBackgroundColor,75));
                              }
                            },
                          ),
                          SizedBox(height: 5),
                          StreamBuilder<bool>(
                            initialData: false,
                            stream: _bloc.alreadyExistsStream,
                            builder: (context,snapshot){
                              return snapshot.hasError ? Text(S.of(context).AddMemberError) :
                              snapshot.data ? Text(S.of(context).AddMemberAlreadyExists) : Text("");
                            },
                          ),
                          CupertinoButton.filled(child: Text(S.of(context).AddMemberSubmit, style: TextStyle(color: Colors.white)),
                              pressedOpacity: 0.5,
                              onPressed: () async {
                                if(iosAllFormInputValidator()){
                                  if(await _bloc.addMember()){
                                    Navigator.pop(context,true);
                                  }
                                }else{
                                  setState(() {});
                                }
                              }),
                        ],
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

  @override
  Widget buildAndroidPortraitLayout(BuildContext context) {
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
                TextFormField(
                  focusNode: _firstNameFocusNode,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10),
                    labelText: _firstNameLabel,
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
                  autovalidate: _bloc.autoValidateFirstName,
                  onChanged: (value) =>
                      setState(() => _bloc.autoValidateFirstName = true),
                  onFieldSubmitted: (value){
                    _focusChange(context, _firstNameFocusNode, _lastNameFocusNode);
                  },
                ),
                SizedBox(height: 5),
                TextFormField(
                  focusNode: _lastNameFocusNode,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10),
                    labelText: _lastNameLabel,
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
                  autovalidate: _bloc.autoValidateLastName,
                  onChanged: (value) =>
                      setState(() => _bloc.autoValidateLastName = true),
                  onFieldSubmitted: (value){
                    _focusChange(context, _lastNameFocusNode, _phoneFocusNode);
                  },
                ),
                SizedBox(height: 5),
                TextFormField(
                  focusNode: _phoneFocusNode,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10),
                    labelText: _phoneLabel,
                  ),
                  controller: _phoneController,
                  autocorrect: false,
                  keyboardType: TextInputType.phone,
                  validator: (value) => _bloc.validatePhone(
                      value,
                      _phoneRequiredMessage,
                      _phoneIllegalCharactersMessage,
                      _phoneMinLengthMessage,
                      _phoneMaxLengthMessage),
                  autovalidate: _bloc.autoValidatePhone,
                  onChanged: (value) =>
                      setState(() => _bloc.autoValidatePhone = true),
                  inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                  onFieldSubmitted: (value){
                    _phoneFocusNode.unfocus();
                  },
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 15, 0, 30),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        StreamBuilder<ProfileImagePickingState>(
                          initialData: ProfileImagePickingState.IDLE,
                          stream: _bloc.imagePickingStream,
                          builder: (context,snapshot){
                            if(snapshot.hasError){
                              return Center(child: Text(S.of(context).AddMemberPickImageError,softWrap: true));
                            }else{
                              return snapshot.data == ProfileImagePickingState.LOADING ? SizedBox(
                                width: 80,
                                height: 80,
                                child: Center(
                                  child: PlatformAwareLoadingIndicator(),
                                ),
                              ) : Center(child: ProfileImagePicker(this,_bloc.image,ApplicationTheme.profileImagePlaceholderIconColor,ApplicationTheme.profileImagePlaceholderIconBackgroundColor,100));
                            }
                          },
                        ),
                        SizedBox(height: 5),
                        StreamBuilder<bool>(
                          initialData: false,
                          stream: _bloc.alreadyExistsStream,
                          builder: (context,snapshot){
                            return snapshot.hasError ? Text(S.of(context).AddMemberError) :
                            snapshot.data ? Text(S.of(context).AddMemberAlreadyExists) : Text("");
                          },
                        ),
                        RaisedButton(
                          color: Theme.of(context).primaryColor,
                          child: Text(S.of(context).AddMemberSubmit, style: TextStyle(color: Colors.white)),
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              if(await _bloc.addMember()){
                                Navigator.pop(context,true);
                              }
                            }
                          },
                        ),
                      ],
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

  ///See [IProfileImagePicker].
  @override
  Future<void> pickProfileImage() async => await _bloc.pickImage();


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
    _phoneFocusNode.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}
