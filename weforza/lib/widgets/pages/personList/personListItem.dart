import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weforza/blocs/personSelectBloc.dart';
import 'package:weforza/generated/i18n.dart';
import 'package:weforza/model/person.dart';
import 'package:weforza/theme/appTheme.dart';
import 'package:weforza/widgets/pages/personDetails/personDetailsPage.dart';
import 'package:weforza/widgets/platformAwareWidgetBuilder.dart';

///This class represents a list item of [PersonListPage].
class PersonListPageListItem extends StatelessWidget implements PlatformAwareWidget {
  PersonListPageListItem(this._person,this._selectBloc) : assert(_person != null && _selectBloc != null);

  ///The person for this item.
  final Person _person;

  ///The BLoC that handles the selection.
  final PersonSelectBloc _selectBloc;

  _navigateToPersonDetails (BuildContext context){
    _selectBloc.person = _person;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PersonDetailsPage()),
    );
  }

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
              icon: Icon(Icons.contacts, color: Theme.of(context).primaryColor),
              splashColor: ApplicationTheme.goToPersonDetailSplashColor,
              onPressed: () => _navigateToPersonDetails(context),
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
                Icons.contacts,
                color: ApplicationTheme.iosPrimaryColor,
              ),
              onTap: () => _navigateToPersonDetails(context),
            ),
          ),
        ],
      ),
    );
  }
}