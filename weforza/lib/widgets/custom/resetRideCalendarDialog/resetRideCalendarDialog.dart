import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:weforza/blocs/resetRideCalendarBloc.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/injection/injectionContainer.dart';
import 'package:weforza/repository/rideRepository.dart';
import 'package:weforza/theme/appTheme.dart';
import 'package:weforza/widgets/platform/platformAwareLoadingIndicator.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';
import 'package:weforza/widgets/providers/reloadDataProvider.dart';

///This dialog handles the UI for the reset ride calendar confirmation.
class ResetRideCalendarDialog extends StatefulWidget {

  @override
  _ResetRideCalendarDialogState createState() => _ResetRideCalendarDialogState(
    bloc: ResetRideCalendarBloc(
      repository: InjectionContainer.get<RideRepository>(),
    ),
  );
}

class _ResetRideCalendarDialogState extends State<ResetRideCalendarDialog> {
  _ResetRideCalendarDialogState({
    @required this.bloc
  }): assert(bloc != null);

  final ResetRideCalendarBloc bloc;

  @override
  Widget build(BuildContext context){
    final translator = S.of(context);

    return FutureBuilder<void>(
      future: bloc.deleteCalendarFuture,
      builder: (context, snapshot){
        if(snapshot.connectionState == ConnectionState.none){
          return PlatformAwareWidget(
            android: () => _buildAndroidConfirmDialog(context, translator),
            ios: () => _buildIosConfirmDialog(context, translator),
          );
        }else if(snapshot.connectionState == ConnectionState.done && snapshot.hasError){
          return PlatformAwareWidget(
            android: () => _buildAndroidErrorDialog(context, translator),
            ios: () => _buildIosErrorDialog(context, translator),
          );
        }else{
          return PlatformAwareWidget(
            android: () => _buildAndroidLoadingDialog(context, translator),
            ios: () => _buildIosLoadingDialog(context, translator),
          );
        }
      },
    );
  }

