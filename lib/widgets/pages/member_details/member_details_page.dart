import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/model/rider/rider.dart';
import 'package:weforza/riverpod/rider/selected_rider_provider.dart';
import 'package:weforza/widgets/common/rider_attending_count.dart';
import 'package:weforza/widgets/dialogs/delete_rider_dialog.dart';
import 'package:weforza/widgets/dialogs/dialogs.dart';
import 'package:weforza/widgets/pages/member_details/member_active_toggle.dart';
import 'package:weforza/widgets/pages/member_details/member_devices_list/member_devices_list.dart';
import 'package:weforza/widgets/pages/member_details/member_name.dart';
import 'package:weforza/widgets/pages/member_details/rider_profile_image.dart';
import 'package:weforza/widgets/pages/rider_form.dart';
import 'package:weforza/widgets/platform/cupertino_icon_button.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

/// This class represents the detail page for a [Rider].
class MemberDetailsPage extends StatelessWidget {
  const MemberDetailsPage({super.key});

  void _goToEditMemberPage(BuildContext context, Rider rider) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RiderForm(rider: rider)),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showWeforzaDialog(
      context,
      builder: (_) => const DeleteRiderDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlatformAwareWidget(
      android: _buildAndroidLayout,
      ios: _buildIOSLayout,
    );
  }

  Widget _buildAndroidLayout(BuildContext context) {
    final translator = S.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(translator.Details),
        actions: <Widget>[
          Consumer(
            builder: (context, ref, child) {
              return IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  final rider = ref.read(selectedRiderProvider)!;

                  _goToEditMemberPage(context, rider);
                },
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _showDeleteDialog(context),
          ),
        ],
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      children: <Widget>[
        _buildMemberInfoSection(context),
        const Expanded(child: MemberDevicesList()),
      ],
    );
  }

  Widget _buildIOSLayout(BuildContext context) {
    final translator = S.of(context);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Row(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(translator.Details),
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Consumer(
                  builder: (context, ref, child) {
                    return CupertinoIconButton(
                      icon: CupertinoIcons.pencil,
                      onPressed: () {
                        final rider = ref.read(selectedRiderProvider)!;

                        _goToEditMemberPage(context, rider);
                      },
                    );
                  },
                ),
                CupertinoIconButton(
                  color: CupertinoColors.systemRed,
                  icon: CupertinoIcons.delete,
                  onPressed: () => _showDeleteDialog(context),
                ),
              ],
            ),
          ],
        ),
        transitionBetweenRoutes: false,
      ),
      child: SafeArea(
        bottom: false,
        child: _buildBody(context),
      ),
    );
  }

  Widget _buildMemberInfoSection(BuildContext context) {
    return Column(
      children: [
        Row(
          children: const [
            Padding(
              padding: EdgeInsets.all(8),
              child: RiderProfileImage(),
            ),
            Expanded(child: MemberName()),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4, left: 8, right: 8),
          child: Row(
            children: const [
              SelectedRiderAttendingCount(),
              Expanded(child: Center()),
              MemberActiveToggle(),
            ],
          ),
        )
      ],
    );
  }
}
