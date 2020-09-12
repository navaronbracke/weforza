
import 'dart:async';
import 'dart:io';

import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';
import 'package:weforza/blocs/bloc.dart';
import 'package:weforza/model/member.dart';
import 'package:weforza/repository/memberRepository.dart';
import 'package:weforza/widgets/custom/profileImage/iProfileImagePicker.dart';

///This is the [Bloc] for AddMemberPage.
class AddMemberBloc extends Bloc implements IProfileImagePicker {
  AddMemberBloc(this._repository): assert(_repository != null);

  ///The [IMemberRepository] that handles the submit.
  final MemberRepository _repository;

  ///The instance that will generate uuid's.
  final Uuid _uuidGenerator = Uuid();

  StreamController<AddMemberSubmitState> _submitStateController = BehaviorSubject();
  Stream<AddMemberSubmitState> get submitStream => _submitStateController.stream;

  @override
  Stream<bool> get stream => _imagePickingController.stream;

  StreamController<bool> _imagePickingController = BehaviorSubject();

  ///The actual inputs.
  String _firstName;
  String _lastName;
  String _alias;
  File _selectedImage;

  ///The actual errors.
  String firstNameError;
  String lastNameError;
  String aliasError;

  final int nameAndAliasMaxLength = 50;

  ///Auto validation flags per input.
  ///Validation should start once an input came into focus at least once.
  bool autoValidateFirstName = false;
  bool autoValidateLastName = false;
  bool autoValidateAlias = false;

  ///Validate [value] according to the first name rule.
  ///Returns null if valid or an error message otherwise.
  ///The return value is ignored on IOS, since only the Material FormValidator uses it to display an error.
  String validateFirstName(String value,String isRequiredMessage,String maxLengthMessage,String illegalCharacterMessage,String isBlankMessage) {
    if(value != _firstName){
      //Clear the 'user exists' error when a different input is given
      _submitStateController.add(AddMemberSubmitState.IDLE);
    }
    if(value == null || value.isEmpty)
    {
      firstNameError = isRequiredMessage;
    }else if(value.trim().isEmpty){
      firstNameError = isBlankMessage;
    }
    else if(nameAndAliasMaxLength < value.length){
      firstNameError = maxLengthMessage;
    }
    else if(Member.personNameAndAliasRegex.hasMatch(value)){
      _firstName = value;
      firstNameError = null;
    }
    else{
      firstNameError = illegalCharacterMessage;
    }
    return firstNameError;
  }

  ///Validate [value] according to the last name rule.
  ///Returns null if valid or an error message otherwise.
  ///The return value is ignored on IOS, since only the Material FormValidator uses it to display an error.
  String validateLastName(String value,String isRequiredMessage,String maxLengthMessage,String illegalCharacterMessage,String isBlankMessage) {
    if(value != _lastName){
      //Clear the 'user exists' error when a different input is given
      _submitStateController.add(AddMemberSubmitState.IDLE);
    }
    if(value == null || value.isEmpty)
    {
      lastNameError = isRequiredMessage;
    }else if(value.trim().isEmpty){
      lastNameError = isBlankMessage;
    }
    else if(nameAndAliasMaxLength < value.length){
      lastNameError = maxLengthMessage;
    }
    else if(Member.personNameAndAliasRegex.hasMatch(value)){
      _lastName = value;
      lastNameError = null;
    }
    else{
      lastNameError = illegalCharacterMessage;
    }
    return lastNameError;
  }

  ///Validate [value] according to the alias rule.
  ///Returns null if valid or an error message otherwise.
  ///The return value is ignored on IOS, since only the Material FormValidator uses it to display an error.
  String validateAlias(String value, String maxLengthMessage,String illegalCharacterMessage,String isBlankMessage) {
    if(value != _alias){
      //Clear the 'user exists' error when a different input is given
      _submitStateController.add(AddMemberSubmitState.IDLE);
    }
    if(value.isNotEmpty && value.trim().isEmpty){
      aliasError = isBlankMessage;
    }
    else if(nameAndAliasMaxLength < value.length){
      aliasError = maxLengthMessage;
    }
    else if(value.isEmpty || Member.personNameAndAliasRegex.hasMatch(value)){
      _alias = value;
      aliasError = null;
    }
    else{
      aliasError = illegalCharacterMessage;
    }
    return aliasError;
  }

  Future<void> addMember() async {
    _submitStateController.add(AddMemberSubmitState.SUBMIT);
    await _repository.memberExists(_firstName, _lastName, _alias).then((exists) async {
      if(exists){
        _submitStateController.add(AddMemberSubmitState.MEMBER_EXISTS);
        return Future.error(AddMemberSubmitState.MEMBER_EXISTS);
      }else{
        await _repository.addMember(Member(_uuidGenerator.v4(),_firstName,_lastName,_alias,(_selectedImage == null) ? null : _selectedImage.path)).then((_){
              //the then call will be executed in the submit widget
        },onError: (error){
          _submitStateController.add(AddMemberSubmitState.ERROR);
          return Future.error(AddMemberSubmitState.ERROR);
        });
      }
    },onError: (error){
      _submitStateController.add(AddMemberSubmitState.ERROR);
      return Future.error(AddMemberSubmitState.ERROR);
    });
  }

  @override
  void pickProfileImage() async {
    _imagePickingController.add(true);
    await _repository.chooseProfileImageFromGallery().then((img){
      if(img != null){
        _selectedImage = img;
      }
      _imagePickingController.add(false);
    },onError: (error){
      _imagePickingController.addError(Exception("Could not pick a profile image"));
    });
  }

  @override
  void clearSelectedImage() {
    if(_selectedImage != null){
      _imagePickingController.add(true);
      _selectedImage = null;
      _imagePickingController.add(false);
    }
  }

  ///Dispose of this object.
  @override
  void dispose() {
    _submitStateController.close();
    _imagePickingController.close();
  }

  @override
  File get selectedImage => _selectedImage;
}

///This enum declares the different states for submitting a new [Member].
///[AddMemberSubmitState.IDLE] There is no submit in progress.
///[AddMemberSubmitState.SUBMIT] A submit is in progress.
///[AddMemberSubmitState.ERROR] A submit failed because the member could not be saved.
///[AddMemberSubmitState.MEMBER_EXISTS] A submit failed because a member that matches the given one already exists.
enum AddMemberSubmitState {
  IDLE, SUBMIT, MEMBER_EXISTS, ERROR
}