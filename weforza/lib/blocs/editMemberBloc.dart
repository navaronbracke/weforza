
import 'dart:async';
import 'dart:io';

import 'package:rxdart/rxdart.dart';
import 'package:weforza/blocs/bloc.dart';
import 'package:weforza/model/member.dart';
import 'package:weforza/model/memberItem.dart';
import 'package:weforza/repository/memberRepository.dart';
import 'package:weforza/widgets/custom/profileImage/profileImagePickingState.dart';

class EditMemberBloc extends Bloc {
  EditMemberBloc(this._repository): assert(_repository != null);

  ///The [IMemberRepository] that handles the submit.
  final MemberRepository _repository;

  StreamController<EditMemberSubmitState> _submitStateController = BehaviorSubject();
  Stream<EditMemberSubmitState> get submitStream => _submitStateController.stream;

  StreamController<ProfileImagePickingState> _imagePickingController = BehaviorSubject();
  Stream<ProfileImagePickingState> get imagePickingStream => _imagePickingController.stream;

  ///The actual inputs.
  String _firstName;
  String _lastName;
  String _phone;

  File image;

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
      _phone = value;
      phoneError = null;
    }
    else{
      phoneError = illegalCharacterMessage;
    }
    return phoneError;
  }

  Future<void> editMember(MemberItem oldMember,void Function(MemberItem updatedMember) onSuccess) async {
    _submitStateController.add(EditMemberSubmitState.SUBMIT);
    final Member newMember = Member(
      oldMember.uuid,
      _firstName,
      _lastName,
      _phone,
      (image == null) ? null : image.path,
    );
    //TODO onSuccess -> updates the load flag, the selected item and pops
    await _repository.memberExists(_firstName, _lastName, _phone).then((exists) async {
      if(exists){
        _submitStateController.add(EditMemberSubmitState.MEMBER_EXISTS);
      }else{
        await _repository.updateMember(newMember).then((_){
          onSuccess(MemberItem(newMember,image));
        },onError: (error){
          _submitStateController.add(EditMemberSubmitState.ERROR);
        });
      }
    },onError: (error){
      _submitStateController.add(EditMemberSubmitState.ERROR);
    });
  }

  Future<void> pickImage() async {
    _imagePickingController.add(ProfileImagePickingState.LOADING);
    await _repository.chooseProfileImageFromGallery().then((img){
      image = img;
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
}

enum EditMemberSubmitState {
  IDLE,SUBMIT,MEMBER_EXISTS,ERROR,
}