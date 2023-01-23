import 'package:weforza/model/member_filter_option.dart';

/// This class defines the persistent application settings.
class Settings {
  Settings({
    this.excludedTermsFilter = const {},
    this.memberListFilter = MemberFilterOption.all,
    this.scanDuration = 20,
  }) : assert(
          scanDuration > 0,
          'A scan duration should be greater than zero',
        );

  factory Settings.of(Map<String, Object?> values) {
    final excludedTermsFilter = values['excludedTermsFilter'] as List?;
    final memberListFilter = values['memberListFilter'] as int?;
    final scanDuration = values['scanDuration'] as int?;

    return Settings(
      excludedTermsFilter: Set.of(excludedTermsFilter?.cast<String>() ?? []),
      memberListFilter: memberListFilter == null
          ? MemberFilterOption.all
          : MemberFilterOption.values[memberListFilter],
      scanDuration: scanDuration ?? 20,
    );
  }

  /// The set of excluded terms that are ignored during a device scan.
  final Set<String> excludedTermsFilter;

  /// The persisted member list filter.
  final MemberFilterOption memberListFilter;

  /// The duration of a device scan, in seconds.
  /// Defaults to 20 seconds.
  final int scanDuration;

  /// Convert this object to a Map.
  Map<String, dynamic> toMap() {
    return {
      'excludedTermsFilter': excludedTermsFilter.toList(),
      'memberListFilter': memberListFilter.index,
      'scanDuration': scanDuration,
    };
  }
}
