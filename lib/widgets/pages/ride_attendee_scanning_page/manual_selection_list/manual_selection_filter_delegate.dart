import 'package:flutter/foundation.dart' show ValueNotifier, ValueListenable;

import 'package:weforza/model/debounce_search_delegate.dart';
import 'package:weforza/model/ride_attendee_scanning/manual_selection_filter_options.dart';

/// This class represents the delegate
/// for the filters on the manual selection page.
class ManualSelectionFilterDelegate {
  /// The internal search query delegate.
  final _searchQueryDelegate = DebounceSearchDelegate();

  /// The internal show scanned results notifier.
  final _showScannedResultsNotifier = ValueNotifier(true);

  /// Get the current filters.
  ManualSelectionFilterOptions get currentFilters {
    return ManualSelectionFilterOptions(
      query: _searchQueryController.currentQuery,
      showScannedResults: _showScannedResultsNotifier.value,
    );
  }

  /// Get the stream of combined filter changes.
  Stream<ManualSelectionFilterOptions> get filters {
    // combineLatest2() only emits when both streams have emitted a value.
    // However, both streams are seeded with an initial value,
    // so this is fine.
    return Rx.combineLatest2<String, bool, ManualSelectionFilterOptions>(
      _searchQueryController.searchQuery,
      _showScannedResultsController,
      (query, showScannedResults) => ManualSelectionFilterOptions(query: query, showScannedResults: showScannedResults),
    );
  }

  /// Get the [ValueListenable] of changes to [ManualSelectionFilterOptions.showScannedResults].
  ValueNotifier<bool> get showScannedResultsListenable => _showScannedResultsNotifier;

  /// Change the value for the search query filter.
  void onSearchQueryChanged(String value) {
    _searchQueryDelegate.onQueryChanged(value);
  }

  /// Change the value for the show scanned results filter.
  void onShowScannedResultsChanged({required bool value}) {
    _showScannedResultsNotifier.value = value;
  }

  /// Dispose of this delegate.
  void dispose() {
    _searchQueryDelegate.dispose();
    _showScannedResultsNotifier.dispose();
  }
}
