import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/blocs/memberListBloc.dart';
import 'package:weforza/blocs/memberSelectBloc.dart';
import 'package:weforza/injection/injector.dart';
import 'package:weforza/generated/i18n.dart';
import 'package:weforza/model/member.dart';
import 'package:weforza/widgets/pages/addMember/addMemberPage.dart';
import 'package:weforza/widgets/pages/memberList/memberListEmpty.dart';
import 'package:weforza/widgets/pages/memberList/memberListError.dart';
import 'package:weforza/widgets/pages/memberList/memberListItem.dart';
import 'package:weforza/widgets/pages/memberList/memberListLoading.dart';
import 'package:weforza/widgets/platformAwareWidgetBuilder.dart';

///This [Widget] will display a list of members.
class MemberListPage extends StatefulWidget {
  @override
  _MemberListPageState createState() => _MemberListPageState(
      InjectionContainer.get<MemberListBloc>(),
      InjectionContainer.get<MemberSelectBloc>());
}

///This is the [State] class for [MemberListPage].
class _MemberListPageState extends State<MemberListPage>
    implements PlatformAwareWidget {
  _MemberListPageState(this._listBloc, this._selectBloc)
      : assert(_listBloc != null && _selectBloc != null);

  ///The BLoC that handles the list.
  final MemberListBloc _listBloc;

  ///The BLoC that handles the selection.
  final MemberSelectBloc _selectBloc;

  ///Layout
  ///
  /// - AppBar (title + add person/import/export action)
  /// - List || Empty || Loading || Error
  @override
  Widget buildAndroidWidget(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).MemberListTitle),
        actions: <Widget>[
          //Add person button
          IconButton(
            icon: Icon(Icons.person_add, color: Colors.white),
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context)=> AddMemberPage())),
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
      body: _listBuilder(_listBloc.getKnownPeople(), MemberListLoading(),
          MemberListError(), MemberListEmpty(), _selectBloc),
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
        transitionBetweenRoutes: false,
        middle: Text(S.of(context).MemberListTitle),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            GestureDetector(
              child: Icon(Icons.person_add),
              onTap: ()=> Navigator.of(context).push(MaterialPageRoute(builder: (context)=> AddMemberPage())),
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
        child: _listBuilder(_listBloc.getKnownPeople(), MemberListLoading(),
            MemberListError(), MemberListEmpty(), _selectBloc),
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
  ///Displays a list of [MemberListItem] when there is data.
  FutureBuilder _listBuilder(Future<List<Member>> future, Widget loading,
      Widget error, Widget empty, MemberSelectBloc bloc) {
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return error;
          } else {
            List<Member> data = snapshot.data as List<Member>;
            return (data == null || data.isEmpty)
                ? empty
                : ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) =>
                    MemberListItem(data[index], bloc));
          }
        } else {
          return loading;
        }
      },
    );
  }
}
