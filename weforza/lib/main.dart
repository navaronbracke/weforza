import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:weforza/database/databaseProvider.dart';
import 'package:weforza/injection/injector.dart';
import 'package:weforza/theme/appTheme.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';
import 'package:weforza/generated/i18n.dart';
import 'package:weforza/widgets/pages/homePage.dart';

// Set up a Production injector and run the app.
void main() async {
  //Initialize the database before running the app.
  await DatabaseProvider.initializeDatabase();
  //Only now we can setup the injector, since the database is up.
  //The injector provides the Dao's with the newly created database.
  InjectionContainer.initProductionInjector();
  runApp(WeForzaApp());
}

///This class represents the application.
class WeForzaApp extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _WeForzaAppState();
}

class _WeForzaAppState extends State<WeForzaApp> implements PlatformAwareWidget {
  final String _appName = "WeForza";

  @override
  Widget build(BuildContext context)=> PlatformAwareWidgetBuilder.build(context, this);

  @override
  Widget buildAndroidWidget(BuildContext context) {
    return MaterialApp(
      title: _appName,
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate],
      supportedLocales: S.delegate.supportedLocales,
      theme: ApplicationTheme.androidTheme(),
      home: HomePage(),
    );
  }

  @override
  Widget buildIosWidget(BuildContext context) {
    return CupertinoApp(
      title: _appName,
      localizationsDelegates: [
        S.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      theme: ApplicationTheme.iosTheme(),
      home: HomePage(),
    );
  }

  @override
  void dispose() {
    DatabaseProvider.dispose();
    super.dispose();
  }
}


