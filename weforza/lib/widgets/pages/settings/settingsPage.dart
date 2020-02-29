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
      settingsFuture = bloc.loadSettings();
    }
  }

  @override
  Widget build(BuildContext context) => PlatformAwareWidget(
    android: () => _buildAndroidWidget(context),
    ios: () => _buildIosWidget(context),
  );

  Widget _buildAndroidWidget(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).SettingsTitle),
      ),
      body: bloc.shouldLoadSettings ? _buildSettingsLoader(): _buildBody(context),
    );
  }

  Widget _buildSettingsLoader(){
    return FutureBuilder<void>(
      future: settingsFuture,
      builder: (context,snapshot){
        if(snapshot.connectionState == ConnectionState.done){
          if(snapshot.hasError){
            return LoadingSettingsError();
          }else{
            return _buildBody(context);
          }
        }else{
          return LoadingSettings();
        }
      },
    );
  }

  Widget _buildIosWidget(BuildContext context){
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(S.of(context).SettingsTitle),
        transitionBetweenRoutes: false,
      ),
      child: bloc.shouldLoadSettings ? _buildSettingsLoader(): _buildBody(context),
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


