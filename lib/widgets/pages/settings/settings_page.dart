import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/blocs/settings_bloc.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/injection/injectionContainer.dart';
import 'package:weforza/model/settings.dart';
import 'package:weforza/repository/settings_repository.dart';
import 'package:weforza/theme/app_theme.dart';
import 'package:weforza/widgets/pages/settings/loading_settings.dart';
import 'package:weforza/widgets/pages/settings/member_list_filter.dart';
import 'package:weforza/widgets/pages/settings/reset_ride_calendar_button.dart';
import 'package:weforza/widgets/pages/settings/scan_duration_option.dart';
import 'package:weforza/widgets/pages/settings/settings_page_generic_error.dart';
import 'package:weforza/widgets/pages/settings/settings_submit.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState(
        SettingsBloc(
          InjectionContainer.get<SettingsRepository>(),
        ),
      );
}

class _SettingsPageState extends State<SettingsPage> {
  _SettingsPageState(this.bloc);

  final SettingsBloc bloc;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Settings>(
      // We have to reload the future on each build.
      // Sadly enough we don't have any other options.
      // There is no global store tat could have helped :/
      // But this widget doesn't call it's setState method.
      // Thus we don't get any unnecessary build calls for the FutureBuilder.
      //
      // We put an artificial delay here to decrease the feeling of popping in.
      // See https://www.youtube.com/watch?v=O6ZQ9r8a3iw
      future: Future.delayed(
        const Duration(seconds: 1),
        () => bloc.loadSettings(),
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError || snapshot.data == null) {
            return const SettingsPageGenericError();
          } else {
            return PlatformAwareWidget(
              android: () => _buildAndroidWidget(context, snapshot.data!),
              ios: () => _buildIosWidget(context, snapshot.data!),
            );
          }
        } else {
          return const LoadingSettings();
        }
      },
    );
  }

  Widget _buildAndroidWidget(BuildContext context, Settings settings) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).Settings),
        actions: <Widget>[
          SettingsSubmit(bloc: bloc),
        ],
      ),
      body: _buildBody(context, settings),
    );
  }

  Widget _buildIosWidget(BuildContext context, Settings settings) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(S.of(context).Settings),
              ),
            ),
            SizedBox(
              width: 40,
              child: Center(
                child: SettingsSubmit(bloc: bloc),
              ),
            ),
          ],
        ),
        transitionBetweenRoutes: false,
      ),
      child: SafeArea(
        child: _buildBody(context, settings),
      ),
    );
  }

  Widget _buildBody(BuildContext context, Settings settings) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ScanDurationOption(
                    getValue: () => bloc.scanDuration,
                    maxScanValue: bloc.maxScanValue,
                    minScanValue: bloc.minScanValue,
                    onChanged: bloc.onScanDurationChanged,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: MemberListFilter(
                      getValue: () => bloc.memberListFilter,
                      onChanged: bloc.onMemberListFilterChanged,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (settings.hasRideCalendar) const ResetRideCalendarButton(),
          PlatformAwareWidget(
            android: () => Text(
              S.of(context).AppVersionNumber(settings.appVersion),
              style: ApplicationTheme.appVersionTextStyle,
            ),
            ios: () => Text(
              S.of(context).AppVersionNumber(settings.appVersion),
              style:
                  ApplicationTheme.appVersionTextStyle.copyWith(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }
}