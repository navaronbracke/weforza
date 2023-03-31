
import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weforza/blocs/bloc.dart';
import 'package:weforza/model/member.dart';
import 'package:weforza/model/memberItem.dart';
import 'package:weforza/repository/memberRepository.dart';
import 'package:weforza/widgets/custom/profileImage/iProfileImagePicker.dart';

class EditMemberBloc extends Bloc implements IProfileImagePicker {
  EditMemberBloc({
    @required this.repository,
    @required this.profileImage,
    @required this.firstName,
    @required this.lastName,
    @required this.alias,
    @required this.id,
  }): assert(
    repository != null && firstName != null && lastName != null
        && alias != null && id != null
  );

  ///The [IMemberRepository] that handles the submit.
  final MemberRepository repository;

  StreamController<EditMemberSubmitState> _submitStateController = BehaviorSubject();
  Stream<EditMemberSubmitState> get submitStream => _submitStateController.stream;

  StreamController<bool> _imagePickingController = BehaviorSubject();

  @override
  Stream<bool> get stream => _imagePickingController.stream;

  ///The actual inputs.
  String firstName;
  String lastName;
  String alias;
  final String id;
  File profileImage;

  @override
  File get selectedImage => profileImage;

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
    else if(nameAndAliasMaxLength < value.length){
      firstNameError = maxLengthMessage;
    }
    else if(Member.personNameAndAliasRegex.hasMatch(value)){
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
    else if(nameAndAliasMaxLength < value.length){
      lastNameError = maxLengthMessage;
    }
    else if(Member.personNameAndAliasRegex.hasMatch(value)){
      lastName = value;
      lastNameError = null;
    }
    else{
      lastNameError = illegalCharacterMessage;
    }
    return lastNameError;
  }

  String validateAlias(String value,String isRequiredMessage,String maxLengthMessage,String illegalCharacterMessage,String isBlankMessage) {
    if(value != alias){
      //Clear the 'user exists' error when a different input is given
      _submitStateController.add(EditMemberSubmitState.IDLE);
    }
    if(value == null || value.isEmpty)
    {
      aliasError = isRequiredMessage;
    }else if(value.trim().isEmpty){
      aliasError = isBlankMessage;
    }
    else if(nameAndAliasMaxLength < value.length){
      aliasError = maxLengthMessage;
    }
    else if(Member.personNameAndAliasRegex.hasMatch(value)){
      alias = value;
      aliasError = null;
    }
    else{
      aliasError = illegalCharacterMessage;
    }
    return aliasError;
  }

  Future<MemberItem> editMember() async {
    _submitStateController.add(EditMemberSubmitState.SUBMIT);
    final Member newMember = Member(
      id,
      firstName,
      lastName,
      alias,
      profileImage?.path,
    );

    bool exists = await repository.memberExists(firstName, lastName, alias,id).catchError((error){
      _submitStateController.add(EditMemberSubmitState.ERROR);
      return Future.error(EditMemberSubmitState.ERROR);
    });

    if(exists){
      _submitStateController.add(EditMemberSubmitState.MEMBER_EXISTS);
      return Future.error(EditMemberSubmitState.MEMBER_EXISTS);
    }else{
      return await repository.updateMember(newMember).then((_){
        return MemberItem(newMember,profileImage);
      },onError: (error){
        _submitStateController.add(EditMemberSubmitState.ERROR);
        return Future.error(EditMemberSubmitState.ERROR);
      });
    }
  }

  @override
  void pickProfileImage() async {
    _imagePickingController.add(true);
    await repository.chooseProfileImageFromGallery().then((img){
      if(img != null){
        profileImage = img;
      }
      _imagePickingController.add(false);
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
      _imagePickingController.add(true);
      profileImage = null;
      _imagePickingController.add(false);
    }
  }
}

enum EditMemberSubmitState {
  IDLE,SUBMIT,MEMBER_EXISTS,ERROR,
}