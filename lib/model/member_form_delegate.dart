import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';
import 'package:weforza/exceptions/exceptions.dart';
import 'package:weforza/model/member.dart';
import 'package:weforza/model/member_payload.dart';
import 'package:weforza/riverpod/member/member_list_provider.dart';
import 'package:weforza/riverpod/repository/member_repository_provider.dart';

/// This class represents the delegate for a Member form.
class MemberFormDelegate {
  MemberFormDelegate(this.ref);

  final WidgetRef ref;

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

  Future<void> addMember(MemberPayload model) async {
    _submitController.add(true);

    try {
      final repository = ref.read(memberRepositoryProvider);

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

      ref.refresh(memberListProvider);
    } catch (error) {
      _submitController.addError(error);

      rethrow;
    }
  }

  Future<Member> editMember(MemberPayload model) async {
    _submitController.add(true);

    try {
      final uuid = model.uuid;

      if (uuid == null) {
        throw ArgumentError.notNull('uuid');
      }

      final repository = ref.read(memberRepositoryProvider);

      final exists = await repository.memberExists(
        model.firstName,
        model.lastName,
        model.alias,
        uuid,
      );

      if (exists) {
        throw MemberExistsException();
      }

      final profileImage = await model.profileImage.catchError((error) {
        return Future<File?>.value(null);
      });

      final newMember = Member(
        uuid: uuid,
        firstname: model.firstName,
        lastname: model.lastName,
        alias: model.alias,
        profileImageFilePath: profileImage?.path,
        isActiveMember: model.activeMember,
        lastUpdated: DateTime.now().toUtc(),
      );

      await repository.updateMember(newMember);

      return newMember;
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
