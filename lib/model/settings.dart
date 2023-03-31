import 'package:weforza/model/memberFilterOption.dart';

///This class defines a wrapper for application settings.
class Settings {
  Settings({
    this.scanDuration = 20,
    this.memberListFilter = MemberFilterOption.ALL,
  }) : assert(scanDuration > 0);

  ///The duration of a device scan, in seconds.
  ///Defaults to 20 seconds
  final int scanDuration;

  //This variable stores the app version string.
  late String appVersion;

  // This variable denotes if there is a ride calendar.
  // It is set separately from the constructor invocation.
  bool hasRideCalendar = false;

  // This variable stores the filter value for the member list.
  final MemberFilterOption memberListFilter;

  ///Convert this object to a Map.
  Map<String, dynamic> toMap() {
    return {
      'scanDuration': scanDuration,
      'memberListFilter': memberListFilter.index,
      // We don't write hasRideCalendar, as this is fetched at runtime.
    };
  }

  static Settings of(Map<String, dynamic> values) {
    int? memberListFilter = values['memberListFilter'];

    return Settings(
      scanDuration: values['scanDuration'] ?? 20,
      memberListFilter: memberListFilter == null
          ? MemberFilterOption.ALL
          : MemberFilterOption.values[memberListFilter],
    );
  }
}
