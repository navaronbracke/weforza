/// This class represents the filter options for the manual selection list.
class ManualSelectionFilterOptions {
  const new({this.query = '', this.showScannedResults = true});

  /// The search query to filter on.
  final String query;

  /// Whether scanned results should be shown.
  final bool showScannedResults;

  @override
  int get hashCode => Object.hash(query, showScannedResults);

  @override
  bool operator ==(Object other) {
    return other is ManualSelectionFilterOptions &&
        query == other.query &&
        showScannedResults == other.showScannedResults;
  }
}
