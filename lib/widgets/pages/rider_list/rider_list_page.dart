import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/model/debounce_search_delegate.dart';
import 'package:weforza/model/rider/rider.dart';
import 'package:weforza/widgets/pages/rider_details/rider_details_page.dart';
import 'package:weforza/widgets/pages/rider_list/rider_list.dart';
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

  @override
  Widget build(BuildContext context) {
    final placeholder = S.of(context).searchRiders;

    final Widget searchField = PlatformAwareWidget(
      android: (context) => TextField(
        controller: _controller,
        textInputAction: TextInputAction.search,
        keyboardType: TextInputType.text,
        autocorrect: false,
        onChanged: _searchController.onQueryChanged,
        decoration: InputDecoration(
          suffixIcon: const Icon(Icons.search),
          labelText: placeholder,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 4),
          floatingLabelBehavior: FloatingLabelBehavior.never,
        ),
      ),
      ios: (context) => Padding(
        padding: const EdgeInsets.all(8),
        child: CupertinoSearchTextField(
          controller: _controller,
          suffixIcon: const Icon(CupertinoIcons.search),
          onChanged: _searchController.onQueryChanged,
          placeholder: placeholder,
        ),
      ),
    );

    return SafeArea(
      bottom: false,
      child: RiderList(
        onRiderSelected: () => _onRiderSelected(context),
        initialSearchQuery: _searchController.currentQuery,
        filter: _filterOnSearchQuery,
        searchQueryStream: _searchController.searchQuery,
        searchField: searchField,
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _controller.dispose();
    super.dispose();
  }
}
