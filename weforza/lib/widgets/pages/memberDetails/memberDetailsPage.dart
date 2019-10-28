
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weforza/blocs/deleteMemberBloc.dart';
import 'package:weforza/blocs/memberDetailsBloc.dart';
import 'package:weforza/generated/i18n.dart';
import 'package:weforza/injection/injector.dart';
import 'package:weforza/model/member.dart';
import 'package:weforza/repository/memberRepository.dart';
import 'package:weforza/theme/appTheme.dart';
import 'package:weforza/widgets/custom/profileImage/profileImage.dart';
import 'package:weforza/widgets/platform/cupertinoIconButton.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

///This class represents the detail page for a [Member].
class MemberDetailsPage extends StatefulWidget {
  @override
  _MemberDetailsPageState createState() => _MemberDetailsPageState(InjectionContainer.get<MemberDetailsBloc>());
}

///This is the [State] class for [MemberDetailsPage].
class _MemberDetailsPageState extends State<MemberDetailsPage> implements PlatformAwareWidget, PlatformAndOrientationAwareWidget {
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
  Widget _buildDevicesList(Widget empty){
    if(_bloc.devices.isEmpty){
      return empty;
    }else{
      return ListView.builder(
        itemCount: _bloc.devices.length,
        itemBuilder: (context, index){
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(_bloc.devices[index]),
          );
        },
      );
    }
  }

  @override
  Widget buildAndroidLandscapeLayout(BuildContext context) {
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
            onPressed: (){
              showDialog(context: context, builder: (context)=> _DeleteMemberDialog(DeleteMemberBloc(InjectionContainer.get<IMemberRepository>(),_bloc.id)))
              .then((value){
                //Member was deleted, go back to list
                if(value){
                  Navigator.pop(context);
                }
              });
            },
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
                  child: _loadImage(),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10,0,0,0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(_bloc.firstName,style: ApplicationTheme.memberListItemFirstNameTextStyle.copyWith(fontSize: 25,fontWeight: FontWeight.w500),overflow: TextOverflow.ellipsis),
                      Text(_bloc.lastName,style: ApplicationTheme.memberListItemLastNameTextStyle.copyWith(fontSize: 20),overflow: TextOverflow.ellipsis),
                      SizedBox(height: 10),
                      Text(S.of(context).MemberDetailsPhoneFormat(_bloc.phone)),
                      SizedBox(height: 10),
                      Text(S.of(context).MemberDetailsWasPresentCountLabel("${_bloc.wasPresentCount}")),
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
                    child: _buildDevicesList(_MemberDetailsDevicesEmpty()),
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
            onPressed: (){
              showDialog(context: context, builder: (context)=> _DeleteMemberDialog(DeleteMemberBloc(InjectionContainer.get<IMemberRepository>(),_bloc.id)))
                  .then((value){
                    //Member was deleted, go back to list
                    if(value){
                      Navigator.pop(context);
                    }
                  });
            },
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
                  child: _loadImage()
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(_bloc.firstName,style: ApplicationTheme.memberListItemFirstNameTextStyle.copyWith(fontSize: 25,fontWeight: FontWeight.w500),overflow: TextOverflow.ellipsis),
                    Text(_bloc.lastName,style: ApplicationTheme.memberListItemLastNameTextStyle.copyWith(fontSize: 20),overflow: TextOverflow.ellipsis),
                    SizedBox(height: 10),
                    Text(S.of(context).MemberDetailsPhoneFormat(_bloc.phone)),
                    SizedBox(height: 10),
                    Text(S.of(context).MemberDetailsWasPresentCountLabel("${_bloc.wasPresentCount}")),
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
                  child: _buildDevicesList(_MemberDetailsDevicesEmpty()),
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
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(S.of(context).MemberDetailsTitle),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CupertinoIconButton(Icons.edit,CupertinoTheme.of(context).primaryColor,CupertinoTheme.of(context).primaryContrastingColor,(){
              //TODO goto edit
            }),
            SizedBox(width: 30),
            CupertinoIconButton(Icons.delete,CupertinoTheme.of(context).primaryColor,CupertinoTheme.of(context).primaryContrastingColor,(){
              showCupertinoDialog(context: context,builder: (context)=> _DeleteMemberDialog(DeleteMemberBloc(InjectionContainer.get<IMemberRepository>(),_bloc.id)))
                  .then((value){
                //Member was deleted, go back to list
                if(value){
                  Navigator.pop(context);
                }
              });
            }),
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
                    child: _loadImage()
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10,0,0,0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(_bloc.firstName,style: ApplicationTheme.memberListItemFirstNameTextStyle.copyWith(fontSize: 25,fontWeight: FontWeight.w500),overflow: TextOverflow.ellipsis),
                        Text(_bloc.lastName,style: ApplicationTheme.memberListItemLastNameTextStyle.copyWith(fontSize: 20),overflow: TextOverflow.ellipsis),
                        SizedBox(height: 10),
                        Text(S.of(context).MemberDetailsPhoneFormat(_bloc.phone)),
                        SizedBox(height: 10),
                        Text(S.of(context).MemberDetailsWasPresentCountLabel("${_bloc.wasPresentCount}")),
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
                      child: _buildDevicesList(_MemberDetailsDevicesEmpty()),
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
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(S.of(context).MemberDetailsTitle),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CupertinoIconButton(Icons.edit,CupertinoTheme.of(context).primaryColor,CupertinoTheme.of(context).primaryContrastingColor,(){
              //TODO goto edit
            }),
            SizedBox(width: 30),
            CupertinoIconButton(Icons.delete,CupertinoTheme.of(context).primaryColor,CupertinoTheme.of(context).primaryContrastingColor,(){
              showCupertinoDialog(context: context,builder: (context)=> _DeleteMemberDialog(DeleteMemberBloc(InjectionContainer.get<IMemberRepository>(),_bloc.id)))              .then((value){
                //Member was deleted, go back to list
                if(value){
                  Navigator.pop(context);
                }
              });
            }),
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
                    child: _loadImage()
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(_bloc.firstName,style: ApplicationTheme.memberListItemFirstNameTextStyle.copyWith(fontSize: 25,fontWeight: FontWeight.w500),overflow: TextOverflow.ellipsis),
                      Text(_bloc.lastName,style: ApplicationTheme.memberListItemLastNameTextStyle.copyWith(fontSize: 20),overflow: TextOverflow.ellipsis),
                      SizedBox(height: 10),
                      Text(S.of(context).MemberDetailsPhoneFormat(_bloc.phone)),
                      SizedBox(height: 10),
                      Text(S.of(context).MemberDetailsWasPresentCountLabel("${_bloc.wasPresentCount}")),
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
                    child: _buildDevicesList(_MemberDetailsDevicesEmpty()),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _loadImage() {
    return FutureBuilder(
      future: _bloc.getImage(),
      builder: (context,snapshot){
        if(snapshot.connectionState == ConnectionState.done){
          if(snapshot.hasError){
            return ProfileImage(null,100);
          }
          return ProfileImage(snapshot.data as File,100);
        } else {
          return ProfileImage(null,100);
        }
      }
    );
  }
}

