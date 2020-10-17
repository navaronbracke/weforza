
import 'dart:async';
import 'dart:io';

import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';
import 'package:weforza/blocs/bloc.dart';
import 'package:weforza/model/member.dart';
import 'package:weforza/repository/memberRepository.dart';

///This is the [Bloc] for AddMemberPage.
class AddMemberBloc extends Bloc {
  AddMemberBloc(this._repository): assert(_repository != null);

  ///The [IMemberRepository] that handles the submit.
  final MemberRepository _repository;

  ///The instance that will generate uuid's.
  final Uuid _uuidGenerator = Uuid();

  StreamController<AddMemberSubmitState> _submitStateController = BehaviorSubject();
  Stream<AddMemberSubmitState> get submitStream => _submitStateController.stream;

  void onError(Object error) => _submitStateController.addError(error);

  ///The actual inputs.
  String _firstName;
  String _lastName;
  String _alias;
  Future<File> _selectedImage;

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

    bool exists = await _repository.memberExists(_firstName, _lastName, _alias);

    if(exists){
      return Future.error(AddMemberSubmitState.MEMBER_EXISTS);
    }else{
      final File image = await _selectedImage.catchError((err) => null);
      final Member member = Member(
          _uuidGenerator.v4(),
          _firstName,
          _lastName,
          _alias,
          image?.path
      );

      await _repository.addMember(member);
    }
  }

  void clearSelectedImage() => _selectedImage = Future.value(null);
  void setSelectedImage(Future<File> image) => _selectedImage = image;

  ///Dispose of this object.
  @override
  void dispose() {
    _submitStateController.close();
  }
}

///This enum declares the different states for submitting a new [Member].
///[AddMemberSubmitState.IDLE] There is no submit in progress.
///[AddMemberSubmitState.SUBMIT] A submit is in progress.
///[AddMemberSubmitState.MEMBER_EXISTS] A submit failed because a member that matches the given one already exists.
enum AddMemberSubmitState {
  IDLE, SUBMIT, MEMBER_EXISTS
}