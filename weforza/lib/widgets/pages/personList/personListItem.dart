import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weforza/blocs/personSelectBloc.dart';
import 'package:weforza/generated/i18n.dart';
import 'package:weforza/model/person.dart';
import 'package:weforza/theme/appTheme.dart';
import 'package:weforza/widgets/pages/personDetails/personDetailsPage.dart';
import 'package:weforza/widgets/platformAwareWidgetBuilder.dart';

///This class represents a list item of [PersonListPage].
class PersonListPageListItem extends StatelessWidget
    implements PlatformAwareWidget {
  PersonListPageListItem(this._person, this._selectBloc)
      : assert(_person != null && _selectBloc != null);

  ///The person for this item.
  final Person _person;

  ///The BLoC that handles the selection.
  final PersonSelectBloc _selectBloc;

  _navigateToPersonDetails(BuildContext context) {
    _selectBloc.selectedPerson = _person;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PersonDetailsPage()),
    );
  }

  @override
  Widget build(BuildContext context) =>
      PlatformAwareWidgetBuilder.buildPlatformAwareWidget(context, this);

  ///Layout
  ///
  ///First name, last name and phone are on the left.
  ///A details button is on the right.
  @override
  Widget buildAndroidWidget(BuildContext context) {
    return ListTile(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(_person.firstname,style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.w400),
              overflow: TextOverflow.ellipsis),
          SizedBox(height: 5),
          Text(_person.lastname, style: TextStyle(fontSize: 12)),
          SizedBox(height: 5),
          Text(
              S.of(context).PersonCatalogPhoneFormat(_person.phone),
              style: TextStyle(fontSize: 12),
              overflow: TextOverflow.ellipsis),
        ],
      ),
      trailing: SizedBox(
          width: 40,
          child: IconButton(
            icon: Icon(Icons.contacts, color: Theme.of(context).primaryColor),
            splashColor: ApplicationTheme.goToPersonDetailSplashColor,
            onPressed: () => _navigateToPersonDetails(context),
          ),
        ),
    );
  }

  ///Layout
  ///
  ///First name, last name and phone are on the left.
  ///A details button is on the right.
  @override
  Widget buildIosWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
      child: Row(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(_person.firstname,
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w400),
                  overflow: TextOverflow.ellipsis),
              SizedBox(height: 4),
              Text(_person.lastname,
                  style: TextStyle(fontSize: 14)),
              SizedBox(height: 10),
              Text(
                  S.of(context).PersonCatalogPhoneFormat(_person.phone),
                  style: TextStyle(fontSize: 14),
                  overflow: TextOverflow.ellipsis),
            ],
          ),
          Spacer(flex: 3),
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
