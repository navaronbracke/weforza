import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weforza/blocs/member_list_bloc.dart';
import 'package:weforza/file/file_handler.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/injection/injectionContainer.dart';
import 'package:weforza/model/member.dart';
import 'package:weforza/repository/member_repository.dart';
import 'package:weforza/repository/settings_repository.dart';
import 'package:weforza/widgets/common/generic_error.dart';
import 'package:weforza/widgets/common/rider_search_filter_empty.dart';
import 'package:weforza/widgets/pages/add_member/add_member_page.dart';
import 'package:weforza/widgets/pages/export_members_page.dart';
import 'package:weforza/widgets/pages/import_members_page.dart';
import 'package:weforza/widgets/pages/memberDetails/member_details_page.dart';
import 'package:weforza/widgets/pages/memberList/memberListEmpty.dart';
import 'package:weforza/widgets/pages/memberList/memberListItem.dart';
import 'package:weforza/widgets/platform/cupertinoIconButton.dart';
import 'package:weforza/widgets/platform/platformAwareLoadingIndicator.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';
import 'package:weforza/widgets/providers/reloadDataProvider.dart';
import 'package:weforza/widgets/providers/selectedItemProvider.dart';

///This [Widget] will display a list of members.
class MemberListPage extends StatefulWidget {
  const MemberListPage({Key? key}) : super(key: key);

  @override
  _MemberListPageState createState() => _MemberListPageState(
          bloc: MemberListBloc(
        InjectionContainer.get<MemberRepository>(),
        InjectionContainer.get<SettingsRepository>(),
        InjectionContainer.get<IFileHandler>(),
      ));
}

///This is the [State] class for [MemberListPage].
class _MemberListPageState extends State<MemberListPage> {
  _MemberListPageState({required this.bloc});

  final MemberListBloc bloc;

  // This controller manages the query stream.
  // The input field creates it's own TextEditingController,
  // as it starts with an empty string.
  final BehaviorSubject<String> _queryController = BehaviorSubject.seeded('');

  List<Member> filterData(List<Member> list, String query) {
    query = query.trim().toLowerCase();

    if (query.isEmpty) {
      return list;
    }

    return list.where((Member member) {
      return member.firstname.toLowerCase().contains(query) ||
          member.lastname.toLowerCase().contains(query)
          // If the alias is not empty, we can match it against the query string.
          ||
          (member.alias.isNotEmpty &&
              member.alias.toLowerCase().contains(query));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
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

  Widget _buildTitle(BuildContext context) {
    return FutureBuilder<List<Member>>(
      future: bloc.membersFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Text(S.of(context).Riders);
          }

          return Text(
              S.of(context).RidersListTitle(snapshot.data?.length ?? 0));
        }

        return Text(S.of(context).Riders);
      },
    );
  }

  Widget _buildAndroidWidget(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: _buildTitle(context),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.person_add,
              color: Colors.white,
            ),
            onPressed: () => Navigator.of(context)
                .push(MaterialPageRoute(
                    builder: (context) => const AddMemberPage()))
                .then((_) => onReturnToMemberListPage(context)),
          ),
          IconButton(
            icon: const Icon(Icons.file_download),
            color: Colors.white,
            onPressed: () => Navigator.of(context)
                .push(MaterialPageRoute(
                    builder: (context) => const ImportMembersPage()))
                .then((_) => onReturnToMemberListPage(context)),
          ),
          IconButton(
            icon: const Icon(Icons.file_upload),
            color: Colors.white,
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const ExportMembersPage())),
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
      resizeToAvoidBottomInset: false,
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
                icon: CupertinoIcons.person_badge_plus_fill,
                onPressed: () => Navigator.of(context)
                    .push(MaterialPageRoute(
                        builder: (context) => const AddMemberPage()))
                    .then((_) => onReturnToMemberListPage(context))),
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: CupertinoIconButton.fromAppTheme(
                icon: CupertinoIcons.arrow_down_doc_fill,
                onPressed: () => Navigator.of(context)
                    .push(MaterialPageRoute(
                        builder: (context) => const ImportMembersPage()))
                    .then((_) => onReturnToMemberListPage(context)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: CupertinoIconButton.fromAppTheme(
                icon: CupertinoIcons.arrow_up_doc_fill,
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const ExportMembersPage())),
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

  Widget _buildList(BuildContext context) {
    return FutureBuilder<List<Member>>(
      future: bloc.membersFuture,
      builder: (context, futureSnapshot) {
        if (futureSnapshot.connectionState == ConnectionState.done) {
          if (futureSnapshot.hasError) {
            return GenericError(text: S.of(context).GenericError);
          }

          if (futureSnapshot.data == null || futureSnapshot.data!.isEmpty) {
            return const Center(child: MemberListEmpty());
          }

          return Column(
            children: [
              PlatformAwareWidget(
                android: () => TextFormField(
                  textInputAction: TextInputAction.search,
                  keyboardType: TextInputType.text,
                  autocorrect: false,
                  autovalidateMode: AutovalidateMode.disabled,
                  onChanged: _queryController.add,
                  decoration: InputDecoration(
                      suffixIcon: const Icon(Icons.search),
                      labelText: S.of(context).RiderSearchFilterInputLabel,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 5),
                      floatingLabelBehavior: FloatingLabelBehavior.never),
                ),
                ios: () => Padding(
                  padding: const EdgeInsets.all(8),
                  child: CupertinoSearchTextField(
                    suffixIcon: const Icon(CupertinoIcons.search),
                    onChanged: _queryController.add,
                    placeholder: S.of(context).RiderSearchFilterInputLabel,
                  ),
                ),
              ),
              Expanded(
                child: StreamBuilder<String>(
                  stream: _queryController.stream,
                  builder: (context, streamSnapshot) {
                    final data = filterData(
                      futureSnapshot.data ?? [],
                      streamSnapshot.data ?? '',
                    );

                    if (data.isEmpty) {
                      return const RiderSearchFilterEmpty();
                    }

                    return ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) =>
                          _buildListItem(context, data[index]),
                    );
                  },
                ),
              ),
            ],
          );
        }

        return const Center(child: PlatformAwareLoadingIndicator());
      },
    );
  }

  void onTapListItem(BuildContext context, Member member,
      Future<int> attendingCount, Future<File?> profileImage) {
    final provider = SelectedItemProvider.of(context);
    provider.selectedMember.value = member;
    provider.selectedMemberAttendingCount.value = attendingCount;
    provider.selectedMemberProfileImage.value = profileImage;
    Navigator.of(context)
        .push(
            MaterialPageRoute(builder: (context) => const MemberDetailsPage()))
        .then((_) => onReturnToMemberListPage(context));
  }

  Widget _buildListItem(BuildContext context, Member item) {
    final Future<int> attendingCount = bloc.getMemberAttendingCount(item.uuid);
    final Future<File?> profileImage =
        bloc.getMemberProfileImage(item.profileImageFilePath);
    return MemberListItem(
        member: item,
        memberProfileImage: profileImage,
        memberAttendingCount: attendingCount,
        onTap: () =>
            onTapListItem(context, item, attendingCount, profileImage));
  }

  void onReturnToMemberListPage(BuildContext context) {
    final reloadNotifier = ReloadDataProvider.of(context).reloadMembers;

    // Trigger the reload of members, but do an override for the filter.
    if (reloadNotifier.value) {
      reloadNotifier.value = false;
      setState(() {
        bloc.loadMembers();
      });
    }
  }

  @override
  void dispose() {
    bloc.dispose();
    _queryController.close();
    super.dispose();
  }
}
