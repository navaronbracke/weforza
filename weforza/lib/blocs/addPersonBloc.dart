
import 'package:flutter/widgets.dart';
import 'package:weforza/blocs/bloc.dart';
import 'package:weforza/repository/personRepository.dart';

///This is the [Bloc] for AddPersonPage.
class AddPersonBloc extends Bloc {
  AddPersonBloc(this._repository);

  ///The [IPersonRepository] that handles the submit.
  final IPersonRepository _repository;

  ///The form text controllers.
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  TextEditingController get firstNameController => _firstNameController;
  TextEditingController get lastNameController => _lastNameController;
  TextEditingController get phoneController => _phoneController;

  ///The actual inputs.
  String _firstName;
  String _lastName;
  String _phone;

  ///The actual errors.
  String _firstNameError;
  String _lastNameError;
  String _phoneError;

  ///Auto validation flags per input.
  ///Validation should start once an input came into focus at least once.
  bool autoValidateFirstName = false;
  bool autoValidateLastName = false;
  bool autoValidatePhone = false;

  ///Validate [value] according to the first name rule.
  ///Returns [isRequiredMessage] when  empty or null.
  ///Returns [minLengthMessage] when not long enough.
  ///Returns null when valid.
  String validateFirstName(String value,String isRequiredMessage, String minLengthMessage) {
    if(value == null || value.isEmpty)
    {
      _firstNameError = isRequiredMessage;
    }else if(value.length < 2){
      _firstNameError =  minLengthMessage;
    }else{
      _firstName = value;
      _firstNameError = null;
    }
    return _firstNameError;
  }

  ///Validate [value] according to the last name rule.
  ///Returns [isRequiredMessage] when  empty or null.
  ///Returns [minLengthMessage] when not long enough.
  ///Returns null when valid.
  String validateLastName(String value,String isRequiredMessage, String minLengthMessage) {
    if(value == null || value.isEmpty)
    {
      _lastNameError = isRequiredMessage;
    }else if(value.length < 2){
      _lastNameError = minLengthMessage;
    }
    else{
      _lastName = value;
      _lastNameError = null;
    }
    return _lastNameError;
  }

  ///Validate [value] according to the phone rule.
  ///Returns [isRequiredMessage] when empty or null.
  ///Returns null when valid.
  String validatePhone(String value, String isRequiredMessage){
    if(value == null || value.isEmpty)
    {
      _phoneError = isRequiredMessage;
    }else{
      _phone = value;
      _phoneError = null;
    }
    return _phoneError;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
  }


}