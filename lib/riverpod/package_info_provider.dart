import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// This provider provides the application package information.
///
/// This provider should be overridden with the package info at application startup.
final packageInfoProvider = Provider<PackageInfo>((_) {
  throw UnsupportedError('The package info should be preloaded at startup.');
});
