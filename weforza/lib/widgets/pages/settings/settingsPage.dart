import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:weforza/blocs/settingsBloc.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/injection/injector.dart';
import 'package:weforza/repository/settingsRepository.dart';
import 'package:weforza/widgets/pages/settings/loadingSettings.dart';
import 'package:weforza/widgets/pages/settings/scanDurationOption.dart';
import 'package:weforza/widgets/pages/settings/settingsPageGenericError.dart';
import 'package:weforza/widgets/pages/settings/settingsSubmit.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';


class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState(
      SettingsBloc(InjectionContainer.get<SettingsRepository>())
  );
}

class _SettingsPageState extends State<SettingsPage> {
  _SettingsPageState(this.bloc): assert(bloc != null);

  final SettingsBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc.loadSettings();
  }

  @override
  Widget build(BuildContext context){
    return FutureBuilder<void>(
      future: bloc.settingsFuture,
      builder: (context, snapshot){
        if(snapshot.connectionState == ConnectionState.done){
          if(snapshot.hasError){
            return SettingsPageGenericError();
          }else{
            return PlatformAwareWidget(
              android: () => _buildAndroidWidget(context),
              ios: () => _buildIosWidget(context),
            );
          }
        }else{
          return LoadingSettings();
        }
      },
    );
  }

  Widget _buildAndroidWidget(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).SettingsTitle),
        actions: <Widget>[
          SettingsSubmit(
            submitStream: bloc.submitStream,
            onSubmit: () async {
              await bloc.saveSettings();
              setState(() {});
            },
          ),
        ],
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildIosWidget(BuildContext context){
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Row(
          children: <Widget>[
            Expanded(
              child: Center(child: Text(S.of(context).SettingsTitle)),
            ),
            SettingsSubmit(
              submitStream: bloc.submitStream,
              onSubmit: () async {
                await bloc.saveSettings();
                setState(() {});
              },
            ),
          ],
        ),
        transitionBetweenRoutes: false,
      ),
      child: SafeArea(child: _buildBody(context)),
    );
  }

  Widget _buildBody(BuildContext context){
    return Padding(
      padding: const EdgeInsets.all(8.0),
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
    );
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }
}


