import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weforza/extensions/artificial_delay_mixin.dart';
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
  const SettingsPage({super.key});

  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends ConsumerState<SettingsPage>
    with ArtificialDelay {
  late final BehaviorSubject<MemberFilterOption> memberFilterController;

  late final BehaviorSubject<double> scanDurationController;

  Future<void>? _saveSettingsFuture;

  Future<void> saveSettings() async {
    // Use an artificial delay to give the loading indicator some time to appear.
    await waitForDelay();

    final newSettings = Settings(
      scanDuration: scanDurationController.value.floor(),
      memberListFilter: memberFilterController.value,
    );

    final repository = ref.read(settingsRepositoryProvider);

    await repository.write(newSettings);

    if (mounted) {
      ref.read(settingsProvider.notifier).state = newSettings;
    }
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
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(translator.Settings),
        actions: <Widget>[_buildSubmitButton()],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: ScanDurationOption(
                        initialValue: scanDurationController.value,
                        onChanged: scanDurationController.add,
                        stream: scanDurationController,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 16, 12, 8),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            translator.RiderListFilter,
                            style: textTheme.titleMedium,
                          ),
                          MemberListFilter(
                            initialFilter: memberFilterController.value,
                            onChanged: memberFilterController.add,
                            stream: memberFilterController,
                          ),
                          Text(
                            translator.RiderListFilterDescription,
                            style: textTheme.bodySmall?.copyWith(
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 24, left: 12, right: 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const ResetRideCalendarButton(),
                  Text(
                    translator.ResetRideCalendarDescription,
                    style: textTheme.bodySmall?.copyWith(
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            AppVersion(
              builder: (version) => Text(
                '${translator.Version} $version',
                style: textTheme.bodySmall?.copyWith(
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIosWidget(S translator) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      child: CustomScrollView(
        slivers: [
          CupertinoSliverNavigationBar(
            backgroundColor: CupertinoColors.systemGroupedBackground,
            border: null,
            largeTitle: Text(translator.Settings),
            transitionBetweenRoutes: false,
            trailing: SizedBox(
              width: 40,
              child: Center(child: _buildSubmitButton()),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                switch (index) {
                  case 0:
                    return CupertinoFormSection.insetGrouped(
                      header: Text(translator.ScanSettings.toUpperCase()),
                      children: [
                        ScanDurationOption(
                          initialValue: scanDurationController.value,
                          onChanged: scanDurationController.add,
                          stream: scanDurationController,
                        ),
                      ],
                    );
                  case 1:
                    return CupertinoFormSection.insetGrouped(
                      header: Text(translator.Riders.toUpperCase()),
                      footer: Text(translator.RiderListFilterDescription),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(6),
                          child: Center(
                            child: MemberListFilter(
                              initialFilter: memberFilterController.value,
                              onChanged: memberFilterController.add,
                              stream: memberFilterController,
                            ),
                          ),
                        ),
                      ],
                    );
                  case 2:
                    return CupertinoFormSection.insetGrouped(
                      header: Text(translator.RideCalendar.toUpperCase()),
                      footer: Text(translator.ResetRideCalendarDescription),
                      children: const [
                        CupertinoFormRow(
                          padding: EdgeInsetsDirectional.only(
                            start: 20,
                            end: 6,
                          ),
                          prefix: ResetRideCalendarButton(),
                          child: SizedBox.shrink(),
                        ),
                      ],
                    );
                  case 3:
                    return Padding(
                      padding: const EdgeInsets.only(top: 32),
                      child: CupertinoFormSection.insetGrouped(
                        children: [
                          CupertinoFormRow(
                            prefix: Text(translator.Version),
                            child: AppVersion(
                              builder: (version) {
                                return Text(
                                  version,
                                  style: const TextStyle(
                                    color: CupertinoColors.systemGrey,
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  default:
                    return null;
                }
              },
              childCount: 4,
            ),
          ),
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
