import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/blocs/member_details_bloc.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/injection/injectionContainer.dart';
import 'package:weforza/model/member.dart';
import 'package:weforza/repository/device_repository.dart';
import 'package:weforza/repository/member_repository.dart';
import 'package:weforza/theme/app_theme.dart';
import 'package:weforza/widgets/common/member_attending_count.dart';
import 'package:weforza/widgets/custom/dialogs/delete_item_dialog.dart';
import 'package:weforza/widgets/custom/profile_image/async_profile_image.dart';
import 'package:weforza/widgets/pages/add_device/add_device_page.dart';
import 'package:weforza/widgets/pages/edit_member_page.dart';
import 'package:weforza/widgets/pages/member_details/member_active_toggle.dart';
import 'package:weforza/widgets/pages/member_details/member_devices_list/member_devices_list.dart';
import 'package:weforza/widgets/platform/cupertino_icon_button.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';
import 'package:weforza/widgets/providers/reloadDataProvider.dart';
import 'package:weforza/widgets/providers/selectedItemProvider.dart';

///This class represents the detail page for a [Member].
class MemberDetailsPage extends StatefulWidget {
  const MemberDetailsPage({Key? key}) : super(key: key);

  @override
  _MemberDetailsPageState createState() => _MemberDetailsPageState();
}

///This is the [State] class for [MemberDetailsPage].
class _MemberDetailsPageState extends State<MemberDetailsPage> {
  ///The BLoC in charge of the content.
  late MemberDetailsBloc bloc;

  void goToEditMemberPage(BuildContext context) {
    Navigator.push(context,
            MaterialPageRoute(builder: (context) => const EditMemberPage()))
        .then((_) {
      setState(() {
        bloc.member = SelectedItemProvider.of(context).selectedMember.value!;
        bloc.profileImage =
            SelectedItemProvider.of(context).selectedMemberProfileImage.value!;
      });
    });
  }

  void onMemberActiveChanged(bool value, BuildContext context) {
    bloc.setMemberActive(
        value, () => ReloadDataProvider.of(context).reloadMembers.value = true);
  }

  Future<void> onDeleteMember(BuildContext context) async {
    await bloc.deleteMember();

    //trigger the reload of members
    ReloadDataProvider.of(context).reloadMembers.value = true;
    final navigator = Navigator.of(context);
    //Pop both the dialog and the detail screen
    navigator.pop();
    navigator.pop();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    bloc = MemberDetailsBloc(
        memberRepository: InjectionContainer.get<MemberRepository>(),
        deviceRepository: InjectionContainer.get<DeviceRepository>(),
        member: SelectedItemProvider.of(context).selectedMember.value!,
        profileImage:
            SelectedItemProvider.of(context).selectedMemberProfileImage.value!,
        attendingCountFuture: SelectedItemProvider.of(context)
            .selectedMemberAttendingCount
            .value!);
    bloc.loadDevices();
  }

  @override
  Widget build(BuildContext context) => PlatformAwareWidget(
        android: () => _buildAndroidLayout(context),
        ios: () => _buildIOSLayout(context),
      );

  Widget _buildAndroidLayout(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).Details),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => goToEditMemberPage(context),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => showDialog(
              context: context,
              builder: (context) => DeleteItemDialog(
                title: S.of(context).MemberDeleteDialogTitle,
                description: S.of(context).MemberDeleteDialogDescription,
                errorDescription: S.of(context).GenericError,
                onDelete: () => onDeleteMember(context),
              ),
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
        Expanded(
            child: MemberDevicesList(
          future: bloc.devicesFuture,
          onDeleteDevice: bloc.deleteDevice,
          onAddDeviceButtonPressed: () => goToAddDevicePage(context),
        )),
      ],
    );
  }

  Widget _buildIOSLayout(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Row(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(S.of(context).Details),
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CupertinoIconButton.fromAppTheme(
                  icon: CupertinoIcons.pencil,
                  onPressed: () => goToEditMemberPage(context),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: CupertinoIconButton.fromAppTheme(
                    icon: CupertinoIcons.delete,
                    onPressed: () => showCupertinoDialog(
                      context: context,
                      builder: (context) => DeleteItemDialog(
                        title: S.of(context).MemberDeleteDialogTitle,
                        description:
                            S.of(context).MemberDeleteDialogDescription,
                        errorDescription: S.of(context).GenericError,
                        onDelete: () => onDeleteMember(context),
                      ),
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
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10),
              child: PlatformAwareWidget(
                android: () => AsyncProfileImage(
                  icon: Icons.person,
                  size: 75,
                  personInitials: bloc.member.initials,
                  future: bloc.profileImage,
                ),
                ios: () => AsyncProfileImage(
                  icon: CupertinoIcons.person_fill,
                  size: 75,
                  personInitials: bloc.member.initials,
                  future: bloc.profileImage,
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(bloc.member.firstname,
                      style: ApplicationTheme.memberListItemFirstNameTextStyle
                          .copyWith(fontSize: 25, fontWeight: FontWeight.w500),
                      overflow: TextOverflow.ellipsis),
                  Text(bloc.member.lastname,
                      style: ApplicationTheme.memberListItemLastNameTextStyle
                          .copyWith(fontSize: 20),
                      overflow: TextOverflow.ellipsis),
                  if (bloc.member.alias.isNotEmpty)
                    Text(
                      "'${bloc.member.alias}'",
                      style: ApplicationTheme.memberListItemLastNameTextStyle
                          .copyWith(fontSize: 15, fontStyle: FontStyle.italic),
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5, left: 10, right: 10),
          child: Row(
            children: [
              MemberAttendingCount(
                future: bloc.attendingCountFuture,
              ),
              const Expanded(
                child: Center(),
              ),
              MemberActiveToggle(
                initialValue: bloc.member.isActiveMember,
                label: S.of(context).Active,
                stream: bloc.isActiveStream,
                onChanged: (bool value) =>
                    onMemberActiveChanged(value, context),
                onErrorBuilder: () => PlatformAwareWidget(
                  android: () => Switch(
                    value: bloc.member.isActiveMember,
                    onChanged: null,
                  ),
                  ios: () => CupertinoSwitch(
                    value: bloc.member.isActiveMember,
                    onChanged: null,
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  void goToAddDevicePage(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const AddDevicePage()))
        .then((_) {
      final reloadDevicesNotifier =
          ReloadDataProvider.of(context).reloadDevices;
      if (reloadDevicesNotifier.value) {
        reloadDevicesNotifier.value = false;
        setState(() => bloc.loadDevices());
      }
    });
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }
}