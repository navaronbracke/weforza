import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/model/member.dart';
import 'package:weforza/model/ride_attendee_scanning/manual_selection_filter_options.dart';
import 'package:weforza/model/ride_attendee_scanning/ride_attendee_scanning_delegate.dart';
import 'package:weforza/widgets/common/rider_search_filter_empty.dart';
import 'package:weforza/widgets/pages/ride_attendee_scanning_page/generic_scan_error.dart';
import 'package:weforza/widgets/pages/ride_attendee_scanning_page/manual_selection_list/manual_selection_list_empty.dart';
import 'package:weforza/widgets/pages/ride_attendee_scanning_page/manual_selection_list/manual_selection_list_item.dart';
import 'package:weforza/widgets/platform/platform_aware_loading_indicator.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

/// This widget represents the list of active members that is shown
/// after the device scan has ended,
/// and any conflicts with unresolved owners have been corrected.
class ManualSelectionList extends StatefulWidget {
  const ManualSelectionList({super.key, required this.delegate});

  /// The delegate that manages the list of active members.
  final RideAttendeeScanningDelegate delegate;

  @override
  State<ManualSelectionList> createState() => _ManualSelectionListState();
}

class _ManualSelectionListState extends State<ManualSelectionList> {
  Future<List<Member>>? _activeMembersFuture;

  final _filtersController = BehaviorSubject.seeded(
    const ManualSelectionFilterOptions(),
  );

  List<Member> _filterActiveMembers(
    List<Member> items,
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

      if (item.firstname.toLowerCase().contains(query)) {
        return true;
      }

      if (item.lastname.toLowerCase().contains(query)) {
        return true;
      }

      final alias = item.alias.toLowerCase();

      // Only match against the alias if it is not empty.
      return alias.isNotEmpty && alias.contains(query);
    }).toList();
  }

  void _onSearchQueryChanged(String newQuery) {
    _filtersController.add(_filtersController.value.copyWith(query: newQuery));
  }

  void _onShowScannedResultsChanged(bool newValue) {
    _filtersController.add(
      _filtersController.value.copyWith(showScannedResults: newValue),
    );
  }

  /// Sort the active members on their name and alias.
  Future<List<Member>> _sortActiveMembers() {
    final items = widget.delegate.activeMembers;

    items.sort((Member m1, Member m2) => m1.compareTo(m2));

    return Future.value(items);
  }

  @override
  void initState() {
    super.initState();

    if (widget.delegate.hasActiveMembers) {
      _activeMembersFuture = _sortActiveMembers();
    }
  }

  Widget _buildActiveMembersList(BuildContext context, List<Member> items) {
    final translator = S.of(context);

    return Column(
      children: <Widget>[
        PlatformAwareWidget(
          android: () => TextFormField(
            textInputAction: TextInputAction.search,
            keyboardType: TextInputType.text,
            autocorrect: false,
            autovalidateMode: AutovalidateMode.disabled,
            onChanged: _onSearchQueryChanged,
            decoration: InputDecoration(
              suffixIcon: const Icon(Icons.search),
              labelText: translator.SearchRiders,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 4),
              floatingLabelBehavior: FloatingLabelBehavior.never,
            ),
          ),
          ios: () => Padding(
            padding: const EdgeInsets.all(8),
            child: CupertinoSearchTextField(
              suffixIcon: const Icon(CupertinoIcons.search),
              onChanged: _onSearchQueryChanged,
              placeholder: translator.SearchRiders,
            ),
          ),
        ),
        Expanded(
          child: StreamBuilder<ManualSelectionFilterOptions>(
            initialData: _filtersController.value,
            stream: _filtersController,
            builder: (context, snapshot) {
              final results = _filterActiveMembers(items, snapshot.data!);

              if (results.isEmpty) {
                return const RiderSearchFilterEmpty();
              }

              return ListView.builder(
                itemBuilder: (context, index) => ManualSelectionListItem(
                  delegate: widget.delegate,
                  item: results[index],
                ),
                itemCount: results.length,
              );
            },
          ),
        ),
        saveButtonBuilder(context),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.delegate.hasActiveMembers) {
      return FutureBuilder<List<Member>>(
        future: _activeMembersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return const Center(child: GenericScanError());
            }

            return _buildActiveMembersList(context, snapshot.data ?? []);
          }

          return const Center(child: PlatformAwareLoadingIndicator());
        },
      );
    }

    return const Center(child: ManualSelectionListEmpty());
  }

  @override
  void dispose() {
    _filtersController.close();
    super.dispose();
  }
}