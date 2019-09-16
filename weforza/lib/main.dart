import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/theme/appTheme.dart';
import 'package:weforza/widgets/platformAwareWidgetBuilder.dart';
import 'generated/i18n.dart';
import 'widgets/homePage.dart';

void main() => runApp(WeForzaApp());

///This class represents the application
class WeForzaApp extends StatelessWidget implements PlatformAwareWidget {

  final String _appTitle = 'WeForza';

  @override
  Widget build(BuildContext context) {
    return PlatformAwareWidgetBuilder.buildPlatformAwareWidget(context, this);
  }

  @override
  Widget buildAndroidWidget(BuildContext context) {
    return MaterialApp(
      title: _appTitle,//Calling S.of(context).string_name won't work here.
      localizationsDelegates: [S.delegate],
      supportedLocales: S.delegate.supportedLocales,
      //We could define a ThemeData object in a different Dart file for easy customization
      theme: ApplicationTheme.androidTheme(),
      home: HomePage(),
    );
  }

  @override
  Widget buildIosWidget(BuildContext context) {
    return CupertinoApp(
      title: _appTitle,
      localizationsDelegates: [S.delegate],
      supportedLocales: S.delegate.supportedLocales,
      theme: ApplicationTheme.iosTheme(),
      home: HomePage(),
    );
  }
}


