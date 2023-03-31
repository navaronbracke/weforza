import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/blocs/resetRideCalendarBloc.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/injection/injectionContainer.dart';
import 'package:weforza/repository/rideRepository.dart';
import 'package:weforza/theme/appTheme.dart';
import 'package:weforza/widgets/platform/cupertinoLoadingDialog.dart';
import 'package:weforza/widgets/platform/platformAwareLoadingIndicator.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';
import 'package:weforza/widgets/providers/reloadDataProvider.dart';

///This dialog handles the UI for the reset ride calendar confirmation.
class ResetRideCalendarDialog extends StatefulWidget {
  const ResetRideCalendarDialog({Key? key}) : super(key: key);

  @override
  _ResetRideCalendarDialogState createState() => _ResetRideCalendarDialogState(
        bloc: ResetRideCalendarBloc(
          repository: InjectionContainer.get<RideRepository>(),
        ),
      );
}

class _ResetRideCalendarDialogState extends State<ResetRideCalendarDialog> {
  _ResetRideCalendarDialogState({required this.bloc});

  final ResetRideCalendarBloc bloc;

  @override
  Widget build(BuildContext context) {
    final translator = S.of(context);

    return FutureBuilder<void>(
      future: bloc.deleteCalendarFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.none) {
          return PlatformAwareWidget(
            android: () => _buildAndroidConfirmDialog(context, translator),
            ios: () => _buildIosConfirmDialog(context, translator),
          );
        } else if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasError) {
          return PlatformAwareWidget(
            android: () => _buildAndroidErrorDialog(context, translator),
            ios: () => _buildIosErrorDialog(context, translator),
          );
        } else {
          return PlatformAwareWidget(
            android: () => _buildAndroidLoadingDialog(context, translator),
            ios: () => const CupertinoLoadingDialog(),
          );
        }
      },
    );
  }

  Widget _buildAndroidConfirmDialog(BuildContext context, S translator) {
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
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
        ButtonBar(
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
              onPressed: () => _resetCalendar(context),
            ),
          ],
        ),
      ],
    );

    return _buildAndroidDialog(content);
  }

  Widget _buildAndroidErrorDialog(BuildContext context, S translator) {
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
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
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 5),
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
        ButtonBar(
          children: <Widget>[
            TextButton(
              child: Text(translator.Ok.toUpperCase()),
              onPressed: () => Navigator.of(context).pop(false),
            ),
          ],
        ),
      ],
    );

    return _buildAndroidDialog(content);
  }

  Widget _buildAndroidLoadingDialog(BuildContext context, S translator) {
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
          child: Text(
            translator.SettingsResetRideCalendarDialogTitle,
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        const Expanded(
          child: Center(child: PlatformAwareLoadingIndicator()),
        ),
      ],
    );

    return _buildAndroidDialog(content);
  }

  Widget _buildAndroidDialog(Widget content) {
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          LayoutBuilder(
            builder: (context, constraints) {
              return SizedBox(
                width: constraints.biggest.width,
                height: 200,
                child: content,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildIosConfirmDialog(BuildContext context, S translator) {
    return CupertinoAlertDialog(
      title: Text(translator.SettingsResetRideCalendarDialogTitle),
      content: Text(translator.SettingsResetRideCalendarDialogDescription),
      actions: [
        CupertinoDialogAction(
          isDestructiveAction: true,
          child: Text(translator.SettingsResetRideCalendarDialogConfirm),
          onPressed: () => _resetCalendar(context),
        ),
        CupertinoDialogAction(
          child: Text(translator.Cancel),
          onPressed: () => Navigator.of(context).pop(false),
        ),
      ],
    );
  }

  Widget _buildIosErrorDialog(BuildContext context, S translator) {
    return CupertinoAlertDialog(
      title: Text(translator.SettingsResetRideCalendarDialogTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Icon(
              CupertinoIcons.exclamationmark_circle,
              color: CupertinoColors.destructiveRed,
              size: 25,
            ),
          ),
          Text(translator.SettingsResetRideCalendarErrorMessage),
        ],
      ),
      actions: [
        CupertinoDialogAction(
          child: Text(translator.Ok),
          onPressed: () => Navigator.of(context).pop(false),
        ),
      ],
    );
  }

  void _resetCalendar(BuildContext context) {
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
