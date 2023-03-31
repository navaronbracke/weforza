
import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weforza/blocs/bloc.dart';
import 'package:weforza/model/member.dart';
import 'package:weforza/model/memberItem.dart';
import 'package:weforza/repository/memberRepository.dart';
import 'package:weforza/widgets/custom/profileImage/iProfileImagePicker.dart';
import 'package:weforza/widgets/custom/profileImage/profileImagePickingState.dart';

class EditMemberBloc extends Bloc implements IProfileImagePicker {
  EditMemberBloc({
    @required this.repository,
    @required this.profileImage,
    @required this.firstName,
    @required this.lastName,
    @required this.phone,
    @required this.id,
  }): assert(
    repository != null && firstName != null && lastName != null
        && phone != null && id != null
  );

  ///The [IMemberRepository] that handles the submit.
  final MemberRepository repository;

  StreamController<EditMemberSubmitState> _submitStateController = BehaviorSubject();
  Stream<EditMemberSubmitState> get submitStream => _submitStateController.stream;

  StreamController<ProfileImagePickingState> _imagePickingController = BehaviorSubject();

  @override
  Stream<ProfileImagePickingState> get stream => _imagePickingController.stream;

  ///The actual inputs.
  String firstName;
  String lastName;
  String phone;
  final String id;
  File profileImage;

  @override
  File get selectedImage => profileImage;

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
    if(value != firstName){
      //Clear the 'user exists' error when a different input is given
      _submitStateController.add(EditMemberSubmitState.IDLE);
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
      firstName = value;
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
    if(value != lastName){
      //Clear the 'user exists' error when a different input is given
      _submitStateController.add(EditMemberSubmitState.IDLE);
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
      lastName = value;
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
    if(value != phone){
      //Clear the 'user exists' error when a different input is given
      _submitStateController.add(EditMemberSubmitState.IDLE);
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
      phone = value;
      phoneError = null;
    }
    else{
      phoneError = illegalCharacterMessage;
    }
    return phoneError;
  }

  //TODO remove the callback
  Future<void> editMember(void Function(MemberItem updatedMember) onSuccess) async {
    _submitStateController.add(EditMemberSubmitState.SUBMIT);
    final Member newMember = Member(
      id,
      firstName,
      lastName,
      phone,
      profileImage?.path,
    );
    await repository.memberExists(firstName, lastName, phone,id).then((exists) async {
      if(exists){
        _submitStateController.add(EditMemberSubmitState.MEMBER_EXISTS);
      }else{
        await repository.updateMember(newMember).then((_){
          onSuccess(MemberItem(newMember,profileImage));
        },onError: (error){
          _submitStateController.add(EditMemberSubmitState.ERROR);
        });
      }
    },onError: (error){
      _submitStateController.add(EditMemberSubmitState.ERROR);
    });
  }

  @override
  void pickProfileImage() async {
    _imagePickingController.add(ProfileImagePickingState.LOADING);
    await repository.chooseProfileImageFromGallery().then((img){
      if(img != null){
        profileImage = img;
      }
      _imagePickingController.add(ProfileImagePickingState.IDLE);
    },onError: (error){
      _imagePickingController.addError(Exception("Could not pick a profile image"));
    });
  }

  @override
  void dispose() {
    _submitStateController.close();
    _imagePickingController.close();
  }

  @override
  void clearSelectedImage() {
    if(profileImage != null){
      _imagePickingController.add(ProfileImagePickingState.LOADING);
      profileImage = null;
      _imagePickingController.add(ProfileImagePickingState.IDLE);
    }
  }
}

enum EditMemberSubmitState {
  IDLE,SUBMIT,MEMBER_EXISTS,ERROR,
}