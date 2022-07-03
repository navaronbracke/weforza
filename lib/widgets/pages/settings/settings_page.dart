import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/model/extended_settings.dart';
import 'package:weforza/riverpod/settings_provider.dart';
import 'package:weforza/widgets/pages/settings/app_version.dart';
import 'package:weforza/widgets/pages/settings/loading_settings.dart';
import 'package:weforza/widgets/pages/settings/member_list_filter.dart';
import 'package:weforza/widgets/pages/settings/reset_ride_calendar_button.dart';
import 'package:weforza/widgets/pages/settings/scan_duration_option.dart';
import 'package:weforza/widgets/pages/settings/settings_page_generic_error.dart';
import 'package:weforza/widgets/pages/settings/settings_submit.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends ConsumerState<SettingsPage> {
  late final SettingsNotifier settingsNotifier;

  @override
  void initState() {
    super.initState();
    settingsNotifier = ref.read(settingsProvider.notifier);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ExtendedSettings>(
      // Each time this page is visited, the calendar data could be out of sync.
      // Therefor, fetch the data on each build.
      // This might seem bad at first,
      // but this widget does not call its setState method anywhere.
      // Its children manage their own state
      // and never ask this widget to rebuild.
      future: Future.delayed(
        // Use an artificial delay to make it look smoother.
        const Duration(milliseconds: 500),
        () => settingsNotifier.loadExtendedSettings(),
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const LoadingSettings();
        }

        final settings = snapshot.data;

        if (snapshot.hasError || settings == null) {
          return const SettingsPageGenericError();
        }

        final translator = S.of(context);

        return PlatformAwareWidget(
          android: () => _buildAndroidWidget(translator, settings),
          ios: () => _buildIosWidget(translator, settings),
        );
      },
    );
  }

  Widget _buildAndroidWidget(S translator, ExtendedSettings extendedSettings) {
    return Scaffold(
      appBar: AppBar(
        title: Text(translator.Settings),
        actions: <Widget>[SettingsSubmit(delegate: settingsNotifier)],
      ),
      body: _buildBody(translator, extendedSettings),
    );
  }

  Widget _buildIosWidget(S translator, ExtendedSettings extendedSettings) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(translator.Settings),
              ),
            ),
            SizedBox(
              width: 40,
              child: Center(
                child: SettingsSubmit(delegate: settingsNotifier),
              ),
            ),
          ],
        ),
        transitionBetweenRoutes: false,
      ),
      child: SafeArea(child: _buildBody(translator, extendedSettings)),
    );
  }

  Widget _buildBody(S translator, ExtendedSettings extendedSettings) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ScanDurationOption(delegate: settingsNotifier),
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: MemberListFilter(delegate: settingsNotifier),
                  ),
                ],
              ),
            ),
          ),
          if (extendedSettings.hasRideCalendar) const ResetRideCalendarButton(),
          AppVersion(version: extendedSettings.generalSettings.appVersion),
        ],
      ),
    );
  }
}
