import 'package:weforza/model/member_filter_option.dart';

/// This class defines the persistent application settings.
class Settings {
  Settings({
    this.memberListFilter = MemberFilterOption.all,
    this.scanDuration = 20,
  }) : assert(scanDuration > 0);

  factory Settings.of(Map<String, Object?> values) {
    final memberListFilter = values['memberListFilter'] as int?;
    final scanDuration = values['scanDuration'] as int?;

    return Settings(
      memberListFilter: memberListFilter == null
          ? MemberFilterOption.all
          : MemberFilterOption.values[memberListFilter],
      scanDuration: scanDuration ?? 20,
    );
  }

  /// The persisted member list filter.
  final MemberFilterOption memberListFilter;

  /// The duration of a device scan, in seconds.
  /// Defaults to 20 seconds.
  final int scanDuration;

  /// Convert this object to a Map.
  Map<String, dynamic> toMap() {
    return {
      'memberListFilter': memberListFilter.index,
      'scanDuration': scanDuration,
    };
  }
}
