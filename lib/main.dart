import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:weforza/riverpod/package_info_provider.dart';
import 'package:weforza/widgets/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Preload the package info.
  final packageInfo = await PackageInfo.fromPlatform();

  runApp(
    ProviderScope(
      overrides: [
        // Inject the preloaded package info.
        packageInfoProvider.overrideWithValue(packageInfo),
      ],
      child: const WeForzaApp(),
    ),
  );
}
