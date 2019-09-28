import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weforza/generated/i18n.dart';
import 'package:weforza/model/person.dart';
import 'package:weforza/theme/appTheme.dart';
import 'package:weforza/widgets/platformAwareWidgetBuilder.dart';

///This class represents a list item of [PersonListPage].
class PersonListPageListItem extends StatelessWidget implements PlatformAwareWidget {
  PersonListPageListItem(this._person);

  final Person _person;

  @override
  Widget build(BuildContext context) => PlatformAwareWidgetBuilder.buildPlatformAwareWidget(context, this);

  @override
  Widget buildAndroidWidget(BuildContext context) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(_person.getFirstName(),style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400),overflow: TextOverflow.ellipsis),
                    SizedBox(height: 4),
                    Text(_person.getLastName(),style: TextStyle(fontSize: 12)),
                    SizedBox(height: 10),
                    Text(S.of(context).PersonCatalogPhoneFormat(_person.getPhone()),style: TextStyle(fontSize: 12),overflow: TextOverflow.ellipsis),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            width: 40,
            child: IconButton(
              icon: Icon(Icons.search, color: Theme.of(context).primaryColor),
              splashColor: ApplicationTheme.goToPersonDetailSplashColor,
              onPressed: (){
                //TODO: navigate to person details
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget buildIosWidget(BuildContext context) {
    return SafeArea(
      child: Row(
        children: <Widget>[
          //First/Last name
          Expanded(
            child: Row(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(_person.getFirstName(),style: TextStyle(fontSize: 18,fontWeight: FontWeight.w400),overflow: TextOverflow.ellipsis),
                    SizedBox(height: 4),
                    Text(_person.getLastName(),style: TextStyle(fontSize: 14)),
                    SizedBox(height: 10),
                    Text(S.of(context).PersonCatalogPhoneFormat(_person.getPhone()),style: TextStyle(fontSize: 14),overflow: TextOverflow.ellipsis),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            width: 40,
            child: GestureDetector(
              child: Icon(
                Icons.search,
                color: ApplicationTheme.iosPrimaryColor,
              ),
              onTap: (){
                //TODO
              },
            ),
          ),
        ],
      ),
    );
  }
}