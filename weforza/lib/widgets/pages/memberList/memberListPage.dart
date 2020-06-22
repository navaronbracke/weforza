import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/blocs/memberListBloc.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/injection/injector.dart';
import 'package:weforza/model/memberItem.dart';
import 'package:weforza/repository/memberRepository.dart';
import 'package:weforza/theme/appTheme.dart';
import 'package:weforza/widgets/common/memberWithPictureListItem.dart';
import 'package:weforza/widgets/pages/addMember/addMemberPage.dart';
import 'package:weforza/widgets/pages/memberDetails/memberDetailsPage.dart';
import 'package:weforza/widgets/pages/memberList/memberListEmpty.dart';
import 'package:weforza/widgets/pages/memberList/memberListError.dart';
import 'package:weforza/widgets/platform/cupertinoIconButton.dart';
import 'package:weforza/widgets/platform/platformAwareLoadingIndicator.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';
import 'package:weforza/widgets/providers/reloadDataProvider.dart';
import 'package:weforza/widgets/providers/selectedItemProvider.dart';

///This [Widget] will display a list of members.
class MemberListPage extends StatefulWidget {
  @override
  _MemberListPageState createState() => _MemberListPageState(
     bloc: MemberListBloc(InjectionContainer.get<MemberRepository>())
  );
}

///This is the [State] class for [MemberListPage].
class _MemberListPageState extends State<MemberListPage> {
  _MemberListPageState({@required this.bloc}): assert(bloc != null);

  final MemberListBloc bloc;

  @override
  Widget build(BuildContext context) => PlatformAwareWidget(
    android: () => _buildAndroidWidget(context),
    ios: () => _buildIosWidget(context),
  );

  @override
  void initState() {
    super.initState();
    bloc.loadMembersIfNotLoaded();
  }

  Widget _buildAndroidWidget(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).MemberListTitle),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.person_add, color: Colors.white),
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context)=> AddMemberPage())).then((_){
              if(ReloadDataProvider.of(context).reloadMembers.value){
                //TODO reload members
              }
            }),
          ),
        ],
      ),
      body: _buildList(context),
    );
  }

  Widget _buildIosWidget(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        transitionBetweenRoutes: false,
        middle: Row(
          children: <Widget>[
            Expanded(child: Center(child: Text(S.of(context).MemberListTitle))),
            CupertinoIconButton(
                onPressedColor: ApplicationTheme.primaryColor,
                idleColor: ApplicationTheme.accentColor,
                icon: Icons.person_add,
                onPressed: ()=> Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context)=> AddMemberPage())).then((_){
                      if(ReloadDataProvider.of(context).reloadMembers.value){
                        //TODO reload members
                      }
                    })
            ),
          ],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: _buildList(context),
      ),
    );
  }

  Widget _buildList(BuildContext context){
    final listenable = ReloadDataProvider.of(context).reloadMembers;
    return ValueListenableBuilder<bool>(
      valueListenable: listenable,
      child: _listFutureBuilder(bloc.membersFuture),
      builder: (context, reload, child){
        if(reload){
          listenable.value = false;
          bloc.membersFuture = bloc.loadMembers();
        }
        return child;
      },
    );
  }

  Widget _listFutureBuilder(Future<List<MemberItem>> future) {
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
                      item: data[index], onTap: (){
                        SelectedItemProvider.of(context).selectedMember.value = data[index];
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => MemberDetailsPage()));
                    }));
          }
        } else {
          return Center(child: PlatformAwareLoadingIndicator());
        }
      },
    );
  }
}
