import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weforza/blocs/memberDetailsBloc.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/injection/injector.dart';
import 'package:weforza/model/member.dart';
import 'package:weforza/repository/deviceRepository.dart';
import 'package:weforza/repository/memberRepository.dart';
import 'package:weforza/theme/appTheme.dart';
import 'package:weforza/widgets/common/memberAttendingCount.dart';
import 'package:weforza/widgets/custom/deleteItemDialog/deleteItemDialog.dart';
import 'package:weforza/widgets/custom/profileImage/asyncProfileImage.dart';
import 'package:weforza/widgets/pages/addDevice/addDevicePage.dart';
import 'package:weforza/widgets/pages/editMember/editMemberPage.dart';
import 'package:weforza/widgets/pages/memberDetails/memberActiveToggle.dart';
import 'package:weforza/widgets/pages/memberDetails/memberDevicesList/memberDevicesList.dart';
import 'package:weforza/widgets/platform/cupertinoIconButton.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';
import 'package:weforza/widgets/providers/reloadDataProvider.dart';
import 'package:weforza/widgets/providers/selectedItemProvider.dart';

///This class represents the detail page for a [Member].
class MemberDetailsPage extends StatefulWidget {

  @override
  _MemberDetailsPageState createState() => _MemberDetailsPageState();
}

///This is the [State] class for [MemberDetailsPage].
class _MemberDetailsPageState extends State<MemberDetailsPage> {

  ///The BLoC in charge of the content.
  MemberDetailsBloc bloc;

  void goToEditMemberPage(BuildContext context){
    Navigator.push(context, MaterialPageRoute(builder: (context) => EditMemberPage())).then((_){
      setState(() {
        bloc.member = SelectedItemProvider.of(context).selectedMember.value;
        bloc.profileImage = SelectedItemProvider.of(context).selectedMemberProfileImage.value;
      });
    });
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
      member: SelectedItemProvider.of(context).selectedMember.value,
      profileImage: SelectedItemProvider.of(context).selectedMemberProfileImage.value,
      attendingCountFuture: SelectedItemProvider.of(context).selectedMemberAttendingCount.value
    );
    bloc.loadDevices();
  }

  @override
  Widget build(BuildContext context)=> PlatformAwareWidget(
    android: () => _buildAndroidLayout(context),
    ios: () => _buildIOSLayout(context),
  );

  Widget _buildAndroidLayout(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).Details),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () => goToEditMemberPage(context),
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => showDialog(
                context: context,
                barrierDismissible: false,
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

  Widget _buildBody(BuildContext context){
    return Column(
      children: <Widget>[
        _buildMemberInfoSection(context),
        Expanded(
            child: MemberDevicesList(
              future: bloc.devicesFuture,
              onDeleteDevice: bloc.deleteDevice,
              onAddDeviceButtonPressed: () => goToAddDevicePage(context),
            )
        ),
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
                    icon: Icons.edit,
                    onPressed: ()=> () => goToEditMemberPage(context),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: CupertinoIconButton.fromAppTheme(
                    icon: Icons.delete,
                    onPressed: ()=> showCupertinoDialog(
                      context: context,
                      builder: (context) => DeleteItemDialog(
                        title: S.of(context).MemberDeleteDialogTitle,
                        description: S.of(context).MemberDeleteDialogDescription,
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

  Widget _buildMemberInfoSection(BuildContext context){
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10),
              child: AsyncProfileImage(
                icon: Icons.person,
                size: 75,
                personInitials: bloc.member.initials,
                future: bloc.profileImage,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                      bloc.member.firstname,
                      style: ApplicationTheme.memberListItemFirstNameTextStyle.copyWith(
                          fontSize: 25,
                          fontWeight: FontWeight.w500
                      ),
                      overflow: TextOverflow.ellipsis),
                  Text(
                      bloc.member.lastname,
                      style: ApplicationTheme.memberListItemLastNameTextStyle.copyWith(
                          fontSize: 20
                      ),
                      overflow: TextOverflow.ellipsis
                  ),
                  if(bloc.member.alias.isNotEmpty)
                    Text(
                      "'${bloc.member.alias}'",
                      style: ApplicationTheme.memberListItemLastNameTextStyle.copyWith(
                          fontSize: 15, fontStyle: FontStyle.italic
                      ),
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
              Expanded(
                child: Center(),
              ),
              MemberActiveToggle(
                initialValue: bloc.member.isActiveMember,
                label: S.of(context).Active,
                stream: bloc.isActiveStream,
                onChanged: bloc.setMemberActive,
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

  void goToAddDevicePage(BuildContext context){
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context)=> AddDevicePage())
    ).then((_){
      final reloadDevicesNotifier = ReloadDataProvider.of(context).reloadDevices;
      if(reloadDevicesNotifier.value){
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