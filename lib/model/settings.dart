import 'package:weforza/model/member_filter_option.dart';

///This class defines a wrapper for application settings.
class Settings {
  Settings({
    this.scanDuration = 20,
    this.memberListFilter = MemberFilterOption.all,
    this.appVersion = '',
  }) : assert(scanDuration > 0);

  /// The duration of a device scan, in seconds.
  /// Defaults to 20 seconds
  final int scanDuration;

  /// The app version, as a string.
  final String appVersion;

  /// The persisted member list filter.
  final MemberFilterOption memberListFilter;

  /// Convert this object to a Map.
  Map<String, dynamic> toMap() {
    return {
      'scanDuration': scanDuration,
      'memberListFilter': memberListFilter.index,
    };
  }

  static Settings of(Map<String, dynamic> values) {
    int? memberListFilter = values['memberListFilter'];

    return Settings(
      scanDuration: values['scanDuration'] ?? 20,
      memberListFilter: memberListFilter == null
          ? MemberFilterOption.all
          : MemberFilterOption.values[memberListFilter],
    );
  }
}
