import 'package:collection/collection.dart';
import 'package:weforza/model/rider/rider_filter_option.dart';

/// This class defines the persistent application settings.
class Settings {
  const Settings({Set<String>? excludedTermsFilter, RiderFilterOption? riderListFilter, int? scanDuration})
    : excludedTermsFilter = excludedTermsFilter ?? const {},
      riderListFilter = riderListFilter ?? RiderFilterOption.all,
      scanDuration = scanDuration ?? 20,
      assert(scanDuration == null || scanDuration > 0, 'A scan duration should be greater than zero');

  /// The set of excluded terms that are ignored during a device scan.
  final Set<String> excludedTermsFilter;

  /// The persisted rider list filter.
  final RiderFilterOption riderListFilter;

  /// The duration of a device scan, in seconds.
  /// Defaults to 20 seconds.
  final int scanDuration;

  /// Create a copy of this object, replacing any non-null values.
  Settings copyWith({Set<String>? excludedTermsFilter, RiderFilterOption? riderListFilter, int? scanDuration}) {
    return Settings(
      excludedTermsFilter: excludedTermsFilter ?? this.excludedTermsFilter,
      riderListFilter: riderListFilter ?? this.riderListFilter,
      scanDuration: scanDuration ?? this.scanDuration,
    );
  }

  @override
  int get hashCode {
    return Object.hash(scanDuration, riderListFilter, Object.hashAll(excludedTermsFilter));
  }

  @override
  bool operator ==(Object other) {
    return other is Settings &&
        scanDuration == other.scanDuration &&
        riderListFilter == other.riderListFilter &&
        const SetEquality<String>().equals(excludedTermsFilter, other.excludedTermsFilter);
  }
}
