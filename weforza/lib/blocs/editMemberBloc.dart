
import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weforza/blocs/bloc.dart';
import 'package:weforza/model/member.dart';
import 'package:weforza/repository/memberRepository.dart';

class EditMemberBloc extends Bloc {
  EditMemberBloc({
    @required this.repository,
    @required this.profileImageFuture,
    @required this.firstName,
    @required this.lastName,
    @required this.alias,
    @required this.id,
  }): assert(
    repository != null && firstName != null && lastName != null
        && alias != null && id != null && profileImageFuture != null
  );

  ///The [IMemberRepository] that handles the submit.
  final MemberRepository repository;

  StreamController<EditMemberSubmitState> _submitStateController = BehaviorSubject();
  Stream<EditMemberSubmitState> get submitStream => _submitStateController.stream;

  void onError(Object error) => _submitStateController.addError(error);

  /// The member's fixed UUID.
  final String id;

  ///The actual inputs.
  String firstName;
  String lastName;
  String alias;
  /// This Future resolves to a profile image.
  /// It starts with a value from the Member List page.
  /// That page starts loading the profile image.
  Future<File> profileImageFuture;

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

  String validateAlias(String value,String maxLengthMessage,String illegalCharacterMessage,String isBlankMessage) {
    if(value != alias){
      //Clear the 'user exists' error when a different input is given
      _submitStateController.add(EditMemberSubmitState.IDLE);
    }
    if(value.isNotEmpty && value.trim().isEmpty){
      aliasError = isBlankMessage;
    }
    else if(nameAndAliasMaxLength < value.length){
      aliasError = maxLengthMessage;
    }
    else if(value.isEmpty || Member.personNameAndAliasRegex.hasMatch(value)){
      alias = value;
      aliasError = null;
    }
    else{
      aliasError = illegalCharacterMessage;
    }
    return aliasError;
  }

  Future<Member> editMember() async {
    _submitStateController.add(EditMemberSubmitState.SUBMIT);
    bool exists = await repository.memberExists(firstName, lastName, alias,id);

    if(exists){
      return Future.error(EditMemberSubmitState.MEMBER_EXISTS);
    }else{
      ///Wait for the File to be resolved.
      ///If it failed do a fallback to null.
      final File profileImage = await profileImageFuture.catchError((error) => null);
      final Member newMember = Member(
        id,
        firstName,
        lastName,
        alias,
        profileImage?.path,
      );

      await repository.updateMember(newMember);

      return newMember;
    }
  }

  void clearSelectedImage() => profileImageFuture = Future.value(null);
  void setSelectedImage(Future<File> image) => profileImageFuture = image;

  @override
  void dispose() {
    _submitStateController.close();
  }
}

enum EditMemberSubmitState {
  IDLE,SUBMIT,MEMBER_EXISTS
}