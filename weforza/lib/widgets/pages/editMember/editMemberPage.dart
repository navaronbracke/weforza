import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:weforza/blocs/editMemberBloc.dart';
import 'package:weforza/generated/i18n.dart';
import 'package:weforza/injection/injector.dart';
import 'package:weforza/model/memberItem.dart';
import 'package:weforza/provider/memberProvider.dart';
import 'package:weforza/repository/memberRepository.dart';
import 'package:weforza/theme/appTheme.dart';
import 'package:weforza/widgets/custom/profileImage/iProfileImagePicker.dart';
import 'package:weforza/widgets/custom/profileImage/profileImagePicker.dart';
import 'package:weforza/widgets/custom/profileImage/profileImagePickingState.dart';
import 'package:weforza/widgets/pages/editMember/editMemberSubmit.dart';
import 'package:weforza/widgets/platform/cupertinoFormErrorFormatter.dart';
import 'package:weforza/widgets/platform/orientationAwareWidget.dart';
import 'package:weforza/widgets/platform/platformAwareLoadingIndicator.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

class EditMemberPage extends StatefulWidget {
  @override
  _EditMemberPageState createState() => _EditMemberPageState(
      EditMemberBloc(InjectionContainer.get<MemberRepository>(), MemberProvider.selectedMember)
  );
}

class _EditMemberPageState extends State<EditMemberPage> implements IProfileImagePicker {
  _EditMemberPageState(this._bloc): assert(_bloc != null){
    _firstNameController = TextEditingController(text: _bloc.firstName);
    _lastNameController = TextEditingController(text: _bloc.lastName);
    _phoneController = TextEditingController(text: _bloc.phone);
  }

  ///The key for the form.
  final _formKey = GlobalKey<FormState>();

  ///The BLoC in charge of the form.
  final EditMemberBloc _bloc;

  TextEditingController _firstNameController;
  TextEditingController _lastNameController;
  TextEditingController _phoneController;

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
    return PlatformAwareWidget(
      android: () => OrientationAwareWidget(
        portrait: () => _buildAndroidPortraitLayout(context),
        landscape: () => _buildAndroidLandscapeLayout(context),
      ),
      ios: () => OrientationAwareWidget(
        portrait: () => _buildIOSPortraitLayout(context),
        landscape: () => _buildIOSLandscapeLayout(context),
      ),
    );
  }

  Widget _buildAndroidLandscapeLayout(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).EditMemberTitle),
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
                            autovalidate: _bloc.autoValidateFirstName,
                            onChanged: (value)=> setState(() {
                              _bloc.autoValidateFirstName = true;
                            }),
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
                            autovalidate: _bloc.autoValidateLastName,
                            onChanged: (value)=> setState(() {
                              _bloc.autoValidateLastName = true;
                            }),
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
                              helperText: " ",//Prevent popping up and down after validation
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
                            onChanged: (value)=> setState(() {
                              _bloc.autoValidatePhone = true;
                            }),
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
                                return Center(child: Text(S.of(context).MemberPickImageError,softWrap: true));
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
                          SizedBox(height: 20),
                          EditMemberSubmit(_bloc.submitStream,() async {
                            if (_formKey.currentState.validate()) {
                              await _bloc.editMember((MemberItem updatedMember){
                                MemberProvider.reloadMembers = true;
                                MemberProvider.selectedMember = updatedMember;
                                Navigator.pop(context);
                              });
                            }
                          }),
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

  Widget _buildIOSLandscapeLayout(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(S.of(context).EditMemberTitle),
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
                                textInputAction: TextInputAction.done,
                                controller: _phoneController,
                                autocorrect: false,
                                keyboardType: TextInputType.number,
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
                                    return Center(child: Text(S.of(context).MemberPickImageError,softWrap: true));
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
                              SizedBox(height: 20),
                              EditMemberSubmit(_bloc.submitStream,() async {
                                if (_iosAllFormInputValidator()) {
                                  await _bloc.editMember((MemberItem updatedMember){
                                    MemberProvider.reloadMembers = true;
                                    MemberProvider.selectedMember = updatedMember;
                                    Navigator.pop(context);
                                  });
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

  Widget _buildIOSPortraitLayout(BuildContext context) {
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
                    child: StreamBuilder<ProfileImagePickingState>(
                      initialData: ProfileImagePickingState.IDLE,
                      stream: _bloc.imagePickingStream,
                      builder: (context,snapshot){
                        if(snapshot.hasError){
                          return Text(S.of(context).MemberPickImageError,softWrap: true);
                        }else{
                          return snapshot.data == ProfileImagePickingState.LOADING ? SizedBox(
                            width: 80,
                            height: 80,
                            child: PlatformAwareLoadingIndicator(),
                          ) : ProfileImagePicker(this,_bloc.image,ApplicationTheme.profileImagePlaceholderIconColor,ApplicationTheme.profileImagePlaceholderIconBackgroundColor,100);
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 10),
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
                    textInputAction: TextInputAction.done,
                    controller: _phoneController,
                    autocorrect: false,
                    keyboardType: TextInputType.number,
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
                      child: EditMemberSubmit(_bloc.submitStream,() async {
                        if (_iosAllFormInputValidator()) {
                          await _bloc.editMember((MemberItem updatedMember){
                            MemberProvider.reloadMembers = true;
                            MemberProvider.selectedMember = updatedMember;
                            Navigator.pop(context);
                          });
                        }
                      }),
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

  Widget _buildAndroidPortraitLayout(BuildContext context) {
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
                  child: StreamBuilder<ProfileImagePickingState>(
                    initialData: ProfileImagePickingState.IDLE,
                    stream: _bloc.imagePickingStream,
                    builder: (context,snapshot){
                      if(snapshot.hasError){
                        return Text(S.of(context).MemberPickImageError,softWrap: true);
                      }else{
                        return snapshot.data == ProfileImagePickingState.LOADING ? SizedBox(
                          width: 80,
                          height: 80,
                          child: PlatformAwareLoadingIndicator(),
                        ) : ProfileImagePicker(this,_bloc.image,ApplicationTheme.profileImagePlaceholderIconColor,ApplicationTheme.profileImagePlaceholderIconBackgroundColor,100);
                      }
                    },
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
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
                  autovalidate: _bloc.autoValidateFirstName,
                  onChanged: (value)=> setState(() {
                    _bloc.autoValidateFirstName = true;
                  }),
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
                  autovalidate: _bloc.autoValidateLastName,
                  onChanged: (value)=> setState(() {
                    _bloc.autoValidateLastName = true;
                  }),
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
                    helperText: " ",//Prevent popping up and down after validation
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
                  onChanged: (value)=> setState(() {
                    _bloc.autoValidatePhone = true;
                  }),
                  inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                  onFieldSubmitted: (value){
                    _phoneFocusNode.unfocus();
                  },
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 15, 0, 30),
                  child: Center(
                    child: EditMemberSubmit(_bloc.submitStream,() async {
                      if (_formKey.currentState.validate()) {
                        await _bloc.editMember((MemberItem updatedMember){
                          MemberProvider.reloadMembers = true;
                          MemberProvider.selectedMember = updatedMember;
                          Navigator.pop(context);
                        });
                      }
                    }),
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
