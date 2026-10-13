import 'package:flutter/foundation.dart' show ValueNotifier, ValueListenable;

import 'package:weforza/model/debounce_search_delegate.dart';
import 'package:weforza/model/ride_attendee_scanning/manual_selection_filter_options.dart';
import 'package:weforza/utils/merging_value_listenable.dart';

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
      query: _searchQueryDelegate.currentSearchQuery,
      showScannedResults: _showScannedResultsNotifier.value,
    );
  }

  /// Get the [ValueListenable] of the current combined filter values as a record of `(String, bool)`.
  ValueListenable<(String, bool)> get currentFiltersListenable {
    return MergingValueListenable(_searchQueryDelegate.searchQueryListenable, _showScannedResultsNotifier);
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
