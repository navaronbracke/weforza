import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/riverpod/database/database_provider.dart';
import 'package:weforza/theme/app_theme.dart';
import 'package:weforza/widgets/pages/home_page.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

/// This class represents the application.
class WeForzaApp extends ConsumerStatefulWidget {
  const WeForzaApp({super.key});

  @override
  WeForzaAppState createState() => WeForzaAppState();
}

class WeForzaAppState extends ConsumerState<WeForzaApp> {
  static const _appName = 'WeForza';

  @override
  Widget build(BuildContext context) {
    // Only portrait is supported at the moment.
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return GestureDetector(
      child: PlatformAwareWidget(
        android: () => _buildAndroidWidget(),
        ios: () => _buildIosWidget(),
      ),
      onTap: () {
        // Enable tap to dismiss the keyboard.
        FocusScope.of(context).unfocus();
      },
    );
  }

  Widget _buildAndroidWidget() {
    return MaterialApp(
      title: _appName,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      theme: ApplicationTheme.androidTheme(),
      home: const HomePage(),
    );
  }

  Widget _buildIosWidget() {
    return CupertinoApp(
      title: _appName,
      localizationsDelegates: const [
        S.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      theme: ApplicationTheme.iosTheme(),
      home: const HomePage(),
    );
  }

  @override
  void dispose() {
    ref.read(databaseProvider).dispose();
    super.dispose();
  }
}
