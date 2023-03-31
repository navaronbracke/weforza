import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/repository/ride_repository.dart';
import 'package:weforza/riverpod/member/member_list_provider.dart';
import 'package:weforza/riverpod/repository/ride_repository_provider.dart';
import 'package:weforza/theme/app_theme.dart';
import 'package:weforza/widgets/platform/cupertino_loading_dialog.dart';
import 'package:weforza/widgets/platform/platform_aware_loading_indicator.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

///This dialog handles the UI for the reset ride calendar confirmation.
class ResetRideCalendarDialog extends ConsumerStatefulWidget {
  const ResetRideCalendarDialog({Key? key}) : super(key: key);

  @override
  _ResetRideCalendarDialogState createState() =>
      _ResetRideCalendarDialogState();
}

class _ResetRideCalendarDialogState
    extends ConsumerState<ResetRideCalendarDialog> {
  Future<void>? deleteFuture;

  late final RideRepository repository;

  late final MemberListNotifier memberList;

  @override
  void initState() {
    super.initState();
    repository = ref.read(rideRepositoryProvider);
    memberList = ref.read(memberListProvider.notifier);
  }

  @override
  Widget build(BuildContext context) {
    final translator = S.of(context);

    return FutureBuilder<void>(
      future: deleteFuture,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return PlatformAwareWidget(
              android: () => _buildAndroidConfirmDialog(context, translator),
              ios: () => _buildIosConfirmDialog(context, translator),
            );
          case ConnectionState.done:
            return snapshot.hasError
                ? PlatformAwareWidget(
                    android: () => _buildAndroidErrorDialog(
                      context,
                      translator,
                    ),
                    ios: () => _buildIosErrorDialog(context, translator),
                  )
                : PlatformAwareWidget(
                    android: () => _buildAndroidLoadingDialog(
                      context,
                      translator,
                    ),
                    ios: () => const CupertinoLoadingDialog(),
                  );
          default:
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
    deleteFuture = repository.deleteRideCalendar().then((_) {
      if (!mounted) {
        return;
      }

      // TODO: refresh the ride list as well, this notifier does not exist yet
      reloadDataProvider.reloadRides.value = true;
      memberList.getMembers();

      // Pop the dialog with a deletion confirmation.
      Navigator.of(context).pop(true);
    });

    setState(() {});
  }
}
