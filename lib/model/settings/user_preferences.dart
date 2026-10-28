/// @docImport 'package:shared_preferences/shared_preferences.dart';
library;

import 'package:weforza/model/rider/rider_filter_option.dart';

/// The writable user preferences, written and read by [SharedPreferencesAsync].
final class UserPreferences {
  const new _({required this.riderListDisplayMode, required this.scanDuration});

  factory fromValues({RiderFilterOption riderListDisplayMode = .all, int? scanDuration}) {
    final int effectiveScanDuration;

    if (scanDuration == null) {
      effectiveScanDuration = defaultPreferences.scanDuration;
    } else {
      effectiveScanDuration = scanDuration.clamp(minScanDuration, maxScanDuration).toInt();
    }

    return UserPreferences._(riderListDisplayMode: riderListDisplayMode, scanDuration: effectiveScanDuration);
  }

  /// The default rider list display mode.
  ///
  /// Defaults to showing all riders.
  final RiderFilterOption riderListDisplayMode;

  /// The duration of a device scan, in seconds.
  ///
  /// Defaults to 20 seconds.
  final int scanDuration;

  /// The default user preferences.
  static const UserPreferences defaultPreferences = UserPreferences._(riderListDisplayMode: .all, scanDuration: 20);

  /// The maximum scan duration.
  static const double maxScanDuration = 60;

  /// The minimum scan duration.
  static const double minScanDuration = 10;

  /// Create a copy of this object, replacing any non-null values.
  UserPreferences copyWith({RiderFilterOption? riderListDisplayMode, int? scanDuration}) {
    return UserPreferences.fromValues(
      riderListDisplayMode: riderListDisplayMode ?? this.riderListDisplayMode,
      scanDuration: scanDuration ?? this.scanDuration,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is UserPreferences &&
        riderListDisplayMode == other.riderListDisplayMode &&
        scanDuration == other.scanDuration;
  }

  @override
  int get hashCode => Object.hash(riderListDisplayMode, scanDuration);
}
