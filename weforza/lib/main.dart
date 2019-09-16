import 'package:flutter/material.dart';
import 'generated/i18n.dart';
import 'widgets/homePage.dart';

void main() => runApp(WeForzaApp());

///This class represents the application
class WeForzaApp extends StatelessWidget {

  final Color _primaryColor = Colors.red;
  final Color _accentColor = Colors.redAccent;
  final String _appTitle = 'WeForza';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _appTitle,//Calling S.of(context).string_name won't work here.
      localizationsDelegates: [S.delegate],
      supportedLocales: S.delegate.supportedLocales,
      theme: ThemeData(
        primarySwatch: _primaryColor,
        accentColor: _accentColor
      ),
      home: HomePage(),
    );
  }
}


