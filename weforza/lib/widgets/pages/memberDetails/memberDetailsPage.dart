
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weforza/blocs/memberDetailsBloc.dart';
import 'package:weforza/generated/i18n.dart';
import 'package:weforza/injection/injector.dart';
import 'package:weforza/model/member.dart';
import 'package:weforza/theme/appTheme.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

///This class represents the detail page for a [Member].
class MemberDetailsPage extends StatefulWidget {
  @override
  _MemberDetailsPageState createState() => _MemberDetailsPageState(InjectionContainer.get<MemberDetailsBloc>());
}

///This is the [State] class for [MemberDetailsPage].
class _MemberDetailsPageState extends State<MemberDetailsPage> implements PlatformAwareWidget, PlatformAndOrientationAwareWidget {
  _MemberDetailsPageState(this._bloc);

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

  ///Show a dialog that asks the user if the member should be deleted.
  void _showDeleteMemberDialog()=> showDialog(context: context, builder: (context)=> _DeleteMemberDialog());

  @override
  Widget buildAndroidLandscapeLayout(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).MemberDetailsTitle),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: (){
              //TODO: go to edit screen
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: (){
              _showDeleteMemberDialog();
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
                  child: Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        //TODO replace wih image
                        color: Theme.of(context).accentColor
                    ),
                  ),
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
              //TODO: go to edit screen
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: (){
              _showDeleteMemberDialog();
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
                  child: Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        //TODO replace wih image
                        color: Theme.of(context).accentColor
                    ),
                  ),
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
          children: <Widget>[
            GestureDetector(
              child: Icon(Icons.edit),
              onTap: (){
                //TODO goto edit
              },
            ),
            GestureDetector(
              child: Icon(Icons.delete),
              onTap: (){
                _showDeleteMemberDialog();
              },
            ),
          ],
        ),
        transitionBetweenRoutes: false,
      ),
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(10,10, 0, 10),
                  child: Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        //TODO replace wih image
                        color: Theme.of(context).accentColor
                    ),
                  ),
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
  Widget buildIOSPortraitLayout(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(S.of(context).MemberDetailsTitle),
        trailing: Row(
          children: <Widget>[
            GestureDetector(
              child: Icon(Icons.edit),
              onTap: (){
                //TODO goto edit
              },
            ),
            GestureDetector(
              child: Icon(Icons.delete),
              onTap: (){
                _showDeleteMemberDialog();
              },
            ),
          ],
        ),
        transitionBetweenRoutes: false,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        //TODO replace wih image
                        color: Theme.of(context).accentColor
                    ),
                  ),
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
            Navigator.pop(context);
          },
        ),
        FlatButton(
          child: Text(S.of(context).MemberDeleteDialogConfirm,style: TextStyle(color: Colors.red)),
          onPressed: (){
            //TODO delete with bloc and dismiss
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
        FlatButton(
          child: Text(S.of(context).MemberDeleteDialogCancel),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        FlatButton(
          child: Text(S.of(context).MemberDeleteDialogConfirm,style: TextStyle(color: Colors.red)),
          onPressed: (){
            //TODO delete with bloc and dismiss
          },
        ),
      ],
    );
  }
}