import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:weforza/database/database.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/injection/injectionContainer.dart';
import 'package:weforza/theme/app_theme.dart';
import 'package:weforza/widgets/pages/home_page.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';
import 'package:weforza/widgets/providers/reloadDataProvider.dart';
import 'package:weforza/widgets/providers/rideAttendeeProvider.dart';
import 'package:weforza/widgets/providers/selectedItemProvider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Setup the database and other dependencies.
  await InjectionContainer.initProductionInjector();

  runApp(const WeForzaApp());
}

/// This class represents the application.
class WeForzaApp extends StatefulWidget {
  const WeForzaApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _WeForzaAppState();
}

class _WeForzaAppState extends State<WeForzaApp> {
  static const _appName = 'WeForza';

  @override
  Widget build(BuildContext context) {
    // Only portrait is supported at the moment.
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return SelectedItemProvider(
      child: ReloadDataProvider(
        child: RideAttendeeFutureProvider(
          child: GestureDetector(
            child: PlatformAwareWidget(
              android: () => _buildAndroidWidget(),
              ios: () => _buildIosWidget(),
            ),
            onTap: () {
              // Enable tap to dismiss the keyboard.
              final FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.focusedChild?.unfocus();
              }
            },
          ),
        ),
      ),
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
    InjectionContainer.get<ApplicationDatabase>().dispose();
    InjectionContainer.dispose();
    super.dispose();
  }
}
