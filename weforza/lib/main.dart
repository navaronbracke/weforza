import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/theme/appTheme.dart';
import 'package:weforza/widgets/platformAwareWidgetBuilder.dart';
import 'package:weforza/generated/i18n.dart';
import 'package:weforza/widgets/homePage.dart';

void main() => runApp(WeForzaApp());

///This class represents the application
class WeForzaApp extends StatelessWidget implements PlatformAwareWidget {

  final String _appTitle = 'WeForza';

  @override
  Widget build(BuildContext context) => PlatformAwareWidgetBuilder.buildPlatformAwareWidget(context, this);

  @override
  Widget buildAndroidWidget(BuildContext context) {
    return MaterialApp(
      title: _appTitle,//Calling S.of(context).string_name won't work here.
      localizationsDelegates: [S.delegate],
      supportedLocales: S.delegate.supportedLocales,
      theme: ApplicationTheme.androidTheme(),
      initialRoute: "/",
      routes: {
        '/': (context) => HomePage(_appTitle),
        //Other routes here
      },
    );
  }

  @override
  Widget buildIosWidget(BuildContext context) {
    return CupertinoApp(
      title: _appTitle,
      localizationsDelegates: [S.delegate],
      supportedLocales: S.delegate.supportedLocales,
      theme: ApplicationTheme.iosTheme(),
      initialRoute: "/",
      routes: {
        '/': (context) => HomePage(_appTitle),
        //Other routes here
      },
    );
  }
}


