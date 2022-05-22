import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/model/ride_details_page_options.dart';
import 'package:weforza/riverpod/ride/selected_ride_provider.dart';
import 'package:weforza/widgets/custom/dialogs/delete_ride_dialog.dart';
import 'package:weforza/widgets/pages/export_ride_page.dart';
import 'package:weforza/widgets/pages/ride_attendee_scanning_page/ride_attendee_scanning_page.dart';
import 'package:weforza/widgets/pages/ride_details/ride_details_attendees/ride_details_attendees_list.dart';
import 'package:weforza/widgets/pages/ride_details/ride_details_title.dart';
import 'package:weforza/widgets/platform/cupertino_icon_button.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

class RideDetailsPage extends ConsumerStatefulWidget {
  const RideDetailsPage({Key? key}) : super(key: key);

  @override
  _RideDetailsPageState createState() => _RideDetailsPageState();
}

class _RideDetailsPageState extends ConsumerState<RideDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return PlatformAwareWidget(
      android: () => _buildAndroidLayout(context),
      ios: () => _buildIOSLayout(context),
    );
  }

  Widget _buildAndroidLayout(BuildContext context) {
    final translator = S.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const RideDetailsTitle(),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.bluetooth_searching),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const RideAttendeeScanningPage(),
                ),
              );
            },
          ),
          PopupMenuButton<RideDetailsPageOptions>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            itemBuilder: (context) => <PopupMenuEntry<RideDetailsPageOptions>>[
              PopupMenuItem<RideDetailsPageOptions>(
                child: ListTile(
                  leading: const Icon(Icons.publish),
                  title: Text(translator.Export),
                ),
                value: RideDetailsPageOptions.export,
              ),
              const PopupMenuDivider(),
              PopupMenuItem<RideDetailsPageOptions>(
                child: ListTile(
                  leading: const Icon(Icons.delete, color: Colors.red),
                  title: Text(
                    translator.Delete,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
                value: RideDetailsPageOptions.delete,
              ),
            ],
            onSelected: (RideDetailsPageOptions option) {
              onSelectMenuOption(context, option);
            },
          ),
        ],
      ),
      body: const RideDetailsAttendeesList(),
    );
  }

  Widget _buildIOSLayout(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        transitionBetweenRoutes: false,
        middle: Row(
          children: <Widget>[
            const Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 10),
                child: RideDetailsTitle(),
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CupertinoIconButton.fromAppTheme(
                  icon: Icons.bluetooth_searching,
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const RideAttendeeScanningPage(),
                      ),
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: CupertinoIconButton.fromAppTheme(
                      icon: CupertinoIcons.ellipsis_vertical,
                      onPressed: () async {
                        final RideDetailsPageOptions? option =
                            await showCupertinoModalPopup<
                                    RideDetailsPageOptions>(
                                context: context,
                                builder: (context) {
                                  return CupertinoActionSheet(
                                    actions: [
                                      CupertinoActionSheetAction(
                                        child: Text(S.of(context).Export),
                                        onPressed: () => Navigator.of(context)
                                            .pop(RideDetailsPageOptions.export),
                                      ),
                                      CupertinoActionSheetAction(
                                        child: Text(S.of(context).Delete),
                                        isDestructiveAction: true,
                                        onPressed: () => Navigator.of(context)
                                            .pop(RideDetailsPageOptions.delete),
                                      ),
                                    ],
                                    cancelButton: CupertinoActionSheetAction(
                                      child: Text(S.of(context).Cancel),
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                    ),
                                  );
                                });

                        if (option == null) return;

                        onSelectMenuOption(context, option);
                      }),
                ),
              ],
            ),
          ],
        ),
      ),
      child: const SafeArea(bottom: false, child: RideDetailsAttendeesList()),
    );
  }

  void onSelectMenuOption(BuildContext context, RideDetailsPageOptions option) {
    switch (option) {
      case RideDetailsPageOptions.export:
        final notifier = ref.read(selectedRideProvider.notifier);

        assert(notifier.selectedRide != null, 'The selected ride was null.');

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ExportRidePage(
              rideToExport: notifier.selectedRide!,
            ),
          ),
        );
        break;
      case RideDetailsPageOptions.delete:
        if (Platform.isAndroid) {
          showDialog(
            context: context,
            builder: (_) => const DeleteRideDialog(),
          );
        } else if (Platform.isIOS) {
          showCupertinoDialog(
            context: context,
            builder: (_) => const DeleteRideDialog(),
          );
        }
        break;

      default:
        break;
    }
  }
}
