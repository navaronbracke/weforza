
import 'package:flutter/widgets.dart';
import 'package:weforza/blocs/bloc.dart';
import 'package:weforza/model/member.dart';
import 'package:weforza/repository/memberRepository.dart';

///This is the [Bloc] for AddMemberPage.
class AddMemberBloc extends Bloc {
  ///Standard issue constructor.
  ///Takes an [IMemberRepository].
  AddMemberBloc(this._repository): assert(_repository != null);

  ///The [IMemberRepository] that handles the submit.
  final IMemberRepository _repository;

  ///The form text controllers.
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  ///The actual inputs.
  String _firstName;
  String _lastName;
  String _phone;

  ///The actual errors.
  String _firstNameError;
  String _lastNameError;
  String _phoneError;


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
  ///Returns [isRequiredMessage] when  empty or null.
  ///Returns [maxLengthMessage] when too long.
  ///Returns [illegalCharacterMessage] if any illegal character is present.
  ///Returns [isBlankMessage] if the value is whitespace.
  ///Returns null when valid.
  String validateFirstName(String value,String isRequiredMessage,String maxLengthMessage,String illegalCharacterMessage,String isBlankMessage) {
    if(value == null || value.isEmpty)
    {
      _firstNameError = isRequiredMessage;
    }else if(value.trim().isEmpty){
      _firstNameError = isBlankMessage;
    }
    else if(firstNameMaxLength < value.length){
      _firstNameError = maxLengthMessage;
    }
    else if(Member.personNameRegex.hasMatch(value)){
      _firstName = value;
      _firstNameError = null;
    }
    else{
      _firstNameError = illegalCharacterMessage;
    }
    return _firstNameError;
  }

  ///Validate [value] according to the last name rule.
  ///Returns [isRequiredMessage] when  empty or null.
  ///Returns [maxLengthMessage] when too long.
  ///Returns [illegalCharacterMessage] if any illegal character is present.
  ///Returns [isBlankMessage] if the value is whitespace.
  ///Returns null when valid.
  String validateLastName(String value,String isRequiredMessage,String maxLengthMessage,String illegalCharacterMessage,String isBlankMessage) {
    if(value == null || value.isEmpty)
    {
      _lastNameError = isRequiredMessage;
    }else if(value.trim().isEmpty){
      _lastNameError = isBlankMessage;
    }
    else if(lastNameMaxLength < value.length){
      _lastNameError = maxLengthMessage;
    }
    else if(Member.personNameRegex.hasMatch(value)){
      _lastName = value;
      _lastNameError = null;
    }
    else{
      _lastNameError = illegalCharacterMessage;
    }
    return _lastNameError;
  }

  ///Validate [value] according to the phone rule.
  ///Returns [isRequiredMessage] when empty or null.
  ///Returns [illegalCharacterMessage] when the value isn't solely digits.
  ///Returns [minLengthMessage] when the value is too short.
  ///Returns [maxLengthMessage] when the value is too long.
  ///Returns null when valid.
  String validatePhone(String value, String isRequiredMessage, String illegalCharacterMessage,String minLengthMessage,String maxLengthMessage){
    if(value == null || value.isEmpty)
    {
      _phoneError = isRequiredMessage;
    }
    else if(value.length < phoneMinLength){
      _phoneError = minLengthMessage;
    }else if(phoneMaxLength < value.length){
      _phoneError = maxLengthMessage;
    }
    else if(Member.phoneNumberRegex.hasMatch(value)){
      _phone = value;
      _phoneError = null;
    }
    else{
      _phoneError = illegalCharacterMessage;
    }
    return _phoneError;
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
  }
}