///This [Widget] is displayed when a member that is displayed in [MemberDetailsPage] has no devices.
class _MemberDetailsDevicesEmpty extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(S.of(context).MemberDetailsNoDevices),
          Text(S.of(context).MemberDetailsAddDevicesInstruction),
        ],
      ),
    );
  }
}

///This [Widget] is the dialog for deleting a member in [MemberDetailsPage].
class _DeleteMemberDialog extends StatelessWidget implements PlatformAwareWidget {
  _DeleteMemberDialog(this._bloc);

  ///The Bloc that handles a submit.
  final DeleteMemberBloc _bloc;

  @override
  Widget build(BuildContext context) => PlatformAwareWidgetBuilder.build(context, this);

  @override
  Widget buildAndroidWidget(BuildContext context) {
    return AlertDialog(
      title: Text(S.of(context).MemberDeleteDialogTitle),
      content: Text(S.of(context).MemberDeleteDialogDescription),
      actions: <Widget>[
        FlatButton(
          child: Text(S.of(context).MemberDeleteDialogCancel),
          onPressed: (){
            Navigator.pop(context,false);
          },
        ),
        FlatButton(
          child: Text(S.of(context).MemberDeleteDialogConfirm,style: TextStyle(color: Colors.red)),
          onPressed: () async {
            await _bloc.deleteMember();
            Navigator.pop(context,true);
          },
        ),
      ],
    );
  }

  @override
  Widget buildIosWidget(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(S.of(context).MemberDeleteDialogTitle),
      content: Text(S.of(context).MemberDeleteDialogDescription),
      actions: <Widget>[
        CupertinoButton(
          child: Text(S.of(context).MemberDeleteDialogCancel),
          onPressed: (){
            Navigator.pop(context,false);
          },
        ),
        CupertinoButton(
          child: Text(S.of(context).MemberDeleteDialogConfirm,style: TextStyle(color: Colors.red)),
          onPressed: () async {
            await _bloc.deleteMember();
            Navigator.pop(context,true);
          },
        ),
      ],
    );
  }
}