  Widget _buildAndroidConfirmDialog(BuildContext context, S translator){
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(24, 24, 24, 20),
          child: Text(
            translator.SettingsResetRideCalendarDialogTitle,
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              translator.SettingsResetRideCalendarDialogDescription,
              softWrap: true,
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
          child: ButtonBar(
            children: <Widget>[
              TextButton(
                child: Text(translator.Cancel.toUpperCase()),
                onPressed: () => Navigator.of(context).pop(false),
              ),
              TextButton(
                child: Text(
                  translator.SettingsResetRideCalendarDialogConfirm.toUpperCase(),
                ),
                style: TextButton.styleFrom(
                  primary: ApplicationTheme.deleteItemButtonTextColor,
                ),
                onPressed: () => _onConfirmDeletion(context),
              ),
            ],
          ),
        ),
      ],
    );

    return _buildAndroidDialog(content);
  }

  Widget _buildAndroidErrorDialog(BuildContext context, S translator){
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(24, 24, 24, 20),
          child: Text(
            translator.SettingsResetRideCalendarDialogTitle,
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        Expanded(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Icon(
                    Icons.error_outline,
                    size: 30,
                    color: ApplicationTheme.deleteItemButtonTextColor,
                  ),
                ),
                Text(
                  translator.SettingsResetRideCalendarErrorMessage,
                  softWrap: true,
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
          child: ButtonBar(
            children: <Widget>[
              TextButton(
                child: Text(translator.Ok.toUpperCase()),
                onPressed: () => Navigator.of(context).pop(false),
              ),
            ],
          ),
        ),
      ],
    );

    return _buildAndroidDialog(content);
  }

  Widget _buildAndroidLoadingDialog(BuildContext context, S translator){
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(24, 24, 24, 0),
          child: Text(
            translator.SettingsResetRideCalendarDialogTitle,
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        Expanded(
          child: Center(child: PlatformAwareLoadingIndicator()),
        ),
      ],
    );

    return _buildAndroidDialog(content);
  }

  Widget _buildAndroidDialog(Widget content){
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            // 280 is the minimum width for a material Dialog.
            width: 280,
            height: 200,
            child: content,
          ),
        ],
      ),
    );
  }

  Widget _buildIosConfirmDialog(BuildContext context, S translator){
    final content = Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 5),
          child: Text(
            translator.SettingsResetRideCalendarDialogTitle,
            style: TextStyle(
              color: Colors.black,
              fontFamily: '.SF UI Display',
              inherit: false,
              fontSize: 18.0,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.48,
              textBaseline: TextBaseline.alphabetic,
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              translator.SettingsResetRideCalendarDialogDescription,
              style: TextStyle(
                color: Colors.black,
                fontFamily: '.SF UI Text',
                inherit: false,
                fontSize: 13.4,
                fontWeight: FontWeight.w400,
                height: 1.036,
                letterSpacing: -0.25,
                textBaseline: TextBaseline.alphabetic,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Flexible(
                child: Center(
                  child: CupertinoDialogAction(
                    child: Text(translator.Cancel),
                    onPressed: () => Navigator.of(context).pop(false),
                  ),
                ),
              ),
              Flexible(
                child: Center(
                  child: CupertinoDialogAction(
                    child: Text(
                      translator.SettingsResetRideCalendarDialogConfirm,
                      style: TextStyle(
                        color: ApplicationTheme.deleteItemButtonTextColor,
                      ),
                    ),
                    onPressed: () => _onConfirmDeletion(context),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );

    return _buildIosDialog(content);
  }

  Widget _buildIosErrorDialog(BuildContext context, S translator){
    final content = Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 5),
          child: Text(
            translator.SettingsResetRideCalendarDialogTitle,
            style: TextStyle(
              color: Colors.black,
              fontFamily: '.SF UI Display',
              inherit: false,
              fontSize: 18.0,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.48,
              textBaseline: TextBaseline.alphabetic,
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Icon(
                      Icons.error_outline,
                      size: 25,
                      color: ApplicationTheme.deleteItemButtonTextColor
                  ),
                ),
                Text(
                  translator.SettingsResetRideCalendarErrorMessage,
                  softWrap: true,
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: '.SF UI Text',
                    inherit: false,
                    fontSize: 13.4,
                    fontWeight: FontWeight.w400,
                    height: 1.036,
                    letterSpacing: -0.25,
                    textBaseline: TextBaseline.alphabetic,
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Center(
                  child: CupertinoDialogAction(
                    child: Text(translator.Ok),
                    onPressed: () => Navigator.of(context).pop(false),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );

    return _buildIosDialog(content);
  }

  Widget _buildIosLoadingDialog(BuildContext context, S translator){
    final content = Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 5),
          child: Text(
            translator.SettingsResetRideCalendarDialogTitle,
            style: TextStyle(
              color: Colors.black,
              fontFamily: '.SF UI Display',
              inherit: false,
              fontSize: 18.0,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.48,
              textBaseline: TextBaseline.alphabetic,
            ),
          ),
        ),
        Expanded(
          child: Center(child: PlatformAwareLoadingIndicator()),
        ),
      ],
    );

    return _buildIosDialog(content);
  }

  ///Build the general dialog scaffolding and inject the content.
  ///This way, the general look is the same for each dialog,
  ///but the content can differ.
  Widget _buildIosDialog(Widget content){
    return Center(
      child: CupertinoPopupSurface(
        isSurfacePainted: true,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              width: 270.0,
              height: 200,
              child: content,
            ),
          ],
        ),
      ),
    );
  }

  void _onConfirmDeletion(BuildContext context) {
    final reloadDataProvider = ReloadDataProvider.of(context);

    setState(() {
      bloc.deleteRideCalendar(() {
        reloadDataProvider.reloadRides.value = true;
        reloadDataProvider.reloadMembers.value = true;
        // Pop the dialog with a deletion confirmation.
        Navigator.of(context).pop(true);
      });
    });
  }
}
