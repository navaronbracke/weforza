import 'dart:io';

import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';
import 'package:weforza/exceptions/exceptions.dart';
import 'package:weforza/model/add_member_model.dart';
import 'package:weforza/model/member.dart';
import 'package:weforza/repository/member_repository.dart';
import 'package:weforza/riverpod/member/member_list_provider.dart';

/// This class represents the delegate for a Member form.
class MemberFormDelegate {
  MemberFormDelegate(this.repository, this.memberList);

  final MemberListNotifier memberList;

  final MemberRepository repository;

  /// This controller manages a submit flag.
  /// If the current value is true, the delegate is submitting the form.
  /// If the current value is false, the delegate is idle.
  /// If the current value is an error, the submit failed.
  ///
  /// Once the delegate enters the submitting state,
  /// it does not exit said state upon successful completion.
  /// It is up to the caller of [addMember] or [editMember]
  /// to handle the result of the future.
  final _submitController = BehaviorSubject.seeded(false);

  final _uuidGenerator = const Uuid();

  bool get isSubmitting => _submitController.value;

  Stream<bool> get isSubmittingStream => _submitController;

  Future<void> addMember(AddMemberModel model) async {
    _submitController.add(true);

    try {
      final exists = await repository.memberExists(
        model.firstName,
        model.lastName,
        model.alias,
      );

      if (exists) {
        throw MemberExistsException();
      }

      final image = await model.profileImage.catchError(
        (_) => Future<File?>.value(null),
      );

      final member = Member(
        uuid: _uuidGenerator.v4(),
        firstname: model.firstName,
        lastname: model.lastName,
        alias: model.alias,
        profileImageFilePath: image?.path,
        isActiveMember: true,
        lastUpdated: DateTime.now().toUtc(),
      );

      await repository.addMember(member);

      memberList.getMembers();
    } catch (error) {
      _submitController.addError(error);

      rethrow;
    }
  }

  void resetSubmit(String? _) {
    if (!_submitController.isClosed && _submitController.hasError) {
      _submitController.add(false);
    }
  }

  void dispose() {
    _submitController.close();
  }
}
