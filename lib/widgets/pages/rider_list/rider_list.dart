import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/model/rider/rider.dart';
import 'package:weforza/riverpod/rider/rider_list_provider.dart';
import 'package:weforza/widgets/common/focus_absorber.dart';
import 'package:weforza/widgets/common/generic_error.dart';
import 'package:weforza/widgets/common/rider_search_filter_empty.dart';
import 'package:weforza/widgets/pages/rider_list/rider_list_empty.dart';
import 'package:weforza/widgets/pages/rider_list/rider_list_item.dart';
import 'package:weforza/widgets/platform/platform_aware_loading_indicator.dart';

/// This widget represents the rider list itself.
class RiderList extends ConsumerWidget {
  const RiderList({
    required this.filter,
    required this.onRiderSelected,
    required this.searchField,
    required this.searchQueryStream,
    super.key,
  });

  /// The function that handles filtering results.
  final List<Rider> Function(List<Rider> data, String query) filter;

  /// The function that is called after a rider is selected.
  final void Function() onRiderSelected;

  /// The widget that provides the search field.
  final Widget searchField;

  /// The stream that provides updates about the search query.
  final Stream<String> searchQueryStream;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final riderList = ref.watch(riderListProvider);

    return riderList.when(
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
                  stream: searchQueryStream,
                  builder: (context, snapshot) {
                    final results = filter(items, snapshot.data ?? '');

                    if (results.isEmpty) {
                      return const RiderSearchFilterEmpty();
                    }

                    return ListView.builder(
                      itemCount: results.length,
                      itemBuilder: (_, index) => RiderListItem(
                        rider: results[index],
                        onPressed: onRiderSelected,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
      error: (error, stackTrace) => const Center(child: GenericError()),
      loading: () => const Center(child: PlatformAwareLoadingIndicator()),
    );
  }
}
