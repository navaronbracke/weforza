import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/blocs/memberListBloc.dart';
import 'package:weforza/generated/i18n.dart';
import 'package:weforza/injection/injector.dart';
import 'package:weforza/model/memberItem.dart';
import 'package:weforza/provider/memberProvider.dart';
import 'package:weforza/repository/memberRepository.dart';
import 'package:weforza/widgets/common/memberWithPictureListItem.dart';
import 'package:weforza/widgets/pages/addMember/addMemberPage.dart';
import 'package:weforza/widgets/pages/memberDetails/memberDetailsPage.dart';
import 'package:weforza/widgets/pages/memberList/memberListEmpty.dart';
import 'package:weforza/widgets/pages/memberList/memberListError.dart';
import 'package:weforza/widgets/platform/cupertinoIconButton.dart';
import 'package:weforza/widgets/platform/platformAwareLoadingIndicator.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

///This [Widget] will display a list of members.
class MemberListPage extends StatefulWidget {
  @override
  _MemberListPageState createState() => _MemberListPageState(MemberListBloc(InjectionContainer.get<MemberRepository>()));
}

///This is the [State] class for [MemberListPage].
class _MemberListPageState extends State<MemberListPage> {
  _MemberListPageState(this._bloc): assert(_bloc != null){
    _onReload = (){
      if(MemberProvider.reloadMembers){
        MemberProvider.reloadMembers = false;
        setState(() {
          membersFuture = _bloc.loadMembers();
        });
      }
    };
  }

  final MemberListBloc _bloc;

  Future<List<MemberItem>> membersFuture;

  ///This callback triggers a reload.
  VoidCallback _onReload;

  @override
  Widget build(BuildContext context) => PlatformAwareWidget(
    android: () => _buildAndroidWidget(context),
    ios: () => _buildIosWidget(context),
  );

  @override
  void initState() {
    super.initState();
    membersFuture = _bloc.loadMembers();
  }

  Widget _buildAndroidWidget(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).MemberListTitle),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.person_add, color: Colors.white),
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context)=> AddMemberPage()))
                .then((_)=>_onReload()),
          ),
        ],
      ),
      body: _listBuilder(membersFuture),
    );
  }

  Widget _buildIosWidget(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        transitionBetweenRoutes: false,
        middle: Row(
          children: <Widget>[
            Expanded(child: Center(child: Text(S.of(context).MemberListTitle))),
            CupertinoIconButton(Icons.person_add,CupertinoTheme.of(context).primaryColor,CupertinoTheme.of(context).primaryContrastingColor,(){
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=> AddMemberPage()))
                  .then((_)=>_onReload());
            }),
          ],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: _listBuilder(membersFuture),
      ),
    );
  }

  Widget _listBuilder(Future<List<MemberItem>> future) {
    return FutureBuilder<List<MemberItem>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return MemberListError();
          } else {
            List<MemberItem> data = snapshot.data;
            return (data == null || data.isEmpty) ? MemberListEmpty() : ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) =>
                    MemberWithPictureListItem(
                      item: data[index], onTap:(){
                      MemberProvider.selectedMember = data[index];
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=> MemberDetailsPage())).then((_)=> _onReload());
                    }));
          }
        } else {
          return Center(child: PlatformAwareLoadingIndicator());
        }
      },
    );
  }
}
