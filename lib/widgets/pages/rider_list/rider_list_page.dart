import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/model/debounce_search_delegate.dart';
import 'package:weforza/model/rider/rider.dart';
import 'package:weforza/widgets/pages/export_data_page/export_riders_page.dart';
import 'package:weforza/widgets/pages/import_riders_page.dart';
import 'package:weforza/widgets/pages/rider_details/rider_details_page.dart';
import 'package:weforza/widgets/pages/rider_form.dart';
import 'package:weforza/widgets/pages/rider_list/rider_list.dart';
import 'package:weforza/widgets/pages/rider_list/rider_list_title.dart';
import 'package:weforza/widgets/platform/cupertino_icon_button.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

/// This widget represents the list of riders.
class RiderListPage extends ConsumerStatefulWidget {
  const RiderListPage({super.key});

  @override
  ConsumerState<RiderListPage> createState() => _RiderListPageState();
}

class _RiderListPageState extends ConsumerState<RiderListPage> {
  final _controller = TextEditingController();

  final _searchController = DebounceSearchDelegate();

  void _onRiderSelected(BuildContext context) {
    // Clear the search query.
    _controller.clear();

    // Unfocus the search field before exiting this page.
    FocusScope.of(context).unfocus();

    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const RiderDetailsPage()),
    );
  }

  /// Filter the given [list] on the current [searchQuery].
  List<Rider> _filterOnSearchQuery(List<Rider> list, String searchQuery) {
    final query = searchQuery.trim().toLowerCase();

    if (query.isEmpty) {
      return list;
    }

    return list.where((rider) {
      final firstName = rider.firstName.toLowerCase();
      final lastName = rider.lastName.toLowerCase();
      final alias = rider.alias.toLowerCase();

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
        title: const RiderListTitle(),
        actions: <Widget>[
          Consumer(
            builder: (context, ref, child) {
              return IconButton(
                icon: const Icon(Icons.person_add),
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const RiderForm()),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.file_download),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const ImportRidersPage(),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.file_upload),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const ExportRidersPage(),
              ),
            ),
          ),
        ],
      ),
      body: RiderList(
        onRiderSelected: () => _onRiderSelected(context),
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
            labelText: S.of(context).searchRiders,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 4),
            floatingLabelBehavior: FloatingLabelBehavior.never,
          ),
        ),
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
                child: RiderListTitle(),
              ),
            ),
            CupertinoIconButton(
              icon: CupertinoIcons.person_badge_plus_fill,
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const RiderForm()),
              ),
            ),
            CupertinoIconButton(
              icon: CupertinoIcons.arrow_down_doc_fill,
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ImportRidersPage(),
                ),
              ),
            ),
            CupertinoIconButton(
              icon: CupertinoIcons.arrow_up_doc_fill,
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ExportRidersPage(),
                ),
              ),
            ),
          ],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: RiderList(
          onRiderSelected: () => _onRiderSelected(context),
          filter: _filterOnSearchQuery,
          searchQueryStream: _searchController.searchQuery,
          searchField: Padding(
            padding: const EdgeInsets.all(8),
            child: CupertinoSearchTextField(
              controller: _controller,
              suffixIcon: const Icon(CupertinoIcons.search),
              onChanged: _searchController.onQueryChanged,
              placeholder: S.of(context).searchRiders,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlatformAwareWidget(
      android: _buildAndroidWidget,
      ios: _buildIosWidget,
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _controller.dispose();
    super.dispose();
  }
}
