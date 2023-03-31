import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/model/member.dart';
import 'package:weforza/widgets/common/genericError.dart';
import 'package:weforza/widgets/pages/rideAttendeeScanningPage/manualSelection/manualSelectionListEmpty.dart';
import 'package:weforza/widgets/pages/rideAttendeeScanningPage/manualSelection/manualSelectionListFilterEmpty.dart';
import 'package:weforza/widgets/platform/platformAwareLoadingIndicator.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

class RideAttendeeManualSelection extends StatefulWidget {
  RideAttendeeManualSelection({
    required this.activeMembersFuture,
    required this.itemBuilder,
    required this.saveButtonBuilder
  });

  final Future<List<Member>> activeMembersFuture;
  final Widget Function(Member item) itemBuilder;
  final Widget Function(BuildContext context) saveButtonBuilder;

  @override
  _RideAttendeeManualSelectionState createState() => _RideAttendeeManualSelectionState();
}

class _RideAttendeeManualSelectionState extends State<RideAttendeeManualSelection> {
  // This controller manages the query stream.
  // The input field creates it's own TextEditingController,
  // as it starts with an empty string.
  final BehaviorSubject<String> _queryController = BehaviorSubject.seeded("");

  List<Member> filterData(List<Member> list, String query){
    if(query.isEmpty){
      return list;
    }

    query = query.trim().toLowerCase();

    return list.where((Member member){
      return member.firstname.toLowerCase().contains(query) || member.lastname.toLowerCase().contains(query)
      // If the alias is not empty, we can match it against the query string.
          || (member.alias.isNotEmpty && member.alias.toLowerCase().contains(query));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Member>>(
      future: widget.activeMembersFuture,
      builder: (context, futureSnapshot){
        if(futureSnapshot.connectionState == ConnectionState.done){
          if(futureSnapshot.hasError){
            return GenericError(text: S.of(context).GenericError);
          }

          if(futureSnapshot.data == null || futureSnapshot.data!.isEmpty){
            return Center(child: ManualSelectionListEmpty());
          }

          return Column(
            children: <Widget>[
              PlatformAwareWidget(
                android: () => TextFormField(
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.text,
                  autocorrect: false,
                  autovalidateMode: AutovalidateMode.disabled,
                  onChanged: _queryController.add,
                  decoration: InputDecoration(
                    suffixIcon: Icon(Icons.search),
                    labelText: S.of(context).RideAttendeeScanningManualSelectionFilterInputLabel,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 5),
                  ),
                ),
                ios: () => Padding(
                  padding: const EdgeInsets.all(8),
                  child: CupertinoTextField(
                    textInputAction: TextInputAction.done,
                    placeholder: S.of(context).RideAttendeeScanningManualSelectionFilterInputLabel,
                    autocorrect: false,
                    keyboardType: TextInputType.text,
                    onChanged: _queryController.add,
                  ),
                ),
              ),
              Expanded(
                child: StreamBuilder<String>(
                  stream: _queryController.stream,
                  builder: (context, streamSnapshot) {
                    final data = filterData(
                      futureSnapshot.data!,
                      streamSnapshot.data ?? "",
                    );

                    if(data.isEmpty){
                      return ManualSelectionListFilterEmpty();
                    }

                    return ListView.builder(
                      itemBuilder: (context, index) => widget.itemBuilder(data[index]),
                      itemCount: data.length,
                    );
                  }
                ),
              ),
              widget.saveButtonBuilder(context),
            ],
          );
        }

        return Center(child: PlatformAwareLoadingIndicator());
      },
    );
  }

  @override
  void dispose() {
    _queryController.close();
    super.dispose();
  }
}