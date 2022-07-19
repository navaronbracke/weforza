import 'package:weforza/model/member_filter_option.dart';

/// This class defines the persistent application settings.
class Settings {
  Settings({
    this.appVersion = '',
    this.memberListFilter = MemberFilterOption.all,
    this.scanDuration = 20,
  }) : assert(scanDuration > 0);

  /// The current version of the application.
  final String appVersion;

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

  /// Convert the given [values] into a settings object.
  static Settings of(Map<String, dynamic> values) {
    int? memberListFilter = values['memberListFilter'];

    return Settings(
      memberListFilter: memberListFilter == null
          ? MemberFilterOption.all
          : MemberFilterOption.values[memberListFilter],
      scanDuration: values['scanDuration'] ?? 20,
    );
  }
}
