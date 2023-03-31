import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/widgets/pages/home_page/home_page.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';
import 'package:weforza/widgets/theme.dart';

/// This class represents the application.
class WeForzaApp extends StatelessWidget {
  const WeForzaApp({super.key});

  /// The name of the application, 'WeForza'.
  static const String applicationName = 'WeForza';

  @override
  Widget build(BuildContext context) {
    // Only portrait is supported at the moment.
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return PlatformAwareWidget(
      android: (_) => MaterialApp(
        title: applicationName,
        localizationsDelegates: S.localizationsDelegates,
        supportedLocales: S.supportedLocales,
        theme: AppTheme.androidTheme,
        home: const HomePage(),
      ),
      ios: (_) => const CupertinoApp(
        title: applicationName,
        localizationsDelegates: S.localizationsDelegates,
        supportedLocales: S.supportedLocales,
        theme: AppTheme.iosTheme,
        home: HomePage(),
      ),
    );
  }
}
