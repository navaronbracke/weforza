import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/model/ride_attendee_scanning/manual_selection_filter_options.dart';
import 'package:weforza/model/ride_attendee_scanning/ride_attendee_scanning_delegate.dart';
import 'package:weforza/model/rider/rider.dart';
import 'package:weforza/widgets/common/focus_absorber.dart';
import 'package:weforza/widgets/common/rider_search_filter_empty.dart';
import 'package:weforza/widgets/common/search_field_with_clear_button.dart';
import 'package:weforza/widgets/custom/scroll_behavior.dart';
import 'package:weforza/widgets/pages/ride_attendee_scanning_page/generic_scan_error.dart';
import 'package:weforza/widgets/pages/ride_attendee_scanning_page/manual_selection_list/manual_selection_bottom_bar.dart';
import 'package:weforza/widgets/pages/ride_attendee_scanning_page/manual_selection_list/manual_selection_filter_delegate.dart';
import 'package:weforza/widgets/pages/ride_attendee_scanning_page/manual_selection_list/manual_selection_list_empty.dart';
import 'package:weforza/widgets/pages/ride_attendee_scanning_page/manual_selection_list/manual_selection_list_item.dart';
import 'package:weforza/widgets/pages/ride_attendee_scanning_page/manual_selection_list/manual_selection_save_button.dart';
import 'package:weforza/widgets/pages/ride_attendee_scanning_page/manual_selection_list/show_scanned_results_toggle.dart';
import 'package:weforza/widgets/platform/platform_aware_loading_indicator.dart';

/// This widget represents the list of active riders that is shown
/// after the device scan has ended,
/// and any conflicts with unresolved owners have been corrected.
class ManualSelectionList extends StatefulWidget {
  const ManualSelectionList({
    required this.delegate,
    super.key,
  });

  /// The delegate that manages the list of active riders.
  final RideAttendeeScanningDelegate delegate;

  @override
  State<ManualSelectionList> createState() => _ManualSelectionListState();
}

class _ManualSelectionListState extends State<ManualSelectionList> {
  Future<List<Rider>>? _activeRidersFuture;

  final _filtersController = ManualSelectionFilterDelegate();
  final _searchFieldFocusNode = FocusNode();
  final _searchFieldController = TextEditingController();

  Future<void>? _saveFuture;

  List<Rider> _filterActiveRiders(
    List<Rider> items,
    ManualSelectionFilterOptions filters,
  ) {
    return items.where((item) {
      if (!filters.showScannedResults) {
        final selectedRideAttendee = widget.delegate.getSelectedRideAttendee(
          item.uuid,
        );

        // The scanned results are excluded.
        if (selectedRideAttendee?.isScanned ?? false) {
          return false;
        }
      }

      final query = filters.query.trim().toLowerCase();

      if (query.isEmpty) {
        return true;
      }

      if (item.firstName.toLowerCase().contains(query)) {
        return true;
      }

      if (item.lastName.toLowerCase().contains(query)) {
        return true;
      }

      final alias = item.alias.toLowerCase();

      // Only match against the alias if it is not empty.
      return alias.isNotEmpty && alias.contains(query);
    }).toList();
  }

  void _onSaveRideAttendeesButtonPressed(BuildContext context) {
    _saveFuture = widget.delegate.saveRideAttendeeSelection().then(
      (updatedRide) {
        if (mounted) {
          // Return back to the ride detail page.
          Navigator.of(context).pop(updatedRide);
        }
      },
    );
  }

  /// Sort the active riders on their name and alias.
  Future<List<Rider>> _sortActiveRiders() async {
    final items = widget.delegate.activeRiders;

    items.sort((Rider m1, Rider m2) => m1.compareTo(m2));

    return items;
  }

  @override
  void initState() {
    super.initState();

    if (widget.delegate.hasActiveRiders) {
      _activeRidersFuture = _sortActiveRiders();
    }
  }

  Widget _buildActiveRidersList(BuildContext context, List<Rider> items) {
    return FocusAbsorber(
      child: Column(
        children: <Widget>[
          SearchFieldWithClearButton(
            controller: _searchFieldController,
            focusNode: _searchFieldFocusNode,
            onChanged: _filtersController.onSearchQueryChanged,
            placeholder: S.of(context).searchRiders,
          ),
          Expanded(
            child: StreamBuilder<ManualSelectionFilterOptions>(
              initialData: _filtersController.currentFilters,
              stream: _filtersController.filters,
              builder: (context, snapshot) {
                final results = _filterActiveRiders(items, snapshot.data!);

                if (results.isEmpty) {
                  return const RiderSearchFilterEmpty();
                }

                return ScrollConfiguration(
                  // Use a custom scroll behavior that does not build a stretching overscroll indicator.
                  // Otherwise there are issues with gaps in the selected color of adjacent selected scan results.
                  behavior: const NoOverscrollIndicatorScrollBehavior(),
                  child: ListView.builder(
                    itemBuilder: (context, index) => ManualSelectionListItem(
                      delegate: widget.delegate,
                      item: results[index],
                    ),
                    itemCount: results.length,
                  ),
                );
              },
            ),
          ),
          ManualSelectionBottomBar(
            delegate: widget.delegate,
            saveButton: ManualSelectionSaveButton(
              future: _saveFuture,
              onPressed: () => _onSaveRideAttendeesButtonPressed(context),
            ),
            showScannedResultsToggle: ShowScannedResultsToggle(
              initialValue: _filtersController.showScannedResults,
              onChanged: _filtersController.onShowScannedResultsChanged,
              stream: _filtersController.showScannedResultsStream,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.delegate.hasActiveRiders) {
      return FutureBuilder<List<Rider>>(
        future: _activeRidersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return const Center(child: GenericScanError());
            }

            return _buildActiveRidersList(context, snapshot.data ?? []);
          }

          return const Center(child: PlatformAwareLoadingIndicator());
        },
      );
    }

    return const Center(child: ManualSelectionListEmpty());
  }

  @override
  void dispose() {
    _searchFieldController.dispose();
    _searchFieldFocusNode.dispose();
    _filtersController.dispose();
    super.dispose();
  }
}
