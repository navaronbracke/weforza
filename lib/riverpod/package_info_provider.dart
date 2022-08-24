import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

final packageInfoProvider = Provider<PackageInfo>((_) {
  throw UnsupportedError('The package info should be preloaded at startup.');
});
