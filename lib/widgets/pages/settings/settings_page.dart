import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/model/member_filter_option.dart';
import 'package:weforza/model/settings.dart';
import 'package:weforza/riverpod/repository/settings_repository_provider.dart';
import 'package:weforza/riverpod/settings_provider.dart';
import 'package:weforza/widgets/pages/settings/app_version.dart';
import 'package:weforza/widgets/pages/settings/member_list_filter.dart';
import 'package:weforza/widgets/pages/settings/reset_ride_calendar_button.dart';
import 'package:weforza/widgets/pages/settings/scan_duration_option.dart';
import 'package:weforza/widgets/pages/settings/settings_submit.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends ConsumerState<SettingsPage> {
  late final BehaviorSubject<MemberFilterOption> memberFilterController;

  late final BehaviorSubject<double> scanDurationController;

  Future<void>? _saveSettingsFuture;

  Future<void> saveSettings() {
    // Use an artificial delay to make it look smoother.
    return Future.delayed(const Duration(milliseconds: 500), () {
      final newSettings = Settings(
        scanDuration: scanDurationController.value.floor(),
        memberListFilter: memberFilterController.value,
      );

      final repository = ref.read(settingsRepositoryProvider);

      return repository.writeApplicationSettings(newSettings).then((_) {
        if (mounted) {
          ref.read(settingsProvider.notifier).state = newSettings;
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    final settings = ref.read(settingsProvider);

    memberFilterController = BehaviorSubject.seeded(settings.memberListFilter);
    scanDurationController = BehaviorSubject.seeded(
      settings.scanDuration.toDouble(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final translator = S.of(context);

    return PlatformAwareWidget(
      android: () => _buildAndroidWidget(translator),
      ios: () => _buildIosWidget(translator),
    );
  }

  Widget _buildAndroidWidget(S translator) {
    return Scaffold(
      appBar: AppBar(
        title: Text(translator.Settings),
        actions: <Widget>[_buildSubmitButton()],
      ),
      body: _buildBody(translator),
    );
  }

  Widget _buildIosWidget(S translator) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(translator.Settings),
              ),
            ),
            SizedBox(width: 40, child: Center(child: _buildSubmitButton())),
          ],
        ),
        transitionBetweenRoutes: false,
      ),
      child: SafeArea(child: _buildBody(translator)),
    );
  }

  Widget _buildBody(S translator) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ScanDurationOption(
                    initialScanDuration: scanDurationController.value,
                    onChanged: scanDurationController.add,
                    stream: scanDurationController,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: MemberListFilter(
                      initialFilter: memberFilterController.value,
                      onChanged: memberFilterController.add,
                      stream: memberFilterController,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const ResetRideCalendarButton(),
          const AppVersion(),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    // Use a stateful builder to avoid having to rebuild the entire page.
    return StatefulBuilder(
      builder: (context, setState) {
        return SettingsSubmit(
          future: _saveSettingsFuture,
          onSaveSettings: () => setState(() {
            _saveSettingsFuture = saveSettings();
          }),
        );
      },
    );
  }

  @override
  void dispose() {
    memberFilterController.close();
    scanDurationController.close();
    super.dispose();
  }
}
