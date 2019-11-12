import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:weforza/blocs/addMemberBloc.dart';
import 'package:weforza/widgets/custom/profileImage/iProfileImagePicker.dart';
import 'package:weforza/generated/i18n.dart';
import 'package:weforza/injection/injector.dart';
import 'package:weforza/theme/appTheme.dart';
import 'package:weforza/widgets/custom/profileImage/profileImagePicker.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';
import 'package:weforza/widgets/platform/cupertinoFormErrorFormatter.dart';

///This [Widget] represents the form for adding a member.
class AddMemberPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() =>
      _AddMemberPageState(InjectionContainer.get<AddMemberBloc>());
}

///This is the [State] class for [AddMemberPage].
class _AddMemberPageState extends State<AddMemberPage>
    implements PlatformAwareWidget, PlatformAndOrientationAwareWidget, IProfileImagePicker {
  _AddMemberPageState(this._bloc): assert(_bloc != null);

  ///The key for the form.
  final _formKey = GlobalKey<FormState>();

  ///A flag that indicates if a [Member], with the current values, already exists.
  bool _alreadyExists = false;

  ///The BLoC in charge of the form.
  final AddMemberBloc _bloc;

  File _profileImage;

  ///The input labels.
  String _firstNameLabel;
  String _lastNameLabel;
  String _phoneLabel;
  String _pictureLabel;

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
  String _alreadyExistsMessage;

  ///Initialize localized strings for the form.
  ///This requires a [BuildContext] for the lookup.
  void _initStrings(BuildContext context) {
    final S translator = S.of(context);
    _firstNameLabel = translator.PersonFirstNameLabel;
    _lastNameLabel = translator.PersonLastNameLabel;
    _phoneLabel = translator.PersonTelephoneLabel;
    _pictureLabel = translator.AddMemberPictureLabel;

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
    _alreadyExistsMessage = translator.AddMemberAlreadyExists;
  }

  ///Validate all current form input
  bool cupertinoAllFormInputValidator(){
    final firstNameValid =  _bloc.validateFirstName(
        _bloc.firstNameController.text,
        _firstNameRequiredMessage,
        _firstNameMaxLengthMessage,
        _firstNameIllegalCharactersMessage,
        _firstNameBlankMessage) == null;
    final lastNameValid = _bloc.validateLastName(
            _bloc.lastNameController.text,
            _lastNameRequiredMessage,
            _lastNameMaxLengthMessage,
            _lastNameIllegalCharactersMessage,
            _lastNameBlankMessage) == null;
    final phoneValid = _bloc.validatePhone(
            _bloc.phoneController.text,
            _phoneRequiredMessage,
            _phoneIllegalCharactersMessage,
            _phoneMinLengthMessage,
            _phoneMaxLengthMessage) == null;
    return firstNameValid && lastNameValid && phoneValid;
  }

  @override
  void initState() {
    super.initState();
    _initStrings(context);
  }

  @override
  Widget build(BuildContext context) => PlatformAwareWidgetBuilder.build(context, this);

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
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(10),
                              labelText: _firstNameLabel,
                            ),
                            controller: _bloc.firstNameController,
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
                          ),
                          SizedBox(height: 5),
                          TextFormField(
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(10),
                              labelText: _lastNameLabel,
                            ),
                            controller: _bloc.lastNameController,
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
                          ),
                          SizedBox(height: 5),
                          TextFormField(
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(10),
                              labelText: _phoneLabel,
                            ),
                            controller: _bloc.phoneController,
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
                          Text(_pictureLabel, style: TextStyle(fontSize: 16)),
                          ProfileImagePicker(this,_profileImage,Theme.of(context).accentColor,Theme.of(context).primaryColor),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              child: Align(
                alignment: Alignment.center,
                child: Column(
                  children: <Widget>[
                    Visibility(visible: _alreadyExists,child: Text(_alreadyExistsMessage)),
                    SizedBox(height: 10),
                    RaisedButton(
                      color: Theme.of(context).primaryColor,
                      child: Text(S.of(context).AddMemberSubmit,
                          style: TextStyle(color: Colors.white)),
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          _alreadyExists = await _bloc.checkIfExists();
                          setState(() {});
                          if(!_alreadyExists){
                            _bloc.addMember(_getImageFilePath(_profileImage)).then((val){
                              //Go back to member list page
                              Navigator.pop(context);
                            });
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
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 30),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              CupertinoTextField(
                                controller: _bloc.firstNameController,
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
                              ),
                              Text(
                                  CupertinoFormErrorFormatter.formatErrorMessage(
                                      _bloc.firstNameError),
                                  style: ApplicationTheme.iosFormErrorStyle),
                              SizedBox(height: 5),
                              CupertinoTextField(
                                controller: _bloc.lastNameController,
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
                              ),
                              Text(
                                  CupertinoFormErrorFormatter.formatErrorMessage(
                                      _bloc.lastNameError),
                                  style: ApplicationTheme.iosFormErrorStyle),
                              SizedBox(height: 5),
                              CupertinoTextField(
                                controller: _bloc.phoneController,
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
                        flex: 1,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(_pictureLabel, style: TextStyle(fontSize: 16)),
                              ProfileImagePicker(this,_profileImage,CupertinoTheme.of(context).primaryContrastingColor,CupertinoTheme.of(context).primaryColor),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                child: Align(
                  alignment: Alignment.center,
                  child: CupertinoButton.filled(
                    pressedOpacity: 0.5,
                    child: Text(S.of(context).AddMemberSubmit,
                        style: TextStyle(color: Colors.white)),
                    onPressed: () async {
                      //Validate the form before continuing.
                      if(!cupertinoAllFormInputValidator()){
                        setState(() {});
                      }else{
                        _alreadyExists = await _bloc.checkIfExists();
                        setState(() {});
                        if(!_alreadyExists){
                          _bloc.addMember(_getImageFilePath(_profileImage)).then((val){
                            //Go back to member list page
                            Navigator.pop(context);
                          });
                        }
                      }
                    },
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
                    controller: _bloc.firstNameController,
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
                  ),
                  Text(
                      CupertinoFormErrorFormatter.formatErrorMessage(
                          _bloc.firstNameError),
                      style: ApplicationTheme.iosFormErrorStyle),
                  SizedBox(height: 5),
                  CupertinoTextField(
                    controller: _bloc.lastNameController,
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
                  ),
                  Text(
                      CupertinoFormErrorFormatter.formatErrorMessage(
                          _bloc.lastNameError),
                      style: ApplicationTheme.iosFormErrorStyle),
                  SizedBox(height: 5),
                  CupertinoTextField(
                    controller: _bloc.phoneController,
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
                          Text(_pictureLabel, style: TextStyle(fontSize: 16)),
                          ProfileImagePicker(this,_profileImage,CupertinoTheme.of(context).primaryContrastingColor,CupertinoTheme.of(context).primaryColor),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    child: Align(
                      alignment: Alignment.center,
                      child: CupertinoButton.filled(
                        pressedOpacity: 0.5,
                        child: Text(S.of(context).AddMemberSubmit,
                            style: TextStyle(color: Colors.white)),
                        onPressed: () async {
                          //Validate the form before continuing.
                          if(!cupertinoAllFormInputValidator()){
                            setState(() {});
                          }else{
                            _alreadyExists = await _bloc.checkIfExists();
                            setState(() {});
                            if(!_alreadyExists){
                              _bloc.addMember(_getImageFilePath(_profileImage)).then((val){
                                //Go back to member list page
                                Navigator.pop(context);
                              });
                            }
                          }
                        },
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
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10),
                    labelText: _firstNameLabel,
                  ),
                  controller: _bloc.firstNameController,
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
                ),
                SizedBox(height: 5),
                TextFormField(
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10),
                    labelText: _lastNameLabel,
                  ),
                  controller: _bloc.lastNameController,
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
                ),
                SizedBox(height: 5),
                TextFormField(
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10),
                    labelText: _phoneLabel,
                  ),
                  controller: _bloc.phoneController,
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
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 15, 0, 30),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(_pictureLabel, style: TextStyle(fontSize: 16)),
                        ProfileImagePicker(this,_profileImage,Theme.of(context).accentColor,Theme.of(context).primaryColor),
                      ],
                    ),
                  ),
                ),
                Container(
                  child: Align(
                    alignment: Alignment.center,
                    child: RaisedButton(
                      color: Theme.of(context).primaryColor,
                      child: Text(S.of(context).AddMemberSubmit,
                          style: TextStyle(color: Colors.white)),
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          _alreadyExists = await _bloc.checkIfExists();
                          setState(() {});
                          if(!_alreadyExists){
                            _bloc.addMember(_getImageFilePath(_profileImage)).then((val){
                              //Go back to member list page
                              Navigator.pop(context);
                            });
                          }
                        }
                      },
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

  ///Dispose of this object.
  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  ///See [IProfileImagePicker].
  @override
  File getImage() => _profileImage;

  ///See [IProfileImagePicker].
  @override
  Future<void> pickProfileImage() async {
    _profileImage = await FilePicker.getFile(type: FileType.IMAGE);
    setState(() {});
  }

  String _getImageFilePath(File image) => (image == null) ? null : image.path;
}
