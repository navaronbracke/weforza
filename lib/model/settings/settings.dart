import 'package:collection/collection.dart';
import 'package:weforza/model/rider/rider_filter_option.dart';

/// This class defines the persistent application settings.
class Settings {
  Settings({
    this.excludedTermsFilter = const {},
    this.memberListFilter = RiderFilterOption.all,
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
          ? RiderFilterOption.all
          : RiderFilterOption.values[memberListFilter],
      scanDuration: scanDuration ?? 20,
    );
  }

  /// The set of excluded terms that are ignored during a device scan.
  final Set<String> excludedTermsFilter;

  /// The persisted member list filter.
  final RiderFilterOption memberListFilter;

  /// The duration of a device scan, in seconds.
  /// Defaults to 20 seconds.
  final int scanDuration;

  /// Create a copy of this object, replacing any non-null values.
  Settings copyWith({
    Set<String>? excludedTermsFilter,
    RiderFilterOption? memberListFilter,
    int? scanDuration,
  }) {
    return Settings(
      excludedTermsFilter: excludedTermsFilter ?? this.excludedTermsFilter,
      memberListFilter: memberListFilter ?? this.memberListFilter,
      scanDuration: scanDuration ?? this.scanDuration,
    );
  }

  /// Convert this object to a Map.
  Map<String, dynamic> toMap() {
    return {
      'excludedTermsFilter': excludedTermsFilter.toList(),
      'memberListFilter': memberListFilter.index,
      'scanDuration': scanDuration,
    };
  }

  @override
  int get hashCode {
    return Object.hash(
      scanDuration,
      memberListFilter,
      Object.hashAll(excludedTermsFilter),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is Settings &&
        scanDuration == other.scanDuration &&
        memberListFilter == other.memberListFilter &&
        const SetEquality<String>().equals(
          excludedTermsFilter,
          other.excludedTermsFilter,
        );
  }
}
