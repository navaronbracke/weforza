import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weforza/blocs/memberDetailsBloc.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/injection/injector.dart';
import 'package:weforza/model/device.dart';
import 'package:weforza/model/member.dart';
import 'package:weforza/provider/deviceProvider.dart';
import 'package:weforza/provider/memberProvider.dart';
import 'package:weforza/repository/deviceRepository.dart';
import 'package:weforza/repository/memberRepository.dart';
import 'package:weforza/theme/appTheme.dart';
import 'package:weforza/widgets/custom/profileImage/profileImage.dart';
import 'package:weforza/widgets/pages/deviceManagement/deviceManagementPage.dart';
import 'package:weforza/widgets/pages/editMember/editMemberPage.dart';
import 'package:weforza/widgets/pages/memberDetails/deleteMemberDialog.dart';
import 'package:weforza/widgets/pages/memberDetails/memberDevices.dart';
import 'package:weforza/widgets/pages/memberDetails/memberDevicesEmpty.dart';
import 'package:weforza/widgets/pages/memberDetails/memberDevicesError.dart';
import 'package:weforza/widgets/platform/cupertinoIconButton.dart';
import 'package:weforza/widgets/platform/platformAwareLoadingIndicator.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

///This class represents the detail page for a [Member].
class MemberDetailsPage extends StatefulWidget {

  @override
  _MemberDetailsPageState createState() => _MemberDetailsPageState(
      MemberDetailsBloc(InjectionContainer.get<MemberRepository>(),InjectionContainer.get<DeviceRepository>())
  );
}

///This is the [State] class for [MemberDetailsPage].
class _MemberDetailsPageState extends State<MemberDetailsPage> implements DeleteMemberHandler {
  _MemberDetailsPageState(this._bloc): assert(_bloc != null);

  ///The BLoC in charge of the content.
  final MemberDetailsBloc _bloc;

  Future<List<Device>> devicesFuture;

  Future<int> attendingCountFuture;

  @override
  void initState() {
    super.initState();
    devicesFuture = _bloc.getMemberDevices(MemberProvider.selectedMember.uuid);
    attendingCountFuture = _bloc.getAttendingCount(MemberProvider.selectedMember.uuid);
  }

  @override
  Widget build(BuildContext context)=> PlatformAwareWidget(
    android: () => _buildAndroidLayout(context),
    ios: () => _buildIOSLayout(context),
  );

  Widget _buildAndroidLayout(BuildContext context) {
    final member = MemberProvider.selectedMember;
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).MemberDetailsTitle),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: ()=> Navigator.push(context, MaterialPageRoute(builder: (context) => EditMemberPage())),
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: ()=> showDialog(context: context,barrierDismissible: false, builder: (context)=> DeleteMemberDialog(this)),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: ProfileImage(image: member.profileImage),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(member.firstName,style: ApplicationTheme.memberListItemFirstNameTextStyle.copyWith(fontSize: 25,fontWeight: FontWeight.w500),overflow: TextOverflow.ellipsis),
                        Text(member.lastName,style: ApplicationTheme.memberListItemLastNameTextStyle.copyWith(fontSize: 20),overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Center(
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.phone),
                          SizedBox(width: 5),
                          Text(member.phone),
                        ],
                        mainAxisAlignment: MainAxisAlignment.center,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: _buildAttendingCountWidget(),
                    ),
                  ),
                  //tel/count
                ],
              ),
            ],
          ),
          Expanded(
              child: _buildDevicesList()
          ),
        ],
      ),
    );
  }

  Widget _buildIOSLayout(BuildContext context) {
    final member = MemberProvider.selectedMember;
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Row(
          children: <Widget>[
            Expanded(
              child: Center(child: Text(S.of(context).MemberDetailsTitle)),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CupertinoIconButton(
                    onPressedColor: ApplicationTheme.primaryColor,
                    idleColor: ApplicationTheme.accentColor,
                    icon: Icons.edit,
                    onPressed: ()=> Navigator.push(context, MaterialPageRoute(builder: (context) => EditMemberPage()))),
                SizedBox(width: 10),
                CupertinoIconButton(
                    onPressedColor: ApplicationTheme.primaryColor,
                    idleColor: ApplicationTheme.accentColor,
                    icon: Icons.delete,
                    onPressed: ()=> showCupertinoDialog(context: context,builder: (context)=> DeleteMemberDialog(this))
                ),
              ],
            ),
          ],
        ),
        transitionBetweenRoutes: false,
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: <Widget>[
            Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: ProfileImage(image: member.profileImage),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(member.firstName,style: ApplicationTheme.memberListItemFirstNameTextStyle.copyWith(fontSize: 25,fontWeight: FontWeight.w500),overflow: TextOverflow.ellipsis),
                          Text(member.lastName,style: ApplicationTheme.memberListItemLastNameTextStyle.copyWith(fontSize: 20),overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Center(
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.phone),
                            SizedBox(width: 5),
                            Text(member.phone),
                          ],
                          mainAxisAlignment: MainAxisAlignment.center,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: _buildAttendingCountWidget(),
                      ),
                    ),
                    //tel/count
                  ],
                ),
              ],
            ),
            Expanded(
                child: _buildDevicesList()
            ),
          ],
        ),
      ),
    );
  }

  ///Build the list of devices.
  Widget _buildDevicesList(){
    return FutureBuilder<List<Device>>(
      future: devicesFuture,
      builder: (context,snapshot){
        if(snapshot.connectionState == ConnectionState.done){
          if(snapshot.hasError){
            return MemberDevicesError();
          }else{
            //init the callback, either with an empty list or with devices.
            final onPressed = (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>
                  DeviceManagementPage(devices: snapshot.data),
              )).then((_)=> (){
                if(DeviceProvider.reloadDevices){
                  DeviceProvider.reloadDevices = false;
                  setState(() {
                    devicesFuture = _bloc.getMemberDevices(MemberProvider.selectedMember.uuid);
                  });
                }
              });
            };
            return snapshot.data.isEmpty ? MemberDevicesEmpty(onPressed: onPressed) :
            MemberDevices(devices: snapshot.data,onEditPressed: onPressed);
          }
        }else{
          return Center(child: PlatformAwareLoadingIndicator());
        }
      },
    );
  }

  ///Build the attending count widget.
  Widget _buildAttendingCountWidget(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(Icons.location_on),
        SizedBox(width: 5),
        FutureBuilder<int>(
          future: attendingCountFuture,
          builder: (context,snapshot){
            if(snapshot.connectionState == ConnectionState.done){
              if(snapshot.hasError){
                return Text("?");
              }
              return Text("${snapshot.data}");
            }else{
              return PlatformAwareLoadingIndicator();
            }
          },
        )
      ],
    );
  }

  @override
  Future<void> deleteMember() => _bloc.deleteMember(MemberProvider.selectedMember.uuid);
}