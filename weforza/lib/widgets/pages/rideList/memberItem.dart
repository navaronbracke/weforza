
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weforza/blocs/rideListMemberItemBloc.dart';
import 'package:weforza/model/member.dart';
import 'package:weforza/theme/appTheme.dart';
import 'package:weforza/widgets/custom/profileImage/profileImage.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

///This [Widget] represents a [Member] within the 'Attendees' content panel of [RideListPage].
class MemberItem extends StatelessWidget implements PlatformAwareWidget {
  MemberItem(this._bloc): assert(_bloc != null);
  ///The BLoC for this item.
  final RideListMemberItemBloc _bloc;

  @override
  Widget build(BuildContext context) => PlatformAwareWidgetBuilder.build(context, this);

  @override
  Widget buildAndroidWidget(BuildContext context) {
    return Card(
      elevation: 4.0,
      child: InkWell(
        onTap: (){
          //TODO: add/remove person from selected ride
          //TODO change background
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _loadImage(),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(_bloc.firstName,style: ApplicationTheme.memberListItemFirstNameTextStyle,overflow: TextOverflow.ellipsis),
                  SizedBox(height: 5),
                  Text(_bloc.lastName,style: ApplicationTheme.memberListItemLastNameTextStyle,overflow: TextOverflow.ellipsis),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget buildIosWidget(BuildContext context) {
    // TODO: implement buildIosWidget
    return Container(
      child: GestureDetector(
        onTap: (){
          //TODO: add/remove person from selected ride
          //TODO change background
        },
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _loadImage(),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(_bloc.firstName,style: ApplicationTheme.memberListItemFirstNameTextStyle,overflow: TextOverflow.ellipsis),
                  SizedBox(height: 5),
                  Text(_bloc.lastName,style: ApplicationTheme.memberListItemLastNameTextStyle,overflow: TextOverflow.ellipsis),
                ],
              ),
            ],
            ),
          ),
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
              return ProfileImage(null,40);
            }
            return ProfileImage(snapshot.data as File,40);
          } else {
            return ProfileImage(null,40);
          }
        }
    );
  }
}