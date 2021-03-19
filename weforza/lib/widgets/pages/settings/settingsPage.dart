import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:weforza/blocs/settingsBloc.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/model/settings.dart';
import 'package:weforza/injection/injectionContainer.dart';
import 'package:weforza/repository/settingsRepository.dart';
import 'package:weforza/theme/appTheme.dart';
import 'package:weforza/widgets/pages/settings/loadingSettings.dart';
import 'package:weforza/widgets/pages/settings/resetRideCalendarButton.dart';
import 'package:weforza/widgets/pages/settings/scanDurationOption.dart';
import 'package:weforza/widgets/pages/settings/settingsPageGenericError.dart';
import 'package:weforza/widgets/pages/settings/settingsSubmit.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState(
        SettingsBloc(
          InjectionContainer.get<SettingsRepository>(),
        ),
      );
}

class _SettingsPageState extends State<SettingsPage> {
  _SettingsPageState(this.bloc) : assert(bloc != null);

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
      future: Future.delayed(Duration(seconds: 1), () => bloc.loadSettings()),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return SettingsPageGenericError();
          } else {
            return PlatformAwareWidget(
              android: () => _buildAndroidWidget(context, snapshot.data),
              ios: () => _buildIosWidget(context, snapshot.data),
            );
          }
        } else {
          return LoadingSettings();
        }
      },
    );
  }

  Widget _buildAndroidWidget(BuildContext context, Settings settings) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).Settings),
        actions: <Widget>[
          SettingsSubmit(
            submitStream: bloc.submitStream,
            onSubmit: bloc.saveSettings,
          ),
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
                child: SettingsSubmit(
                  submitStream: bloc.submitStream,
                  onSubmit: bloc.saveSettings,
                ),
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
                children: <Widget>[
                  ScanDurationOption(
                    getValue: () => bloc.scanDuration,
                    maxScanValue: bloc.maxScanValue,
                    minScanValue: bloc.minScanValue,
                    onChanged: bloc.onScanDurationChanged,
                  ),
                ],
              ),
            ),
          ),
          if (settings.hasRideCalendar) ResetRideCalendarButton(),
          _buildApplicationPackageInfo(
            context,
            settings.packageInfo.version,
            settings.packageInfo.buildNumber,
          ),
        ],
      ),
    );
  }

  Widget _buildApplicationPackageInfo(
    BuildContext context,
    String version,
    String buildNumber,
  ) {
    return Column(
      children: [
        Text(
          S.of(context).AppVersionNumber(version),
          style: ApplicationTheme.appVersionTextStyle,
        ),
        Text(
          S.of(context).AppVersionBuildNumber(buildNumber),
          style: ApplicationTheme.appVersionTextStyle,
        ),
      ],
    );
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }
}
