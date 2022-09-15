import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/model/debounce_search_delegate.dart';
import 'package:weforza/model/member.dart';
import 'package:weforza/widgets/pages/export_members_page.dart';
import 'package:weforza/widgets/pages/import_members_page.dart';
import 'package:weforza/widgets/pages/member_details/member_details_page.dart';
import 'package:weforza/widgets/pages/member_form.dart';
import 'package:weforza/widgets/pages/member_list/member_list.dart';
import 'package:weforza/widgets/pages/member_list/member_list_title.dart';
import 'package:weforza/widgets/platform/cupertino_icon_button.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

/// This widget represents the list of members.
class MemberListPage extends ConsumerStatefulWidget {
  const MemberListPage({super.key});

  @override
  MemberListPageState createState() => MemberListPageState();
}

class MemberListPageState extends ConsumerState<MemberListPage> {
  final _controller = TextEditingController();

  final _searchController = DebounceSearchDelegate();

  void _onMemberSelected(BuildContext context) {
    // Clear the search query.
    _controller.clear();

    // Unfocus the search field before exiting this page.
    FocusScope.of(context).unfocus();

    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const MemberDetailsPage()),
    );
  }

  /// Filter the given [list] on the current [searchQuery].
  List<Member> _filterOnSearchQuery(List<Member> list, String searchQuery) {
    final query = searchQuery.trim().toLowerCase();

    if (query.isEmpty) {
      return list;
    }

    return list.where((member) {
      final firstName = member.firstName.toLowerCase();
      final lastName = member.lastName.toLowerCase();
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
                icon: const Icon(Icons.person_add),
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const MemberForm()),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.file_download),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const ImportMembersPage(),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.file_upload),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const ExportMembersPage(),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: MemberList(
              onMemberSelected: () => _onMemberSelected(context),
              filter: _filterOnSearchQuery,
              searchQueryStream: _searchController.searchQuery,
              searchField: TextFormField(
                controller: _controller,
                textInputAction: TextInputAction.search,
                keyboardType: TextInputType.text,
                autocorrect: false,
                autovalidateMode: AutovalidateMode.disabled,
                onChanged: _searchController.onQueryChanged,
                decoration: InputDecoration(
                  suffixIcon: const Icon(Icons.search),
                  labelText: S.of(context).SearchRiders,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                ),
              ),
            ),
          )
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
            const Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 8),
                child: MemberListTitle(),
              ),
            ),
            CupertinoIconButton(
              icon: CupertinoIcons.person_badge_plus_fill,
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const MemberForm()),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: CupertinoIconButton(
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
              child: CupertinoIconButton(
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
        child: Column(
          children: [
            Expanded(
              child: MemberList(
                onMemberSelected: () => _onMemberSelected(context),
                filter: _filterOnSearchQuery,
                searchQueryStream: _searchController.searchQuery,
                searchField: Padding(
                  padding: const EdgeInsets.all(8),
                  child: CupertinoSearchTextField(
                    controller: _controller,
                    suffixIcon: const Icon(CupertinoIcons.search),
                    onChanged: _searchController.onQueryChanged,
                    placeholder: S.of(context).SearchRiders,
                  ),
                ),
              ),
            ),
          ],
        ),
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
    _searchController.dispose();
    _controller.dispose();
    super.dispose();
  }
}
