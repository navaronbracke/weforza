import 'package:collection/collection.dart';
import 'package:weforza/database/database.dart';
import 'package:weforza/model/rider/rider_filter_option.dart';

/// This class defines the persistent application settings.
class Settings {
  const new({Set<ExcludedTerm>? excludedTermsFilter, RiderFilterOption? riderListFilter, int? scanDuration})
    : excludedTermsFilter = excludedTermsFilter ?? const {},
      riderListFilter = riderListFilter ?? defaultRiderListFilter,
      scanDuration = scanDuration ?? defaultScanDuration,
      assert(scanDuration == null || scanDuration > 0, 'A scan duration should be greater than zero');

  /// The set of excluded terms that are ignored during a device scan.
  final Set<ExcludedTerm> excludedTermsFilter;

  /// The persisted rider list filter.
  final RiderFilterOption riderListFilter;

  /// The duration of a device scan, in seconds.
  /// Defaults to 20 seconds.
  final int scanDuration;

  /// The default value for the rider list filter.
  static const RiderFilterOption defaultRiderListFilter = .all;

  /// The default value for the scan duration, in seconds.
  static const int defaultScanDuration = 20;

  /// Create a copy of this object, replacing any non-null values.
  Settings copyWith({Set<ExcludedTerm>? excludedTermsFilter, RiderFilterOption? riderListFilter, int? scanDuration}) {
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
        const SetEquality<ExcludedTerm>().equals(excludedTermsFilter, other.excludedTermsFilter);
  }
}
