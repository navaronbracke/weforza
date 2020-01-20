import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weforza/generated/i18n.dart';
import 'package:weforza/model/memberItem.dart';
import 'package:weforza/widgets/pages/addMember/addMemberPage.dart';
import 'package:weforza/widgets/pages/memberList/memberListEmpty.dart';
import 'package:weforza/widgets/pages/memberList/memberListError.dart';
import 'package:weforza/widgets/pages/memberList/memberListItem.dart';
import 'package:weforza/widgets/platform/cupertinoIconButton.dart';
import 'package:weforza/widgets/platform/platformAwareLoadingIndicator.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';
import 'package:weforza/widgets/provider/memberProvider.dart';

///This [Widget] will display a list of members.
class MemberListPage extends StatefulWidget {
  @override
  _MemberListPageState createState() => _MemberListPageState();
}

///This is the [State] class for [MemberListPage].
class _MemberListPageState extends State<MemberListPage> implements PlatformAwareWidget {

  @override
  Widget buildAndroidWidget(BuildContext context) {
    final MemberProvider provider = Provider.of<MemberProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).MemberListTitle),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.person_add, color: Colors.white),
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context)=> AddMemberPage())),
          ),
        ],
      ),
      body: _listBuilder(provider.membersFuture),
    );
  }

  @override
  Widget buildIosWidget(BuildContext context) {
    final MemberProvider provider = Provider.of<MemberProvider>(context);
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        transitionBetweenRoutes: false,
        middle: Row(
          children: <Widget>[
            Expanded(child: Center(child: Text(S.of(context).MemberListTitle))),
            CupertinoIconButton(Icons.person_add,CupertinoTheme.of(context).primaryColor,CupertinoTheme.of(context).primaryContrastingColor,(){
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=> AddMemberPage()));
            }),
          ],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: _listBuilder(provider.membersFuture),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<MemberProvider>(context).loadMembersIfNotLoaded();
    return PlatformAwareWidgetBuilder.build(context, this);
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
                    MemberListItem(data[index]));
          }
        } else {
          return Center(child: PlatformAwareLoadingIndicator());
        }
      },
    );
  }
}
