import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weforza/blocs/memberDetailsBloc.dart';
import 'package:weforza/generated/i18n.dart';
import 'package:weforza/injection/injector.dart';
import 'package:weforza/model/member.dart';
import 'package:weforza/provider/memberProvider.dart';
import 'package:weforza/repository/deviceRepository.dart';
import 'package:weforza/repository/memberRepository.dart';
import 'package:weforza/theme/appTheme.dart';
import 'package:weforza/widgets/custom/profileImage/profileImage.dart';
import 'package:weforza/widgets/pages/memberDetails/deleteMemberDialog.dart';
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
class _MemberDetailsPageState extends State<MemberDetailsPage> implements PlatformAwareWidget, PlatformAndOrientationAwareWidget, MemberDeleteHandler {
  _MemberDetailsPageState(this._bloc): assert(_bloc != null);

  ///The BLoC in charge of the content.
  final MemberDetailsBloc _bloc;

  @override
  Widget build(BuildContext context) => PlatformAwareWidgetBuilder.build(context, this);

  @override
  Widget buildAndroidWidget(BuildContext context) {
    return OrientationAwareWidgetBuilder.build(context,
        buildAndroidPortraitLayout(context),
        buildAndroidLandscapeLayout(context)
    );
  }

  @override
  Widget buildIosWidget(BuildContext context) {
    return OrientationAwareWidgetBuilder.build(context,
        buildIOSPortraitLayout(context),
        buildIOSLandscapeLayout(context)
    );
  }

