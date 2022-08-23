import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weforza/model/member.dart';
import 'package:weforza/widgets/pages/export_members_page.dart';
import 'package:weforza/widgets/pages/import_members_page.dart';
import 'package:weforza/widgets/pages/member_form/member_form.dart';
import 'package:weforza/widgets/pages/member_list/member_list.dart';
import 'package:weforza/widgets/pages/member_list/member_list_title.dart';
import 'package:weforza/widgets/platform/cupertino_icon_button.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

/// This widget represents the list of members.
class MemberListPage extends ConsumerStatefulWidget {
  const MemberListPage({Key? key}) : super(key: key);

  @override
  MemberListPageState createState() => MemberListPageState();
}

///This is the [State] class for [MemberListPage].
class MemberListPageState extends ConsumerState<MemberListPage> {
  // This controller manages the query stream.
  // The input field creates it's own TextEditingController,
  // as it starts with an empty string.
  final BehaviorSubject<String> _queryController = BehaviorSubject.seeded('');

  /// Filter the given [list] on the current [searchQuery].
  List<Member> _filterOnSearchQuery(List<Member> list, String searchQuery) {
    final query = searchQuery.trim().toLowerCase();

    if (query.isEmpty) {
      return list;
    }

    return list.where((member) {
      final firstName = member.firstname.toLowerCase();
      final lastName = member.lastname.toLowerCase();
      final alias = member.alias.toLowerCase();

      if (firstName.contains(query) || lastName.contains(query)) {
        return true;
      }

      if (alias.isNotEmpty && alias.contains(query)) {
        return true;
      }

      return false;
    }).toList();
  }

  Widget _buildAndroidWidget(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const MemberListTitle(),
        actions: <Widget>[
          Consumer(
            builder: (context, ref, child) {
              return IconButton(
                icon: const Icon(
                  Icons.person_add,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const MemberForm()),
                  );
                },
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.file_download),
            color: Colors.white,
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const ImportMembersPage(),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.file_upload),
            color: Colors.white,
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const ExportMembersPage(),
              ),
            ),
          ),
        ],
      ),
      body: Column(children: [
        Expanded(
          child: MemberList(
            filter: _filterOnSearchQuery,
            onSearchQueryChanged: _queryController.add,
            searchQueryStream: _queryController,
          ),
        )
      ]),
    );
  }

  Widget _buildIosWidget(BuildContext context) {
    return CupertinoPageScaffold(
      resizeToAvoidBottomInset: false,
      navigationBar: CupertinoNavigationBar(
        transitionBetweenRoutes: false,
        middle: Row(
          children: <Widget>[
            const Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 8),
                child: MemberListTitle(),
              ),
            ),
            CupertinoIconButton.fromAppTheme(
              icon: CupertinoIcons.person_badge_plus_fill,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const MemberForm()),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: CupertinoIconButton.fromAppTheme(
                icon: CupertinoIcons.arrow_down_doc_fill,
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ImportMembersPage(),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: CupertinoIconButton.fromAppTheme(
                icon: CupertinoIcons.arrow_up_doc_fill,
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ExportMembersPage(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(children: [
          Expanded(
            child: MemberList(
              filter: _filterOnSearchQuery,
              onSearchQueryChanged: _queryController.add,
              searchQueryStream: _queryController,
            ),
          ),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlatformAwareWidget(
      android: () => _buildAndroidWidget(context),
      ios: () => _buildIosWidget(context),
    );
  }

  @override
  void dispose() {
    _queryController.close();
    super.dispose();
  }
}
