import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weforza/riverpod/member/member_list_provider.dart';
import 'package:weforza/widgets/pages/add_member/add_member_page.dart';
import 'package:weforza/widgets/pages/export_members_page.dart';
import 'package:weforza/widgets/pages/import_members_page.dart';
import 'package:weforza/widgets/pages/member_list/member_list.dart';
import 'package:weforza/widgets/pages/member_list/member_list_title.dart';
import 'package:weforza/widgets/platform/cupertino_icon_button.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

///This [Widget] will display a list of members.
class MemberListPage extends ConsumerStatefulWidget {
  const MemberListPage({Key? key}) : super(key: key);

  @override
  _MemberListPageState createState() => _MemberListPageState();
}

///This is the [State] class for [MemberListPage].
class _MemberListPageState extends ConsumerState<MemberListPage> {
  // This controller manages the query stream.
  // The input field creates it's own TextEditingController,
  // as it starts with an empty string.
  final BehaviorSubject<String> _queryController = BehaviorSubject.seeded('');

  late final MemberListNotifier memberListNotifier;

  @override
  void initState() {
    super.initState();
    memberListNotifier = ref.read(memberListProvider.notifier);
  }

  @override
  Widget build(BuildContext context) {
    return PlatformAwareWidget(
      android: () => _buildAndroidWidget(context),
      ios: () => _buildIosWidget(context),
    );
  }

  Widget _buildAndroidWidget(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const MemberListTitle(),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.person_add,
              color: Colors.white,
            ),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const AddMemberPage()),
            ),
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
            filter: memberListNotifier.filterOnSearchQuery,
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
                padding: EdgeInsets.only(left: 10),
                child: MemberListTitle(),
              ),
            ),
            CupertinoIconButton.fromAppTheme(
              icon: CupertinoIcons.person_badge_plus_fill,
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const AddMemberPage()),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15),
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
              padding: const EdgeInsets.only(left: 15),
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
              filter: memberListNotifier.filterOnSearchQuery,
              onSearchQueryChanged: _queryController.add,
              searchQueryStream: _queryController,
            ),
          ),
        ]),
      ),
    );
  }

  @override
  void dispose() {
    _queryController.close();
    super.dispose();
  }
}
