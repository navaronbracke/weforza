import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:weforza/database/database.dart';
import 'package:weforza/database/rideDao.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/injection/injector.dart';
import 'package:weforza/theme/appTheme.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';
import 'package:weforza/widgets/pages/homePage.dart';
import 'package:weforza/widgets/providers/reloadDataProvider.dart';
import 'package:weforza/widgets/providers/rideAttendeeProvider.dart';
import 'package:weforza/widgets/providers/selectedItemProvider.dart';

// Set up a Production injector and run the app.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //Await the injection setup.
  //We initialize a production database, hence its async here.
  await InjectionContainer.initProductionInjector();

  //TODO remove this migration (and the dao method!) when done on test devices
  final RideDao dao = RideDao.withProvider(InjectionContainer.get<ApplicationDatabase>());
  await dao.stripDataFromAllRides();

  runApp(WeForzaApp());
}

///This class represents the application.
class WeForzaApp extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _WeForzaAppState();
}

class _WeForzaAppState extends State<WeForzaApp> {
  final String _appName = "WeForza";

  @override
  Widget build(BuildContext context){
    //force portrait
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
            onTap: (){
              //enable tap to dismiss keyboard
              final FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
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
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate],
      supportedLocales: S.delegate.supportedLocales,
      theme: ApplicationTheme.androidTheme(),
      home: HomePage(),
    );
  }


  Widget _buildIosWidget() {
    return CupertinoApp(
      title: _appName,
      localizationsDelegates: [
        S.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      theme: ApplicationTheme.iosTheme(),
      home: HomePage(),
    );
  }

  @override
  void dispose() {
    InjectionContainer.get<ApplicationDatabase>().dispose();
    super.dispose();
  }
}


