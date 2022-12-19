import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:weforza/extensions/artificial_delay_mixin.dart';
import 'package:weforza/model/member.dart';
import 'package:weforza/model/member_payload.dart';
import 'package:weforza/repository/member_repository.dart';
import 'package:weforza/riverpod/member/member_list_provider.dart';
import 'package:weforza/riverpod/member/selected_member_provider.dart';
import 'package:weforza/riverpod/repository/member_repository_provider.dart';

/// This class represents the delegate for a Member form.
class MemberFormDelegate with ArtificialDelay {
  MemberFormDelegate(
    this.ref,
  ) : repository = ref.read(memberRepositoryProvider);

  final WidgetRef ref;

  final MemberRepository repository;

  final _uuidGenerator = const Uuid();

  /// Add a new member.
  Future<void> addMember(MemberPayload model) async {
    final image = await model.profileImage.catchError(
      (_) => Future<File?>.value(),
    );

    final member = Member(
      active: true,
      alias: model.alias,
      firstName: model.firstName,
      lastName: model.lastName,
      lastUpdated: DateTime.now(),
      profileImageFilePath: image?.path,
      uuid: _uuidGenerator.v4(),
    );

    // Allow the event loop some time to add an error handler.
    // When the database has almost no data, this future completes even before
    // the event loop could schedule a new frame,
    // which results in an unhandled exception in the FutureBuilder.
    //
    // This also gives the loading indicator some time to appear properly.
    await waitForDelay();
    await repository.addMember(member);

    ref.invalidate(memberListProvider);
  }

  /// Edit an existing member.
  Future<void> editMember(MemberPayload model) async {
    final uuid = model.uuid;

    if (uuid == null) {
      return Future.error(ArgumentError.notNull('uuid'));
    }

    final profileImage = await model.profileImage.catchError((error) {
      return Future<File?>.value();
    });

    final newMember = Member(
      active: model.activeMember,
      alias: model.alias,
      firstName: model.firstName,
      lastName: model.lastName,
      lastUpdated: DateTime.now(),
      profileImageFilePath: profileImage?.path,
      uuid: uuid,
    );

    // Allow the event loop some time to add an error handler.
    // When the database has almost no data, this future completes even before
    // the event loop could schedule a new frame,
    // which results in an unhandled exception in the FutureBuilder.
    //
    // This also gives the loading indicator some time to appear properly.
    await waitForDelay();
    await repository.updateMember(newMember);

    final notifier = ref.read(selectedMemberProvider.notifier);

    // Update the selected member.
    notifier.setSelectedMember(newMember);

    // An item in the list was updated.
    ref.invalidate(memberListProvider);
  }
}
