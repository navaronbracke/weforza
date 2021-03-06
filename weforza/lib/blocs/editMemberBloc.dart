
import 'dart:async';
import 'dart:io';

import 'package:rxdart/rxdart.dart';
import 'package:weforza/blocs/bloc.dart';
import 'package:weforza/model/member.dart';
import 'package:weforza/model/saveMemberOrError.dart';
import 'package:weforza/repository/memberRepository.dart';

class EditMemberBloc extends Bloc {
  EditMemberBloc({
    required this.repository,
    required this.profileImageFuture,
    required this.firstName,
    required this.lastName,
    required this.alias,
    required this.id,
    required this.isActiveMember,
  });

  ///The [IMemberRepository] that handles the submit.
  final MemberRepository repository;

  StreamController<SaveMemberOrError> _submitStateController = BehaviorSubject();
  Stream<SaveMemberOrError> get submitStream => _submitStateController.stream;

  void onError(Object error) => _submitStateController.addError(error);

  /// The member's fixed UUID.
  final String id;
  /// The member's fixed isActive state.
  /// This is managed elsewhere, therefor it is fixed here.
  final bool isActiveMember;

  ///The actual inputs.
  String firstName;
  String lastName;
  String alias;
  /// This Future resolves to a profile image.
  /// It starts with a value from the Member List page.
  /// That page starts loading the profile image.
  Future<File?> profileImageFuture;

  ///The actual errors.
  String? firstNameError;
  String? lastNameError;
  String? aliasError;

  final int nameAndAliasMaxLength = 50;

  ///Validate [value] according to the first name rule.
  ///Returns null if valid or an error message otherwise.
  ///The return value is ignored on IOS, since only the Material FormValidator uses it to display an error.
  String? validateFirstName(String? value, String isRequiredMessage, String maxLengthMessage, String illegalCharacterMessage, String isBlankMessage) {
    if(value != firstName){
      //Clear the 'user exists' error when a different input is given
      _submitStateController.add(SaveMemberOrError.idle());
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
  String? validateLastName(String? value,String isRequiredMessage,String maxLengthMessage,String illegalCharacterMessage,String isBlankMessage) {
    if(value != lastName){
      //Clear the 'user exists' error when a different input is given
      _submitStateController.add(SaveMemberOrError.idle());
    }
    if(value  == null || value.isEmpty)
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

  String? validateAlias(String? value,String maxLengthMessage,String illegalCharacterMessage,String isBlankMessage) {
    if(value != alias){
      //Clear the 'user exists' error when a different input is given
      _submitStateController.add(SaveMemberOrError.idle());
    }
    if(value == null || value.isNotEmpty && value.trim().isEmpty){
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
    _submitStateController.add(SaveMemberOrError.saving());
    bool exists = await repository.memberExists(firstName, lastName, alias,id);

    if(exists){
      return Future.error(SaveMemberOrError.exists());
    }else{
      ///Wait for the File to be resolved.
      ///If it failed do a fallback to null.
      final File? profileImage = await profileImageFuture.catchError((error){
        return Future<File?>.value(null);
      });

      final Member newMember = Member(
        uuid: id,
        firstname: firstName,
        lastname: lastName,
        alias: alias,
        profileImageFilePath: profileImage?.path,
        isActiveMember: isActiveMember,
        lastUpdated: DateTime.now().toUtc(),
      );

      await repository.updateMember(newMember);

      return newMember;
    }
  }

  void clearSelectedImage() => profileImageFuture = Future.value(null);
  void setSelectedImage(Future<File?> image) => profileImageFuture = image;

  @override
  void dispose() {
    _submitStateController.close();
  }
}