import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:weforza/model/settings/settings.dart';
import 'package:weforza/riverpod/settings/settings_provider.dart';
import 'package:weforza/riverpod/settings/settings_with_package_info_provider.dart';
import 'package:weforza/widgets/pages/settings/settings_display_page.dart';
import 'package:weforza/widgets/pages/settings/settings_error_page.dart';
import 'package:weforza/widgets/pages/settings/settings_loading_page.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends ConsumerState<SettingsPage> {
  final ScrollController scrollController = ScrollController();

  late final SettingsNotifier settingsDelegate;

  @override
  void initState() {
    super.initState();
    settingsDelegate = ref.read(settingsProvider.notifier);
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<(Settings, PackageInfo)> settingsWithPackageInfo = ref.watch(settingsWithPackageInfoProvider);

    return switch (settingsWithPackageInfo) {
      AsyncLoading<(Settings, PackageInfo)>() => SettingsLoadingPage(scrollController: scrollController),
      AsyncData<(Settings, PackageInfo)>(:final value) => SettingsDisplayPage(
        appVersion: value.$2.version,
        scrollController: scrollController,
        settings: value.$1,
        settingsDelegate: settingsDelegate,
      ),
      AsyncError<(Settings, PackageInfo)>() => SettingsErrorPage(scrollController: scrollController),
    };
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}
