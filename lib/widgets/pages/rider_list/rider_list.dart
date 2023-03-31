import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/model/debounce_search_delegate.dart';
import 'package:weforza/model/rider/rider.dart';
import 'package:weforza/riverpod/rider/rider_list_provider.dart';
import 'package:weforza/widgets/common/focus_absorber.dart';
import 'package:weforza/widgets/common/generic_error.dart';
import 'package:weforza/widgets/common/rider_search_filter_empty.dart';
import 'package:weforza/widgets/pages/rider_details/rider_details_page.dart';
import 'package:weforza/widgets/pages/rider_list/rider_list_empty.dart';
import 'package:weforza/widgets/pages/rider_list/rider_list_item.dart';
import 'package:weforza/widgets/platform/platform_aware_loading_indicator.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

/// This widget represents the list of riders.
class RiderList extends StatefulWidget {
  const RiderList({super.key});

  @override
  State<RiderList> createState() => _RiderListState();
}

class _RiderListState extends State<RiderList> {
  final _searchController = DebounceSearchDelegate();

  final _searchFieldController = TextEditingController();

  void _onRiderSelected(BuildContext context) {
    // Clear the search query.
    _searchFieldController.clear();

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

  Widget _buildRiderList(BuildContext context) {
    final String placeholder = S.of(context).searchRiders;

    final Widget searchField = PlatformAwareWidget(
      android: (context) => TextField(
        controller: _searchFieldController,
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
          controller: _searchFieldController,
          suffixIcon: const Icon(CupertinoIcons.search),
          onChanged: _searchController.onQueryChanged,
          placeholder: placeholder,
        ),
      ),
    );

    return Consumer(
      builder: (context, ref, _) {
        final riderList = ref.watch(riderListProvider);

        return riderList.when(
          error: (error, stackTrace) => const Center(child: GenericError()),
          loading: () => const Center(child: PlatformAwareLoadingIndicator()),
          data: (items) {
            if (items.isEmpty) {
              return const Center(child: RiderListEmpty());
            }

            return FocusAbsorber(
              child: Column(
                children: [
                  searchField,
                  Expanded(
                    child: StreamBuilder<String>(
                      initialData: _searchController.currentQuery,
                      stream: _searchController.searchQuery,
                      builder: (context, snapshot) {
                        final results = _filterOnSearchQuery(items, snapshot.data ?? '');

                        if (results.isEmpty) {
                          return const RiderSearchFilterEmpty();
                        }

                        return ListView.builder(
                          itemCount: results.length,
                          itemBuilder: (_, index) => RiderListItem(
                            rider: results[index],
                            onPressed: () => _onRiderSelected(context),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: _buildRiderList(context),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFieldController.dispose();
    super.dispose();
  }
}
