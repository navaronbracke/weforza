
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
  String firstNameError;
  String lastNameError;
  String phoneError;

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

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
  }
}