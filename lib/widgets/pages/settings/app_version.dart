import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/riverpod/package_info_provider.dart';

/// This widget represents the app version display.
class AppVersion extends ConsumerWidget {
  const AppVersion({super.key, required this.builder});

  final Widget Function(String version) builder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final packageInfo = ref.watch(packageInfoProvider);

    return builder(packageInfo.version);
  }
}
