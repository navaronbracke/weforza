import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/injection/injector.dart';
import 'package:weforza/theme/appTheme.dart';
import 'package:weforza/widgets/platformAwareWidgetBuilder.dart';
import 'package:weforza/generated/i18n.dart';
import 'package:weforza/widgets/pages/homePage.dart';

// Set up a Production injector and run the app.
void main(){
  InjectionContainer.initProductionInjector();
  runApp(WeForzaApp());
}

///This class represents the application.
class WeForzaApp extends StatelessWidget implements PlatformAwareWidget {

  final String _appName = "WeForza";

  @override
  Widget build(BuildContext context) => PlatformAwareWidgetBuilder.buildPlatformAwareWidget(context, this);

  @override
  Widget buildAndroidWidget(BuildContext context) {
    return MaterialApp(
      title: _appName,
      localizationsDelegates: [S.delegate],
      supportedLocales: S.delegate.supportedLocales,
      theme: ApplicationTheme.androidTheme(),
      initialRoute: "/",
      routes: {
        '/': (context) => HomePage(),
        //TODO Other routes here
      },
    );
  }

  @override
  Widget buildIosWidget(BuildContext context) {
    return CupertinoApp(
      title: _appName,
      localizationsDelegates: [
        S.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      theme: ApplicationTheme.iosTheme(),
      initialRoute: "/",
      routes: {
        '/': (context) => HomePage(),
        //TODO Other routes here
      },
    );
  }
}


