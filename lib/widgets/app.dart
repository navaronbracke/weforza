import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/widgets/pages/home_page/home_page.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';
import 'package:weforza/widgets/theme.dart';

/// This class represents the application.
class WeForzaApp extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _WeForzaAppState();
}

class _WeForzaAppState extends ConsumerState<WeForzaApp> {
  static const String _applicationName = 'WeForza';

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
        title: _applicationName,
        localizationsDelegates: S.localizationsDelegates,
        supportedLocales: S.supportedLocales,
        theme: AppTheme.androidTheme(brightness: .light),
        darkTheme: AppTheme.androidTheme(brightness: .dark),
        home: const HomePage(),
      ),
      ios: (_) => const CupertinoApp(
        title: _applicationName,
        localizationsDelegates: S.localizationsDelegates,
        supportedLocales: S.supportedLocales,
        theme: AppTheme.iosTheme,
        home: HomePage(),
      ),
    );
  }
}
