import 'package:dependencies_flutter/dependencies_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/blocs/personListBloc.dart';
import 'package:weforza/generated/i18n.dart';
import 'package:weforza/model/person.dart';
import 'package:weforza/theme/appTheme.dart';
import 'package:weforza/widgets/loadingIndicator.dart';
import 'package:weforza/widgets/platformAwareWidgetBuilder.dart';

///This [Widget] will display all known people.
class PersonListPage extends StatefulWidget {
  @override
  _PersonListPageState createState() => _PersonListPageState();
}

///This is the [State] class for [PersonListPage].
class _PersonListPageState extends State<PersonListPage> implements PlatformAwareWidget {
  ///The BLoC for this widget.
  ///Note: This object isn't final, since we need the BuildContext to fetch it.
  ///The BLoC is private and registered as singleton, so this doesn't cause problems.
  PersonListBloc _bloc;

  //TODO import/export actions
  ///Layout
  ///
  /// - AppBar (title + add person action)
  /// - List || Empty || Loading || Error
  @override
  Widget buildAndroidWidget(BuildContext context) {
    _bloc = InjectorWidget.of(context).get<PersonListBloc>();
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
        ],
      ),
      body: _listBuilder(_bloc.getKnownPeople(), _PersonListPageLoading(),
          _PersonListPageError(), _PersonListPageEmpty()),
    );
  }

  ///Layout
  ///
  /// - NavigationBar (title + add person action)
  /// - List || Empty || Loading || Error
  @override
  Widget buildIosWidget(BuildContext context) {
    _bloc = InjectorWidget.of(context).get<PersonListBloc>();
    //Add person + list
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(S.of(context).PersonCatalogTitle),
        trailing: GestureDetector(
          child: Icon(
            CupertinoIcons.person_add
          ),
          onTap: (){
            //TODO go to add person screen
          },
        ),
      ),
      child: _listBuilder(_bloc.getKnownPeople(), _PersonListPageLoading(),
          _PersonListPageError(), _PersonListPageEmpty()),
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
            if (data.isEmpty) {
              return empty;
            } else {
              return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) =>
                      _PersonListPageListTile(data[index]));
            }
          }
        } else {
          return loading;
        }
      },
    );
  }
}

///This class represents a [ListTile] for an item of [PersonListPage].
class _PersonListPageListTile extends StatelessWidget
    implements PlatformAwareWidget {
  _PersonListPageListTile(this._person);

  final Person _person;

  @override
  Widget build(BuildContext context) =>
      PlatformAwareWidgetBuilder.buildPlatformAwareWidget(context, this);

  @override
  Widget buildAndroidWidget(BuildContext context) {
    return ListTile(
      title: Row(
        children: <Widget>[
          //First/Last name
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
    return ListTile(
      title: Row(
        children: <Widget>[
          //First/Last name
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
            child: GestureDetector(
              child: Icon(
                CupertinoIcons.search,
                color: Theme.of(context).primaryColor
              ),
              onTap: (){
                //TODO go to person details
              },
            ),
          ),
        ],
      ),
    );
  }
}

///This class represents an error [Widget] for [PersonListPage].
class _PersonListPageError extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Center(
        child: Text(S.of(context).PersonCatalogLoadingFailed),
      );
}

///This class represents a loading [Widget] for [PersonListPage].
class _PersonListPageLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          PlatformAwareLoadingIndicator(),
          SizedBox(height: 5),
          Text(S.of(context).PersonCatalogLoadingInProgress),
        ],
      ),
    );
  }
}

///This class represents an 'empty list' [Widget] for [PersonListPage].
class _PersonListPageEmpty extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(S.of(context).PersonCatalogNoItems),
          SizedBox(height: 5),
          Text(S.of(context).PersonCatalogAddPersonInstruction)
        ],
      ),
    );
  }
}
