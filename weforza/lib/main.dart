import 'package:dependencies_flutter/dependencies_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/injection/injector.dart';
import 'package:weforza/theme/appTheme.dart';
import 'package:weforza/widgets/platformAwareWidgetBuilder.dart';
import 'package:weforza/generated/i18n.dart';
import 'package:weforza/widgets/homePage.dart';

///Run the app. We pass a [ProductionInjector] here.
///For testing we can pass a [TestInjector].
void main() => runApp(WeForzaApp(ProductionInjector()));

///This class represents the application.
class WeForzaApp extends StatelessWidget implements PlatformAwareWidget {
  WeForzaApp(this.injector);

  ///The [DependencyInjector] that will resolve dependencies.
  final DependencyInjector injector;

  final String _appTitle = 'WeForza';

  @override
  Widget build(BuildContext context)
  {
    //Setup Injection and use this widget's platform adaptive tree as child.
    return InjectorWidget.bind(
        bindFunc: (binder) => injector.setup(binder),
        child: PlatformAwareWidgetBuilder.buildPlatformAwareWidget(context, this)
    );
  }

  @override
  Widget buildAndroidWidget(BuildContext context) {
    return MaterialApp(
      title: _appTitle,//Calling S.of(context).string_name won't work here.
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
      title: _appTitle,
      localizationsDelegates: [S.delegate],
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


