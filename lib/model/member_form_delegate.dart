import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:weforza/model/async_computation_delegate.dart';
import 'package:weforza/model/member.dart';
import 'package:weforza/model/member_payload.dart';
import 'package:weforza/repository/member_repository.dart';
import 'package:weforza/riverpod/member/member_list_provider.dart';
import 'package:weforza/riverpod/member/selected_member_provider.dart';
import 'package:weforza/riverpod/repository/member_repository_provider.dart';

/// This class represents the delegate for a Member form.
class MemberFormDelegate extends AsyncComputationDelegate<void> {
  MemberFormDelegate(
    this.ref,
  ) : repository = ref.read(memberRepositoryProvider);

  final WidgetRef ref;

  final MemberRepository repository;

  final _uuidGenerator = const Uuid();

  /// Add a new member.
  /// The [whenComplete] function is called if the operation was successful.
  void addMember(
    MemberPayload model, {
    required void Function() whenComplete,
  }) async {
    if (!canStartComputation()) {
      return;
    }

    final member = Member(
      active: true,
      alias: model.alias,
      firstName: model.firstName,
      lastName: model.lastName,
      lastUpdated: DateTime.now(),
      profileImageFilePath: model.profileImage?.path,
      uuid: _uuidGenerator.v4(),
    );

    try {
      await repository.addMember(member);

      if (mounted) {
        ref.invalidate(memberListProvider);
        setDone(null);
        whenComplete();
      }
    } catch (error, stackTrace) {
      setError(error, stackTrace);
    }
  }

  /// Edit an existing member.
  /// The [whenComplete] function is called if the operation was successful.
  void editMember(
    MemberPayload model, {
    required void Function() whenComplete,
  }) async {
    if (!canStartComputation()) {
      return;
    }

    try {
      final uuid = model.uuid;

      if (uuid == null) {
        throw ArgumentError.notNull('uuid');
      }

      final newMember = Member(
        active: model.activeMember,
        alias: model.alias,
        firstName: model.firstName,
        lastName: model.lastName,
        lastUpdated: DateTime.now(),
        profileImageFilePath: model.profileImage?.path,
        uuid: uuid,
      );

      await repository.updateMember(newMember);

      if (mounted) {
        final notifier = ref.read(selectedMemberProvider.notifier);

        // Update the selected member.
        notifier.setSelectedMember(newMember);

        // An item in the list was updated.
        ref.invalidate(memberListProvider);
        setDone(null);
        whenComplete();
      }
    } catch (error, stackTrace) {
      setError(error, stackTrace);
    }
  }
}
