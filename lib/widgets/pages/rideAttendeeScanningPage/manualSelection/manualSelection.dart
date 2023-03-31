import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/model/member.dart';
import 'package:weforza/widgets/common/generic_error.dart';
import 'package:weforza/widgets/common/rider_search_filter_empty.dart';
import 'package:weforza/widgets/pages/rideAttendeeScanningPage/manualSelection/manualSelectionListEmpty.dart';
import 'package:weforza/widgets/platform/platformAwareLoadingIndicator.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

class RideAttendeeManualSelection extends StatelessWidget {
  const RideAttendeeManualSelection({
    Key? key,
    required this.activeMembersFuture,
    required this.isMemberScanned,
    required this.itemBuilder,
    required this.saveButtonBuilder,
    required this.onShowScannedChanged,
    required this.onQueryChanged,
    required this.showScanned,
    required this.query,
  }) : super(key: key);

  final Future<List<Member>> activeMembersFuture;
  final Widget Function(Member item, bool isScanned) itemBuilder;
  final bool Function(String uuid) isMemberScanned;
  final Widget Function(BuildContext context) saveButtonBuilder;
  final void Function(String query) onQueryChanged;
  final void Function(bool showScanned) onShowScannedChanged;
  final Stream<String> query;
  final Stream<bool> showScanned;

  List<Member> filterOnQueryString(List<Member> list, String query) {
    query = query.trim().toLowerCase();

    if (query.isEmpty) {
      return list;
    }

    return list.where((Member member) {
      return member.firstname.toLowerCase().contains(query) ||
          member.lastname.toLowerCase().contains(query)
          // If the alias is not empty, we can match it against the query string.
          ||
          (member.alias.isNotEmpty &&
              member.alias.toLowerCase().contains(query));
    }).toList();
  }

  List<Member> filterOnShowScanned(List<Member> list, bool showScanned) {
    // Show everything, including the scanned members.
    if (showScanned) {
      return list;
    }

    // Only show the not scanned members.
    return list.where((member) => !isMemberScanned(member.uuid)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Member>>(
      future: activeMembersFuture,
      builder: (context, futureSnapshot) {
        if (futureSnapshot.connectionState == ConnectionState.done) {
          if (futureSnapshot.hasError) {
            return GenericError(text: S.of(context).GenericError);
          }
          final list = futureSnapshot.data;

          if (list == null || list.isEmpty) {
            return const Center(child: ManualSelectionListEmpty());
          }

          return Column(
            children: <Widget>[
              PlatformAwareWidget(
                android: () => TextFormField(
                  textInputAction: TextInputAction.search,
                  keyboardType: TextInputType.text,
                  autocorrect: false,
                  autovalidateMode: AutovalidateMode.disabled,
                  onChanged: onQueryChanged,
                  decoration: InputDecoration(
                      suffixIcon: const Icon(Icons.search),
                      labelText: S.of(context).RiderSearchFilterInputLabel,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 5),
                      floatingLabelBehavior: FloatingLabelBehavior.never),
                ),
                ios: () => Padding(
                  padding: const EdgeInsets.all(8),
                  child: CupertinoSearchTextField(
                    suffixIcon: const Icon(CupertinoIcons.search),
                    onChanged: onQueryChanged,
                    placeholder: S.of(context).RiderSearchFilterInputLabel,
                  ),
                ),
              ),
              Expanded(child: _buildScannedStreamBuilder(list)),
              saveButtonBuilder(context),
            ],
          );
        }

        return const Center(child: PlatformAwareLoadingIndicator());
      },
    );
  }

  /// Build the [StreamBuilder] for the query string.
  Widget _buildQueryStringStreamBuilder(List<Member> data) {
    return StreamBuilder<String>(
        stream: query,
        builder: (_, snapshot) {
          final filteredData = filterOnQueryString(data, snapshot.data ?? '');

          if (filteredData.isEmpty) {
            return const RiderSearchFilterEmpty();
          }

          return ListView.builder(
            itemBuilder: (context, index) {
              final item = filteredData[index];

              return itemBuilder(item, isMemberScanned(item.uuid));
            },
            itemCount: filteredData.length,
          );
        });
  }

  /// Build the [StreamBuilder] for the scanned filter.
  Widget _buildScannedStreamBuilder(List<Member> data) {
    return StreamBuilder<bool>(
      stream: showScanned,
      builder: (_, snapshot) {
        final showAll = snapshot.data ?? true;
        final list = filterOnShowScanned(data, showAll);

        return _buildQueryStringStreamBuilder(list);
      },
    );
  }
}
