
/// This class is used to wrap the save state for adding or editing a Member.
class SaveMemberOrError {
  SaveMemberOrError({
    required this.saving,
    required this.memberExists,
  });

  SaveMemberOrError.idle(): this(saving: false, memberExists: false);

  SaveMemberOrError.saving(): this(saving: true, memberExists: false);

  SaveMemberOrError.exists(): this(saving: false, memberExists: true);

  /// Whether we are currently saving the data.
  final bool saving;
  /// Whether the given data collides with an existing member.
  final bool memberExists;

}