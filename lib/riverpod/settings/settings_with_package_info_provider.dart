import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:weforza/riverpod/settings/settings_provider.dart';

/// This provider provides both the settings and the package info as a record.
final settingsWithPackageInfoProvider = FutureProvider((ref) async {
  return (ref.watch(settingsProvider.future), PackageInfo.fromPlatform()).wait;
});
