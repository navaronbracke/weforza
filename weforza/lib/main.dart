import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/widgets/platformAwareWidgetBuilder.dart';
import 'generated/i18n.dart';
import 'widgets/homePage.dart';

void main() => runApp(WeForzaApp());

///This class represents the application
class WeForzaApp extends StatelessWidget implements PlatformAwareWidget {

  final Color _primaryColor = Colors.red;
  final Color _accentColor = Colors.redAccent;
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
      theme: ThemeData(
          primarySwatch: _primaryColor,
          accentColor: _accentColor,
      ),
      home: HomePage(),
    );
  }

  @override
  Widget buildIosWidget(BuildContext context) {
    return CupertinoApp(
      title: _appTitle,
      localizationsDelegates: [S.delegate],
      supportedLocales: S.delegate.supportedLocales,
      //TODO Theme
      home: HomePage(),
    );
  }
}


