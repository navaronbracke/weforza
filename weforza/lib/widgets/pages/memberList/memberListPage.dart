import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/generated/i18n.dart';
import 'package:weforza/injection/injector.dart';
import 'package:weforza/model/member.dart';
import 'package:weforza/repository/memberLoader.dart';
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
  MemberListPage(this.loader): assert(loader != null);

  final MemberLoader loader;

  @override
  _MemberListPageState createState() => _MemberListPageState(InjectionContainer.get<IMemberRepository>());
}

///This is the [State] class for [MemberListPage].
class _MemberListPageState extends State<MemberListPage> implements PlatformAwareWidget {
  IMemberRepository _memberRepository;

  Function(bool reload) reloadMembersCallback;

  _MemberListPageState(this._memberRepository): assert(_memberRepository != null){
    reloadMembersCallback = (bool reload){
      if(reload != null && reload){
        setState(() {
          widget.loader.memberFuture = _memberRepository.getAllMembers();
        });
      }
    };
  }

  @override
  Widget buildAndroidWidget(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).MemberListTitle),
        actions: <Widget>[
          //Add person button
          IconButton(
            icon: Icon(Icons.person_add, color: Colors.white),
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context)=> AddMemberPage())).then((value)=> reloadMembersCallback(value)),
          ),
          //Import button
          IconButton(
            icon: Icon(Icons.file_download, color: Colors.white),
            onPressed: (){
              //TODO goto import
            },
          ),
          IconButton(
            icon: Icon(Icons.file_upload, color: Colors.white),
            onPressed: (){
              //TODO goto export
            },
          ),
        ],
      ),
      body: _listBuilder(widget.loader.memberFuture, MemberListLoading(),
          MemberListError(), MemberListEmpty()),
    );
  }

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
            CupertinoIconButton(Icons.person_add,CupertinoTheme.of(context).primaryColor,CupertinoTheme.of(context).primaryContrastingColor,(){
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=> AddMemberPage())).then((value)=> reloadMembersCallback(value));
            }),
            SizedBox(width: 10),
            CupertinoIconButton(Icons.file_download,CupertinoTheme.of(context).primaryColor,CupertinoTheme.of(context).primaryContrastingColor,(){
              //TODO goto import file
            }),
            SizedBox(width: 10),
            CupertinoIconButton(Icons.file_upload,CupertinoTheme.of(context).primaryColor,CupertinoTheme.of(context).primaryContrastingColor,(){
              //TODO goto export file
            }),
          ],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: _listBuilder(widget.loader.memberFuture, MemberListLoading(),
            MemberListError(), MemberListEmpty()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlatformAwareWidgetBuilder.build(context, this);
  }

  ///Build a [FutureBuilder] that will construct the main body of this widget.
  ///
  ///Displays [loading] when [future] is still busy.
  ///Displays [error] when [future] completed with an error.
  ///Displays [empty] when [future] completed, but there is nothing to show.
  ///Displays a list of [MemberListItem] when there is data.
  FutureBuilder _listBuilder(Future<List<Member>> future, Widget loading,
      Widget error, Widget empty) {
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
                    MemberListItem(data[index],reloadMembersCallback));
          }
        } else {
          return loading;
        }
      },
    );
  }
}
