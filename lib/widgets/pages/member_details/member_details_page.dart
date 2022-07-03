import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/model/member.dart';
import 'package:weforza/riverpod/member/selected_member_provider.dart';
import 'package:weforza/widgets/common/member_attending_count.dart';
import 'package:weforza/widgets/custom/dialogs/delete_member_dialog.dart';
import 'package:weforza/widgets/pages/member_details/member_active_toggle.dart';
import 'package:weforza/widgets/pages/member_details/member_devices_list/member_devices_list.dart';
import 'package:weforza/widgets/pages/member_details/member_name.dart';
import 'package:weforza/widgets/pages/member_details/member_profile_image.dart';
import 'package:weforza/widgets/pages/member_form/member_form.dart';
import 'package:weforza/widgets/platform/cupertino_icon_button.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

/// This class represents the detail page for a [Member].
class MemberDetailsPage extends StatelessWidget {
  const MemberDetailsPage({Key? key}) : super(key: key);

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
        title: Text(translator.Details),
        actions: <Widget>[
          Consumer(
            builder: (context, ref, child) {
              return IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  final member = ref.read(selectedMemberProvider)!.value;

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MemberForm(member: member),
                    ),
                  );
                },
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => showDialog(
              context: context,
              builder: (_) => const DeleteMemberDialog(),
            ),
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
                padding: const EdgeInsets.only(left: 10),
                child: Text(translator.Details),
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Consumer(
                  builder: (context, ref, child) {
                    return CupertinoIconButton.fromAppTheme(
                      icon: CupertinoIcons.pencil,
                      onPressed: () {
                        final member = ref.read(selectedMemberProvider)!.value;

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MemberForm(member: member),
                          ),
                        );
                      },
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: CupertinoIconButton.fromAppTheme(
                    icon: CupertinoIcons.delete,
                    onPressed: () => showCupertinoDialog(
                      context: context,
                      builder: (_) => const DeleteMemberDialog(),
                    ),
                  ),
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
      children: <Widget>[
        Row(
          children: const <Widget>[
            Padding(
              padding: EdgeInsets.all(10),
              child: MemberProfileImage(),
            ),
            Expanded(child: MemberName()),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5, left: 10, right: 10),
          child: Row(
            children: [
              Consumer(
                builder: (_, ref, child) {
                  final future = ref.watch(
                    selectedMemberProvider.select((m) => m!.attendingCount),
                  );

                  return MemberAttendingCount(future: future);
                },
              ),
              const Expanded(child: Center()),
              const MemberActiveToggle(),
            ],
          ),
        )
      ],
    );
  }
}
