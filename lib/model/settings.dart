import 'package:weforza/model/member_filter_option.dart';

/// This class defines the persistent application settings.
class Settings {
  Settings({
    required this.appVersion,
    required this.hasRideCalendar,
    this.memberListFilter = MemberFilterOption.all,
    this.scanDuration = 20,
  }) : assert(scanDuration > 0);

  factory Settings.of(
    Map<String, Object?> values,
    String appVersion,
    bool hasRideCalendar,
  ) {
    final memberListFilter = values['memberListFilter'] as int?;
    final scanDuration = values['scanDuration'] as int?;

    return Settings(
      appVersion: appVersion,
      hasRideCalendar: hasRideCalendar,
      memberListFilter: memberListFilter == null
          ? MemberFilterOption.all
          : MemberFilterOption.values[memberListFilter],
      scanDuration: scanDuration ?? 20,
    );
  }

  /// The current version of the application.
  ///
  /// This value is not persisted, as this is part of the application metadata.
  final String appVersion;

  /// Whether the app has a ride calendar.
  ///
  /// This value is not persisted in the settings, as this is a computed value.
  final bool hasRideCalendar;

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
