
import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';
import 'package:weforza/blocs/bloc.dart';
import 'package:weforza/model/member.dart';
import 'package:weforza/repository/memberRepository.dart';
import 'package:weforza/widgets/custom/profileImage/iProfileImagePicker.dart';
import 'package:weforza/widgets/custom/profileImage/profileImagePickingState.dart';

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
  Stream<ProfileImagePickingState> get stream => _imagePickingController.stream;

  StreamController<ProfileImagePickingState> _imagePickingController = BehaviorSubject();

  ///The actual inputs.
  String _firstName;
  String _lastName;
  String _phone;
  File _selectedImage;

  ///The actual errors.
  String firstNameError;
  String lastNameError;
  String phoneError;

  ///Length ranges for input.
  final int firstNameMaxLength = 50;
  final int lastNameMaxLength = 50;
  final int phoneMaxLength = 15;
  final int phoneMinLength = 8;

  ///Auto validation flags per input.
  ///Validation should start once an input came into focus at least once.
  bool autoValidateFirstName = false;
  bool autoValidateLastName = false;
  bool autoValidatePhone = false;

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
    else if(firstNameMaxLength < value.length){
      firstNameError = maxLengthMessage;
    }
    else if(Member.personNameRegex.hasMatch(value)){
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
    else if(lastNameMaxLength < value.length){
      lastNameError = maxLengthMessage;
    }
    else if(Member.personNameRegex.hasMatch(value)){
      _lastName = value;
      lastNameError = null;
    }
    else{
      lastNameError = illegalCharacterMessage;
    }
    return lastNameError;
  }

  ///Validate [value] according to the phone rule.
  ///Returns null if valid or an error message otherwise.
  ///The return value is ignored on IOS, since only the Material FormValidator uses it to display an error.
  String validatePhone(String value, String isRequiredMessage, String illegalCharacterMessage,String minLengthMessage,String maxLengthMessage){
    if(value != _phone){
      //Clear the 'user exists' error when a different input is given
      _submitStateController.add(AddMemberSubmitState.IDLE);
    }
    if(value == null || value.isEmpty)
    {
      phoneError = isRequiredMessage;
    }
    else if(value.length < phoneMinLength){
      phoneError = minLengthMessage;
    }else if(phoneMaxLength < value.length){
      phoneError = maxLengthMessage;
    }
    else if(Member.phoneNumberRegex.hasMatch(value)){
      _phone = value;
      phoneError = null;
    }
    else{
      phoneError = illegalCharacterMessage;
    }
    return phoneError;
  }

  Future<void> addMember(VoidCallback onSuccess) async {
    _submitStateController.add(AddMemberSubmitState.SUBMIT);
    await _repository.memberExists(_firstName, _lastName, _phone).then((exists) async {
      if(exists){
        _submitStateController.add(AddMemberSubmitState.MEMBER_EXISTS);
      }else{
        await _repository.addMember(Member(_uuidGenerator.v4(),_firstName,_lastName,_phone,(_selectedImage == null) ? null : _selectedImage.path)).then((_){
          onSuccess();
        },onError: (error){
          _submitStateController.add(AddMemberSubmitState.ERROR);
        });
      }
    },onError: (error){
      _submitStateController.add(AddMemberSubmitState.ERROR);
    });
  }

  @override
  void pickProfileImage() async {
    _imagePickingController.add(ProfileImagePickingState.LOADING);
    await _repository.chooseProfileImageFromGallery().then((img){
      _selectedImage = img;
      _imagePickingController.add(ProfileImagePickingState.IDLE);
    },onError: (error){
      _imagePickingController.addError(Exception("Could not pick a profile image"));
    });
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