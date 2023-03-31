import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/blocs/memberListBloc.dart';
import 'package:weforza/file/fileHandler.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/injection/injectionContainer.dart';
import 'package:weforza/model/member.dart';
import 'package:weforza/repository/memberRepository.dart';
import 'package:weforza/repository/settingsRepository.dart';
import 'package:weforza/widgets/common/genericError.dart';
import 'package:weforza/widgets/pages/addMember/addMemberPage.dart';
import 'package:weforza/widgets/pages/exportMembers/exportMembersPage.dart';
import 'package:weforza/widgets/pages/importMembers/importMembersPage.dart';
import 'package:weforza/widgets/pages/memberDetails/memberDetailsPage.dart';
import 'package:weforza/widgets/pages/memberList/memberListEmpty.dart';
import 'package:weforza/widgets/pages/memberList/memberListItem.dart';
import 'package:weforza/widgets/platform/cupertinoIconButton.dart';
import 'package:weforza/widgets/platform/platformAwareLoadingIndicator.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';
import 'package:weforza/widgets/providers/reloadDataProvider.dart';
import 'package:weforza/widgets/providers/selectedItemProvider.dart';

///This [Widget] will display a list of members.
class MemberListPage extends StatefulWidget {
  @override
  _MemberListPageState createState() => _MemberListPageState(
     bloc: MemberListBloc(
       InjectionContainer.get<MemberRepository>(),
       InjectionContainer.get<SettingsRepository>(),
       InjectionContainer.get<IFileHandler>(),
     )
  );
}

///This is the [State] class for [MemberListPage].
class _MemberListPageState extends State<MemberListPage> {
  _MemberListPageState({
    required this.bloc
  });

  final MemberListBloc bloc;

  @override
  Widget build(BuildContext context){
    return PlatformAwareWidget(
      android: () => _buildAndroidWidget(context),
      ios: () => _buildIosWidget(context),
    );
  }

  @override
  void initState() {
    super.initState();
    bloc.loadMembers();
  }

  Widget _buildTitle(BuildContext context){
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(S.of(context).Riders),
        Padding(
          padding: const EdgeInsets.only(left: 5),
          child: FutureBuilder<int>(
            future: bloc.membersFuture?.then((items) => items.length),
            builder: (context, snapshot){
              if(snapshot.connectionState == ConnectionState.done && !snapshot.hasError){
                return Text("(${snapshot.data})");
              }

              return SizedBox.shrink();
            },
          ),
        )
      ],
    );
  }

  Widget _buildAndroidWidget(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _buildTitle(context),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.person_add, color: Colors.white),
            onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context)=> AddMemberPage())
            ).then((_) => onReturnToMemberListPage(context)),
          ),
          IconButton(
            icon: Icon(Icons.file_download),
            color: Colors.white,
            onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context)=> ImportMembersPage())
            ).then((_)=> onReturnToMemberListPage(context)),
          ),
          IconButton(
            icon: Icon(Icons.file_upload),
            color: Colors.white,
            onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context)=> ExportMembersPage())
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildList(context),
          ),
        ],
      ),
    );
  }

  Widget _buildIosWidget(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        transitionBetweenRoutes: false,
        middle: Row(
          children: <Widget>[
            Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: _buildTitle(context),
                ),
            ),
            CupertinoIconButton.fromAppTheme(
                icon: Icons.person_add,
                onPressed: ()=> Navigator.of(context).push(
                    MaterialPageRoute(builder: (context)=> AddMemberPage())
                ).then((_)=> onReturnToMemberListPage(context))
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child:  CupertinoIconButton.fromAppTheme(
                icon: Icons.file_download,
                onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (context)=> ImportMembersPage())
                ).then((_) => onReturnToMemberListPage(context)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: CupertinoIconButton.fromAppTheme(
                icon: Icons.file_upload,
                onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (context)=> ExportMembersPage())
                ),
              ),
            ),
          ],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: _buildList(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList(BuildContext context){
    return FutureBuilder<List<Member>>(
      future: bloc.membersFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return GenericError(text: S.of(context).GenericError);
          } else {
            return (snapshot.data == null || snapshot.data!.isEmpty) ? MemberListEmpty() : ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) => _buildListItem(context,index,snapshot.data!)
            );
          }
        } else {
          return Center(child: PlatformAwareLoadingIndicator());
        }
      },
    );
  }

  void onTapListItem(BuildContext context, Member member, Future<int> attendingCount, Future<File?> profileImage){
    final provider = SelectedItemProvider.of(context);
    provider.selectedMember.value = member;
    provider.selectedMemberAttendingCount.value = attendingCount;
    provider.selectedMemberProfileImage.value = profileImage;
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => MemberDetailsPage())
    ).then((_)=> onReturnToMemberListPage(context));
  }

  Widget _buildListItem(BuildContext context, int index, List<Member> members) {
    final Member member = members[index];
    final Future<int> attendingCount = bloc.getMemberAttendingCount(member.uuid);
    final Future<File?> profileImage = bloc.getMemberProfileImage(member.profileImageFilePath);
    return MemberListItem(
        member: member,
        memberProfileImage: profileImage,
        memberAttendingCount: attendingCount,
        onTap: ()=> onTapListItem(context, member, attendingCount, profileImage)
    );
  }

  void onReturnToMemberListPage(BuildContext context){
    final reloadNotifier = ReloadDataProvider.of(context).reloadMembers;
    
    // Trigger the reload of members, but do an override for the filter.
    if(reloadNotifier.value){
      reloadNotifier.value = false;
      setState(() {
        bloc.loadMembers();
      });
    }
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }
}
