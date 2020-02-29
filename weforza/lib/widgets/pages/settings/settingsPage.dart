import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:weforza/blocs/settingsBloc.dart';
import 'package:weforza/generated/i18n.dart';
import 'package:weforza/injection/injector.dart';
import 'package:weforza/repository/settingsRepository.dart';
import 'package:weforza/widgets/pages/settings/loadingSettings.dart';
import 'package:weforza/widgets/pages/settings/loadingSettingsError.dart';
import 'package:weforza/widgets/pages/settings/scanDurationOption.dart';
import 'package:weforza/widgets/pages/settings/settingsPageGenericError.dart';
import 'package:weforza/widgets/pages/settings/settingsSubmit.dart';
import 'package:weforza/widgets/pages/settings/settingsSubmitError.dart';
import 'package:weforza/widgets/pages/settings/showAllScanDevicesOption.dart';
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

  Future<void> settingsFuture;

  @override
  void initState() {
    super.initState();
    if(bloc.shouldLoadSettings){
      //We put an artificial delay here to decrease the feeling of popping in.
      //See https://www.youtube.com/watch?v=O6ZQ9r8a3iw
      settingsFuture = Future.delayed(Duration(seconds: 1),() => bloc.loadSettingsFromDatabase());
    }else{
      bloc.loadSettingsFromMemory();
    }
  }

  @override
  Widget build(BuildContext context){
    return StreamBuilder<SettingsDisplayMode>(
      initialData: settingsFuture == null ? SettingsDisplayMode.IDLE: SettingsDisplayMode.LOADING,
      stream: bloc.displayMode,
      builder: (context,snapshot){
        switch(snapshot.data){
          case SettingsDisplayMode.LOADING: return LoadingSettings();
          case SettingsDisplayMode.IDLE: return PlatformAwareWidget(
            android: () => _buildAndroidWidget(context),
            ios: () => _buildIosWidget(context),
          );
          case SettingsDisplayMode.SUBMIT_ERROR: return SettingsSubmitError();
          case SettingsDisplayMode.LOADING_ERROR: return LoadingSettingsError();
          default: return SettingsPageGenericError();
        }
      },
    );
  }

  Widget _buildAndroidWidget(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).SettingsTitle),
        actions: <Widget>[
          SettingsSubmit(handler: bloc),
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
            SettingsSubmit(handler: bloc),
          ],
        ),
        transitionBetweenRoutes: false,
      ),
      child: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ScanDurationOption(bloc.scanDurationHandler),
            SizedBox(height: 5),
            ShowAllScanDevicesOption(bloc.showAllDevicesHandler),
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


