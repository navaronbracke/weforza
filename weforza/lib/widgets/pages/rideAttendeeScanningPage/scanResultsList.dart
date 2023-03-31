import 'package:flutter/widgets.dart';

class ScanResultsList extends StatefulWidget {
  ScanResultsList({
    @required this.listKey,
    @required this.itemBuilder,
    @required this.menuEnabledStream,
    @required this.choiceRequiredStream,
    @required this.selectedOwnerStream
  }): assert(
    listKey != null && itemBuilder != null && menuEnabledStream != null
        && choiceRequiredStream != null && selectedOwnerStream != null
  );

  final Stream<String> selectedOwnerStream;

  final Stream<bool> menuEnabledStream;

  final Stream<bool> choiceRequiredStream;

  final GlobalKey<AnimatedListState> listKey;

  final Widget Function(
      BuildContext context,
      int index,
      Animation<double> animation,
      bool choiceRequired,
      bool menuEnabled,
      String lastSelectedItem) itemBuilder;

  @override
  _ScanResultsListState createState() => _ScanResultsListState();
}

class _ScanResultsListState extends State<ScanResultsList> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      initialData: false,
      stream: widget.menuEnabledStream,
      builder: (_, menuEnabled){
        return StreamBuilder<bool>(
          initialData: false,
          stream: widget.choiceRequiredStream,
          builder: (_, choiceRequired){
            return StreamBuilder<String>(
              initialData: null,
              stream: widget.selectedOwnerStream,
              builder: (context, lastSelectedOwner){
                return AnimatedList(
                  key: widget.listKey,
                  itemBuilder: (BuildContext context, int index, Animation<double> animation){
                    return widget.itemBuilder(context, index, animation, choiceRequired.data, menuEnabled.data, lastSelectedOwner.data);
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
