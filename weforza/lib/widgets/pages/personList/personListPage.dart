import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/blocs/personListBloc.dart';
import 'package:weforza/injection/injector.dart';
import 'package:weforza/generated/i18n.dart';
import 'package:weforza/model/person.dart';
import 'package:weforza/widgets/pages/personList/personListEmpty.dart';
import 'package:weforza/widgets/pages/personList/personListError.dart';
import 'package:weforza/widgets/pages/personList/personListItem.dart';
import 'package:weforza/widgets/pages/personList/personListLoading.dart';
import 'package:weforza/widgets/platformAwareWidgetBuilder.dart';

///This [Widget] will display all known people.
class PersonListPage extends StatefulWidget {

  @override
  _PersonListPageState createState() => _PersonListPageState(InjectionContainer.get<PersonListBloc>());
}

///This is the [State] class for [PersonListPage].
class _PersonListPageState extends State<PersonListPage> implements PlatformAwareWidget {
  _PersonListPageState(this._bloc): assert(_bloc != null);

  ///The BLoC for this widget.
  final PersonListBloc _bloc;


  //TODO import/export actions
  ///Layout
  ///
  /// - AppBar (title + add person action)
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
            onPressed: () {
              //TODO: go to add person screen
            },
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
      body: _listBuilder(_bloc.getKnownPeople(), PersonListPageLoading(),
          PersonListPageError(), PersonListPageEmpty()),
    );
  }

  ///Layout
  ///
  /// - NavigationBar (title + add person action)
  /// - List || Empty || Loading || Error
  @override
  Widget buildIosWidget(BuildContext context) {
    //Add person + list
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(S.of(context).PersonCatalogTitle),
        trailing: GestureDetector(
          child: Icon(
            Icons.person_add
          ),
          onTap: (){
            //TODO go to add person screen
          },
        ),
      ),
      child: _listBuilder(_bloc.getKnownPeople(), PersonListPageLoading(),
          PersonListPageError(), PersonListPageEmpty()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlatformAwareWidgetBuilder.buildPlatformAwareWidget(context, this);
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  ///Build a [FutureBuilder] that will construct the main body of this widget.
  ///
  ///Displays [loading] when [future] is still busy.
  ///Displays [error] when [future] completed with an error.
  ///Displays [empty] when [future] completed, but there is nothing to show
  ///Displays a list of [_PersonListPageListTile] when there is data.
  FutureBuilder _listBuilder(
      Future<List<Person>> future, Widget loading, Widget error, Widget empty) {
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return error;
          } else {
            List<Person> data = snapshot.data as List<Person>;
            return data.isEmpty ? empty : ListView.builder(itemCount: data.length, itemBuilder: (context, index) => PersonListPageListItem(data[index]));
          }
        } else {
          return loading;
        }
      },
    );
  }
}