  ///Build the list of devices from [_bloc.devices].
  Widget _buildDevicesList(String uuid){
    return FutureBuilder<List<String>>(
      future: _bloc.getMemberDevices(uuid),
      builder: (context,snapshot){
        if(snapshot.connectionState == ConnectionState.done){
          final list = snapshot.data;
          if(list.isEmpty){
            return Center(
              child: Text(S.of(context).MemberDetailsNoDevices),
            );
          }else{
            return ListView.builder(itemBuilder: (context,index){
              //TODO item with buttons
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(list[index]),
              );
            }, itemCount: list.length);
          }
        }else{
          return Center(child: PlatformAwareLoadingIndicator());
        }
      },
    );
  }

  @override
  Widget buildAndroidLandscapeLayout(BuildContext context) {
    final member = MemberProvider.selectedMember;
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).MemberDetailsTitle),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: (){
              //TODO goto edit
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: ()=> showDialog(context: context, builder: (context)=> DeleteMemberDialog(this,member.uuid)),
          ),
        ],
      ),
      body: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(10,10, 0, 10),
                  child: ProfileImage(member.profileImage,ApplicationTheme.profileImagePlaceholderIconColor,ApplicationTheme.profileImagePlaceholderIconBackgroundColor),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10,0,0,0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(member.firstName,style: ApplicationTheme.memberListItemFirstNameTextStyle.copyWith(fontSize: 25,fontWeight: FontWeight.w500),overflow: TextOverflow.ellipsis),
                      Text(member.lastName,style: ApplicationTheme.memberListItemLastNameTextStyle.copyWith(fontSize: 20),overflow: TextOverflow.ellipsis),
                      SizedBox(height: 10),
                      Text(S.of(context).MemberDetailsPhoneFormat(member.phone)),
                      SizedBox(height: 10),
                      FutureBuilder<int>(
                        future: _bloc.getAttendingCount(member.uuid),
                        builder: (context,snapshot){
                          if(snapshot.connectionState == ConnectionState.done){
                            if(snapshot.hasError){
                              return Text(S.of(context).MemberDetailsWasPresentCountLabel(S.of(context).MemberDetailsWasPresentCountError));
                            }
                            return Text(S.of(context).MemberDetailsWasPresentCountLabel("${snapshot.data}"));
                          }else{
                            return Text(S.of(context).MemberDetailsWasPresentCountLabel(S.of(context).MemberDetailsWasPresentCountCalculating));
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(S.of(context).PersonDevicesLabel,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),
                  Expanded(
                    child: _buildDevicesList(member.uuid),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget buildAndroidPortraitLayout(BuildContext context) {
    final member = MemberProvider.selectedMember;
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).MemberDetailsTitle),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: (){
              //TODO goto edit
            }
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: ()=> showDialog(context: context, builder: (context)=> DeleteMemberDialog(this,member.uuid)),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ProfileImage(member.profileImage,ApplicationTheme.profileImagePlaceholderIconColor,ApplicationTheme.profileImagePlaceholderIconBackgroundColor)
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(member.firstName,style: ApplicationTheme.memberListItemFirstNameTextStyle.copyWith(fontSize: 25,fontWeight: FontWeight.w500),overflow: TextOverflow.ellipsis),
                    Text(member.lastName,style: ApplicationTheme.memberListItemLastNameTextStyle.copyWith(fontSize: 20),overflow: TextOverflow.ellipsis),
                    SizedBox(height: 10),
                    Text(S.of(context).MemberDetailsPhoneFormat(member.phone)),
                    SizedBox(height: 10),
                    FutureBuilder<int>(
                      future: _bloc.getAttendingCount(member.uuid),
                      builder: (context,snapshot){
                        if(snapshot.connectionState == ConnectionState.done){
                          if(snapshot.hasError){
                            return Text(S.of(context).MemberDetailsWasPresentCountLabel(S.of(context).MemberDetailsWasPresentCountError));
                          }
                          return Text(S.of(context).MemberDetailsWasPresentCountLabel("${snapshot.data}"));
                        }else{
                          return Text(S.of(context).MemberDetailsWasPresentCountLabel(S.of(context).MemberDetailsWasPresentCountCalculating));
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(S.of(context).PersonDevicesLabel,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),
                Expanded(
                  child: _buildDevicesList(member.uuid),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget buildIOSLandscapeLayout(BuildContext context) {
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
                CupertinoIconButton(Icons.edit,CupertinoTheme.of(context).primaryColor,CupertinoTheme.of(context).primaryContrastingColor,(){
                //TODO goto edit
                }),
                SizedBox(width: 30),
                CupertinoIconButton(Icons.delete,CupertinoTheme.of(context).primaryColor,CupertinoTheme.of(context).primaryContrastingColor,
                        ()=> showCupertinoDialog(context: context,builder: (context)=> DeleteMemberDialog(this,member.uuid))),
              ],
            ),
          ],
        ),
        transitionBetweenRoutes: false,
      ),
      child: SafeArea(
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10,10, 0, 10),
                    child: ProfileImage(member.profileImage,ApplicationTheme.profileImagePlaceholderIconColor,ApplicationTheme.profileImagePlaceholderIconBackgroundColor)
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10,0,0,0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(member.firstName,style: ApplicationTheme.memberListItemFirstNameTextStyle.copyWith(fontSize: 25,fontWeight: FontWeight.w500),overflow: TextOverflow.ellipsis),
                        Text(member.lastName,style: ApplicationTheme.memberListItemLastNameTextStyle.copyWith(fontSize: 20),overflow: TextOverflow.ellipsis),
                        SizedBox(height: 10),
                        Text(S.of(context).MemberDetailsPhoneFormat(member.phone)),
                        SizedBox(height: 10),
                        FutureBuilder<int>(
                          future: _bloc.getAttendingCount(member.uuid),
                          builder: (context,snapshot){
                            if(snapshot.connectionState == ConnectionState.done){
                              if(snapshot.hasError){
                                return Text(S.of(context).MemberDetailsWasPresentCountLabel(S.of(context).MemberDetailsWasPresentCountError));
                              }
                              return Text(S.of(context).MemberDetailsWasPresentCountLabel("${snapshot.data}"));
                            }else{
                              return Text(S.of(context).MemberDetailsWasPresentCountLabel(S.of(context).MemberDetailsWasPresentCountCalculating));
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(S.of(context).PersonDevicesLabel,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),
                    Expanded(
                      child: _buildDevicesList(member.uuid),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget buildIOSPortraitLayout(BuildContext context) {
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
                CupertinoIconButton(Icons.edit,CupertinoTheme.of(context).primaryColor,CupertinoTheme.of(context).primaryContrastingColor,(){
                //TODO goto edit
                }),
                SizedBox(width: 30),
                CupertinoIconButton(Icons.delete,CupertinoTheme.of(context).primaryColor,CupertinoTheme.of(context).primaryContrastingColor,
                        ()=> showCupertinoDialog(context: context,builder: (context)=> DeleteMemberDialog(this,member.uuid))),
              ],
            ),
          ],
        ),
        transitionBetweenRoutes: false,
      ),
      child: SafeArea(
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ProfileImage(member.profileImage,ApplicationTheme.profileImagePlaceholderIconColor,ApplicationTheme.profileImagePlaceholderIconBackgroundColor)
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(member.firstName,style: ApplicationTheme.memberListItemFirstNameTextStyle.copyWith(fontSize: 25,fontWeight: FontWeight.w500),overflow: TextOverflow.ellipsis),
                      Text(member.lastName,style: ApplicationTheme.memberListItemLastNameTextStyle.copyWith(fontSize: 20),overflow: TextOverflow.ellipsis),
                      SizedBox(height: 10),
                      Text(S.of(context).MemberDetailsPhoneFormat(member.phone)),
                      SizedBox(height: 10),
                      FutureBuilder<int>(
                        future: _bloc.getAttendingCount(member.uuid),
                        builder: (context,snapshot){
                          if(snapshot.connectionState == ConnectionState.done){
                            if(snapshot.hasError){
                              return Text(S.of(context).MemberDetailsWasPresentCountLabel(S.of(context).MemberDetailsWasPresentCountError));
                            }
                            return Text(S.of(context).MemberDetailsWasPresentCountLabel("${snapshot.data}"));
                          }else{
                            return Text(S.of(context).MemberDetailsWasPresentCountLabel(S.of(context).MemberDetailsWasPresentCountCalculating));
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(S.of(context).PersonDevicesLabel,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),
                  Expanded(
                    child: _buildDevicesList(member.uuid),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  deleteMember(String uuid) async => await _bloc.deleteMember(uuid);
}