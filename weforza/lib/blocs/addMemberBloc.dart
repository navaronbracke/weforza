
import 'dart:async';
import 'dart:io';

import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';
import 'package:weforza/blocs/bloc.dart';
import 'package:weforza/model/member.dart';
import 'package:weforza/model/saveMemberOrError.dart';
import 'package:weforza/repository/memberRepository.dart';

///This is the [Bloc] for AddMemberPage.
class AddMemberBloc extends Bloc {
  AddMemberBloc(this._repository);

  ///The [IMemberRepository] that handles the submit.
  final MemberRepository _repository;

  ///The instance that will generate uuid's.
  final Uuid _uuidGenerator = Uuid();

  StreamController<SaveMemberOrError> _submitStateController = BehaviorSubject();
  Stream<SaveMemberOrError> get submitStream => _submitStateController.stream;

  void onError(Object error) => _submitStateController.addError(error);

  ///The actual inputs.
  String _firstName = "";
  String _lastName = "";
  String _alias = "";
  Future<File?> _selectedImage = Future.value(null);

  ///The actual errors.
  String? firstNameError;
  String? lastNameError;
  String? aliasError;

  final int nameAndAliasMaxLength = 50;

  ///Validate [value] according to the first name rule.
  ///Returns null if valid or an error message otherwise.
  ///The return value is ignored on IOS, since only the Material FormValidator uses it to display an error.
  String? validateFirstName(String? value, String isRequiredMessage,String maxLengthMessage,String illegalCharacterMessage,String isBlankMessage) {
    if(value != _firstName){
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
  String? validateLastName(String? value, String isRequiredMessage,String maxLengthMessage,String illegalCharacterMessage,String isBlankMessage) {
    if(value != _lastName){
      //Clear the 'user exists' error when a different input is given
      _submitStateController.add(SaveMemberOrError.idle());
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
  String? validateAlias(String? value, String maxLengthMessage,String illegalCharacterMessage,String isBlankMessage) {
    if(value != _alias){
      //Clear the 'user exists' error when a different input is given
      _submitStateController.add(SaveMemberOrError.idle());
    }
    // Only the empty string is a valid blank value.
    // null or only spaces are disallowed.
    if(value == null || value.isNotEmpty && value.trim().isEmpty){
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
    _submitStateController.add(SaveMemberOrError.saving());

    bool exists = await _repository.memberExists(_firstName, _lastName, _alias);

    if(exists){
      return Future.error(SaveMemberOrError.exists());
    }else{
      final File? image = await _selectedImage.catchError((err) => Future<File?>.value(null));
      final Member member = Member(
        uuid: _uuidGenerator.v4(),
        firstname: _firstName,
        lastname: _lastName,
        alias: _alias,
        profileImageFilePath: image?.path,
        isActiveMember: true,
        lastUpdated: DateTime.now().toUtc()
      );

      await _repository.addMember(member);
    }
  }

  Future<File?> get initialImage => _selectedImage;
  void clearSelectedImage() => _selectedImage = Future.value(null);
  void setSelectedImage(Future<File?> image) => _selectedImage = image;

  ///Dispose of this object.
  @override
  void dispose() {
    _submitStateController.close();
  }
}