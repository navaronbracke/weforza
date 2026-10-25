import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/riverpod/settings/settings_provider.dart';
import 'package:weforza/widgets/pages/home_page/home_page.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';
import 'package:weforza/widgets/theme.dart';

/// This class represents the application.
class WeForzaApp extends StatefulWidget {
  const new({super.key});

  @override
  State<StatefulWidget> createState() => _WeForzaAppState();
}

class _WeForzaAppState extends State<WeForzaApp> {
  static const String applicationName = 'WeForza';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Only portrait is supported at the moment.
    unawaited(SystemChrome.setPreferredOrientations([.portraitUp, .portraitDown]));
  }

  @override
  Widget build(BuildContext context) {
    return PlatformAwareWidget(
      android: (_) => MaterialApp(
        title: applicationName,
        localizationsDelegates: S.localizationsDelegates,
        supportedLocales: S.supportedLocales,
        theme: AppTheme.androidTheme(brightness: .light),
        darkTheme: AppTheme.androidTheme(brightness: .dark),
        home: const _InitialAppStateLoader(child: HomePage()),
      ),
      ios: (_) => const CupertinoApp(
        title: applicationName,
        localizationsDelegates: S.localizationsDelegates,
        supportedLocales: S.supportedLocales,
        theme: AppTheme.iosTheme,
        home: _InitialAppStateLoader(child: HomePage()),
      ),
    );
  }
}

class _InitialAppStateLoader extends ConsumerWidget {
  const new({required this.child});

  final Widget child;

  /// A listener for [WidgetRef.listen] to keep the provider alive.
  static void _keepAliveListener(Object? _, Object? _) {}

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Start loading the application settings, if not already loaded.
    // Also keep the provider alive, for the subtree to be able to listen to it.
    // The settings provider is not marked with `isAutoDispose`, so it is kept alive automatically.
    ref.listen(settingsProvider, _keepAliveListener);

    return child;
  }
}
