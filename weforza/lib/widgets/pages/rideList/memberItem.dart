
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weforza/blocs/rideListAttendeeItemBloc.dart';
import 'package:weforza/model/member.dart';
import 'package:weforza/theme/appTheme.dart';
import 'package:weforza/widgets/custom/profileImage/profileImage.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

///This [Widget] represents a [Member] within the 'Attendees' content panel of [RideListPage].
class MemberItem extends StatefulWidget {
  MemberItem(this.bloc,this.image): assert(bloc != null);
  ///The BLoC for this item.
  final RideListAttendeeItemBloc bloc;

  ///The image for this item.
  final File image;

  @override
  _MemberItemState createState() => _MemberItemState();
}

class _MemberItemState extends State<MemberItem> implements PlatformAwareWidget {

  //(un)select

  @override
  Widget build(BuildContext context) => PlatformAwareWidgetBuilder.build(context, this);

  @override
  Widget buildAndroidWidget(BuildContext context) {
    return Card(
      color: widget.bloc.isSelected ? ApplicationTheme.rideListItemSelectedColor : ApplicationTheme.rideListItemUnselectedColor,
      elevation: 4.0,
      child: InkWell(
        splashColor: ApplicationTheme.rideListItemSplashColor,
        onTap: (){
          //TODO: add/remove person from selected ride
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ProfileImage(widget.image,40),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(widget.bloc.firstName,style: ApplicationTheme.memberListItemFirstNameTextStyle.copyWith(
                    color: widget.bloc.isSelected ? ApplicationTheme.rideListItemSelectedFontColor : ApplicationTheme.rideListItemUnselectedFontColor),
                      overflow: TextOverflow.ellipsis),
                  SizedBox(height: 5),
                  Text(widget.bloc.lastName,style: ApplicationTheme.memberListItemLastNameTextStyle.copyWith(
                      color: widget.bloc.isSelected ? ApplicationTheme.rideListItemSelectedFontColor : ApplicationTheme.rideListItemUnselectedFontColor)
                      ,overflow: TextOverflow.ellipsis),
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
    return Container(
      child: GestureDetector(
        onTap: (){
          //TODO: add/remove person from selected ride
        },
        child: Container(
          color: widget.bloc.isSelected ? ApplicationTheme.rideListItemSelectedColor : ApplicationTheme.rideListItemUnselectedColor,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ProfileImage(widget.image,40),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(widget.bloc.firstName,style: ApplicationTheme.memberListItemFirstNameTextStyle.copyWith(
                        color: widget.bloc.isSelected ? ApplicationTheme.rideListItemSelectedFontColor : ApplicationTheme.rideListItemUnselectedFontColor),
                        overflow: TextOverflow.ellipsis),
                    SizedBox(height: 5),
                    Text(widget.bloc.lastName,style: ApplicationTheme.memberListItemLastNameTextStyle.copyWith(
                        color: widget.bloc.isSelected ? ApplicationTheme.rideListItemSelectedFontColor : ApplicationTheme.rideListItemUnselectedFontColor)
                        ,overflow: TextOverflow.ellipsis),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}