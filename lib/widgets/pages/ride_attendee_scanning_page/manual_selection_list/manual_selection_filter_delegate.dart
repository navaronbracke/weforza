import 'package:rxdart/rxdart.dart';
import 'package:weforza/model/debounce_search_delegate.dart';
import 'package:weforza/model/ride_attendee_scanning/manual_selection_filter_options.dart';

/// This class represents the delegate
/// for the filters on the manual selection page.
class ManualSelectionFilterDelegate {
  /// The internal search query controller.
  final _searchQueryController = DebounceSearchDelegate();

  /// The internal show scanned results controller.
  final _showScannedResultsController = BehaviorSubject.seeded(true);

  /// Get the current filters.
  ManualSelectionFilterOptions get currentFilters {
    return ManualSelectionFilterOptions(
      query: _searchQueryController.currentQuery,
      showScannedResults: _showScannedResultsController.value,
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
      (query, showScannedResults) => ManualSelectionFilterOptions(
        query: query,
        showScannedResults: showScannedResults,
      ),
    );
  }

  /// Get the filter value for the show scanned results filter.
  bool get showScannedResults => _showScannedResultsController.value;

  /// Get the stream of changes to [ManualSelectionFilterOptions.showScannedResults].
  Stream<bool> get showScannedResultsStream => _showScannedResultsController;

  /// Change the value for the search query filter.
  void onSearchQueryChanged(String value) {
    _searchQueryController.onQueryChanged(value);
  }

  /// Change the value for the show scanned results filter.
  void onShowScannedResultsChanged(bool value) {
    _showScannedResultsController.add(value);
  }

  /// Dispose of this delegate.
  void dispose() {
    _searchQueryController.dispose();
    _showScannedResultsController.close();
  }
}
