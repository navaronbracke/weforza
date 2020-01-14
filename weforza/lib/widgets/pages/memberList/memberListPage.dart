import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/blocs/memberListBloc.dart';
import 'package:weforza/generated/i18n.dart';
import 'package:weforza/injection/injector.dart';
import 'package:weforza/model/memberItem.dart';
import 'package:weforza/repository/memberRepository.dart';
import 'package:weforza/widgets/pages/addMember/addMemberPage.dart';
import 'package:weforza/widgets/pages/memberList/memberListEmpty.dart';
import 'package:weforza/widgets/pages/memberList/memberListError.dart';
import 'package:weforza/widgets/pages/memberList/memberListItem.dart';
import 'package:weforza/widgets/pages/memberList/memberListLoading.dart';
import 'package:weforza/widgets/platform/cupertinoIconButton.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

///This [Widget] will display a list of members.
class MemberListPage extends StatefulWidget {
  @override
  _MemberListPageState createState() => _MemberListPageState(MemberListBloc(InjectionContainer.get<MemberRepository>()));
}

///This is the [State] class for [MemberListPage].
class _MemberListPageState extends State<MemberListPage> implements PlatformAwareWidget {
  _MemberListPageState(this._bloc): assert(_bloc != null) {
    _onReload = (bool reload){
      if(reload != null && reload){
        setState(() {
          membersFuture = _bloc.loadMembers();
        });
      }
    };
  }

  final MemberListBloc _bloc;

  Future<List<MemberItem>> membersFuture;
  ///This callback triggers a reload.
  Function _onReload;

  @override
  void initState() {
    super.initState();
    membersFuture = _bloc.loadMembers();
  }

  @override
  Widget buildAndroidWidget(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).MemberListTitle),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.person_add, color: Colors.white),
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context)=> AddMemberPage())).then((value){
              if(_onReload != null){
                _onReload(value);
              }
            }),
          ),
        ],
      ),
      body: _listBuilder(membersFuture, MemberListLoading(),
          MemberListError(), MemberListEmpty()),
    );
  }

  @override
  Widget buildIosWidget(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        transitionBetweenRoutes: false,
        middle: Text(S.of(context).MemberListTitle),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CupertinoIconButton(Icons.person_add,CupertinoTheme.of(context).primaryColor,CupertinoTheme.of(context).primaryContrastingColor,(){
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=> AddMemberPage())).then((value){
                if(_onReload != null){
                  _onReload(value);
                }
              });
            })
          ],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: _listBuilder(membersFuture, MemberListLoading(),
            MemberListError(), MemberListEmpty()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlatformAwareWidgetBuilder.build(context, this);
  }

  FutureBuilder _listBuilder(Future<List<MemberItem>> future, Widget loading,
      Widget error, Widget empty) {
    return FutureBuilder<List<MemberItem>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return error;
          } else {
            List<MemberItem> data = snapshot.data;
            return (data == null || data.isEmpty) ? empty : ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) =>
                    MemberListItem(data[index],_onReload));
          }
        } else {
          return loading;
        }
      },
    );
  }
}
