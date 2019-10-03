import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/blocs/personListBloc.dart';
import 'package:weforza/blocs/personSelectBloc.dart';
import 'package:weforza/injection/injector.dart';
import 'package:weforza/generated/i18n.dart';
import 'package:weforza/model/person.dart';
import 'package:weforza/widgets/pages/addPerson/addPersonPage.dart';
import 'package:weforza/widgets/pages/personList/personListEmpty.dart';
import 'package:weforza/widgets/pages/personList/personListError.dart';
import 'package:weforza/widgets/pages/personList/personListItem.dart';
import 'package:weforza/widgets/pages/personList/personListLoading.dart';
import 'package:weforza/widgets/platformAwareWidgetBuilder.dart';

///This [Widget] will display all known people.
class PersonListPage extends StatefulWidget {
  @override
  _PersonListPageState createState() => _PersonListPageState(
      InjectionContainer.get<PersonListBloc>(),
      InjectionContainer.get<PersonSelectBloc>());
}

///This is the [State] class for [PersonListPage].
class _PersonListPageState extends State<PersonListPage>
    implements PlatformAwareWidget {
  _PersonListPageState(this._listBloc, this._selectBloc)
      : assert(_listBloc != null && _selectBloc != null);

  ///The BLoC that handles the list.
  final PersonListBloc _listBloc;

  ///The BLoC that handles the selection.
  final PersonSelectBloc _selectBloc;

  ///Navigate to [AddPersonPage].
  _navigateToAddPerson(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddPersonPage()),
    );
  }

  ///Layout
  ///
  /// - AppBar (title + add person/import/export action)
  /// - List || Empty || Loading || Error
  @override
  Widget buildAndroidWidget(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).PersonCatalogTitle),
        actions: <Widget>[
          //Add person button
          IconButton(
            icon: Icon(Icons.person_add, color: Colors.white),
            onPressed: () => _navigateToAddPerson(context),
          ),
          //Import button
          IconButton(
            icon: Icon(Icons.file_download, color: Colors.white),
            onPressed: () {
              //TODO: go to import file screen
            },
          ),
          IconButton(
            icon: Icon(Icons.file_upload, color: Colors.white),
            onPressed: () {
              //TODO: go to export file screen
            },
          ),
        ],
      ),
      body: _listBuilder(_listBloc.getKnownPeople(), PersonListPageLoading(),
          PersonListPageError(), PersonListPageEmpty(), _selectBloc),
    );
  }

  ///Layout
  ///
  /// - NavigationBar (title + add person/import/export action)
  /// - List || Empty || Loading || Error
  @override
  Widget buildIosWidget(BuildContext context) {
    //Add person + list
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(S.of(context).PersonCatalogTitle),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            GestureDetector(
              child: Icon(Icons.person_add),
              onTap: ()=> _navigateToAddPerson(context),
            ),
            SizedBox(width: 10),
            GestureDetector(
              child: Icon(Icons.file_download),
              onTap: (){
                //TODO goto import file
              },
            ),
            SizedBox(width: 10),
            GestureDetector(
              child: Icon(Icons.file_upload),
              onTap: (){
                //TODO goto export file
              },
            ),
          ],
        ),
      ),
      child: SafeArea(
        child: _listBuilder(_listBloc.getKnownPeople(), PersonListPageLoading(),
            PersonListPageError(), PersonListPageEmpty(), _selectBloc),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlatformAwareWidgetBuilder.buildPlatformAwareWidget(context, this);
  }

  @override
  void dispose() {
    _listBloc.dispose();
    super.dispose();
  }

  ///Build a [FutureBuilder] that will construct the main body of this widget.
  ///
  ///Displays [loading] when [future] is still busy.
  ///Displays [error] when [future] completed with an error.
  ///Displays [empty] when [future] completed, but there is nothing to show.
  ///Displays a list of [_PersonListPageListTile] when there is data.
  FutureBuilder _listBuilder(Future<List<Person>> future, Widget loading,
      Widget error, Widget empty, PersonSelectBloc bloc) {
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return error;
          } else {
            List<Person> data = snapshot.data as List<Person>;
            return data.isEmpty
                ? empty
                : ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) =>
                    PersonListPageListItem(data[index], bloc));
          }
        } else {
          return loading;
        }
      },
    );
  }
}
