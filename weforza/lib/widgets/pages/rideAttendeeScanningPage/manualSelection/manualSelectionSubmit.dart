import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/theme/appTheme.dart';
import 'package:weforza/widgets/platform/cupertinoBottomBar.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

class ManualSelectionSubmit extends StatefulWidget {
  const ManualSelectionSubmit({
    required this.attendeeCount,
    required this.initialAttendeeCount,
    required this.save,
    required this.showScanned,
    required this.onShowScannedChanged,
  });

  /// A function that returns the Future that handles saving the results.
  final Future<void> Function() save;
  /// A Stream of the current attendee count.
  final Stream<int> attendeeCount;
  /// The initial data for [attendeeCount].
  final int initialAttendeeCount;
  /// The Stream for the showScanned switch.
  final Stream<bool> showScanned;
  /// A function that handles the changes of the showScanned switch.
  final void Function(bool newValue) onShowScannedChanged;

  @override
  _ManualSelectionSubmitState createState() => _ManualSelectionSubmitState();
}

class _ManualSelectionSubmitState extends State<ManualSelectionSubmit> {
  Future<void>? saveFuture;

  void onSave(){
    //TODO enable when testing
    //saveFuture = Future.delayed(Duration(seconds: 5), () => Future<void>.error("Some Error"));

    // Get the Future before we call setState.
    saveFuture = widget.save();
    setState(() {});
  }

  Widget _buildAndroidLayout(BuildContext context){
    final translator = S.of(context);

    return BottomAppBar(
      color: ApplicationTheme.primaryColor,
      child: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 36,
                  child: FutureBuilder<void>(
                    future: saveFuture,
                    builder: (_, snapshot){
                      if(snapshot.connectionState == ConnectionState.none){
                        return Center(
                          child: ElevatedButtonTheme(
                            data: ElevatedButtonThemeData(
                              style: ElevatedButton.styleFrom(
                                primary: ApplicationTheme.androidManualSelectionSaveButtonPrimaryColor,
                                onPrimary: Colors.white,
                              ),
                            ),
                            child: ElevatedButton(
                              child: Text(translator.Save),
                              onPressed: onSave,
                            ),
                          ),
                        );
                      }else if(snapshot.connectionState == ConnectionState.done && snapshot.hasError){
                        return Center(
                          child: SizedBox(
                            height: 30,
                            width: 30,
                            child: Icon(
                              Icons.warning,
                              color: Colors.orange.shade200,
                            ),
                          ),
                        );
                      }

                      // The loading indicator is shown during saving
                      // and when the computation is done.
                      // We navigate away when complete,
                      // the loading indicator makes this look smoother.
                      return Center(
                        child: SizedBox(
                          height: 30,
                          width: 30,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Padding(
                  padding: EdgeInsets.only(right: 4),
                  child: Icon(Icons.people, color: Colors.white),
                ),
                StreamBuilder<int>(
                  stream: widget.attendeeCount,
                  initialData: widget.initialAttendeeCount,
                  builder: (_, snapshot){
                    final count = snapshot.data;

                    if(snapshot.hasError || count == null){
                      return Text("-", style: TextStyle(color: Colors.white));
                    }

                    if(count > 999){
                      return Text("999+", style: TextStyle(color: Colors.white));
                    }

                    return Text("$count", style: TextStyle(color: Colors.white));
                  },
                ),
                Expanded(
                  // FR: 'Coureurs scannés'
                  // DE: 'Gescannte fahrer'
                  child: Text(
                    translator.RideAttendeeScanningManualSelectionShowScannedRidersLabel,
                    maxLines: 2,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.right,
                  ),
                ),
                StreamBuilder<bool>(
                  stream: widget.showScanned,
                  // Initially we show everything.
                  initialData: true,
                  builder: (_, snapshot){
                    return Switch(
                      value: snapshot.data!,
                      onChanged: widget.onShowScannedChanged,
                      activeColor: Colors.white,
                      activeTrackColor: ApplicationTheme.androidManualSelectionSwitchActiveTrackColor,
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIosLayout(BuildContext context){
    final translator = S.of(context);

    return CupertinoBottomBar(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 44,
                    child: FutureBuilder<void>(
                      future: saveFuture,
                      builder: (_, snapshot){
                        if(snapshot.connectionState == ConnectionState.none){
                          return Center(
                            child: CupertinoButton.filled(
                              child: Text(
                                translator.Save,
                                style: TextStyle(fontSize: 16),
                              ),
                              onPressed: onSave,
                              padding: const EdgeInsets.symmetric(horizontal: 24),
                            ),
                          );
                        }else if(snapshot.connectionState == ConnectionState.done && snapshot.hasError){
                          return Center(
                            child: Icon(
                              CupertinoIcons.exclamationmark_triangle_fill,
                              color: Colors.orange,
                            ),
                          );
                        }

                        // The loading indicator is shown during saving
                        // and when the computation is done.
                        // We navigate away when complete,
                        // the loading indicator makes this look smoother.
                        return Center(child: CupertinoActivityIndicator());
                      },
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: Icon(
                    CupertinoIcons.person_2_fill,
                    color: CupertinoColors.label,
                  ),
                ),
                StreamBuilder<int>(
                  stream: widget.attendeeCount,
                  initialData: widget.initialAttendeeCount,
                  builder: (_, snapshot){
                    final count = snapshot.data;

                    if(snapshot.hasError || count == null){
                      return Text(
                        "-",
                        style: TextStyle(
                          color: CupertinoColors.label,
                          fontSize: 15,
                        ),
                      );
                    }

                    if(count > 999){
                      return Text(
                        "999+",
                        style: TextStyle(
                          color: CupertinoColors.label,
                          fontSize: 15,
                        ),
                      );
                    }

                    return Text(
                      "$count",
                      style: TextStyle(
                        color: CupertinoColors.label,
                        fontSize: 15,
                      ),
                    );
                  },
                ),
                Expanded(
                  child: Text(
                    translator.RideAttendeeScanningManualSelectionShowScannedRidersLabel,
                    maxLines: 2,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: CupertinoColors.label,
                      fontSize: 15,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
                StreamBuilder<bool>(
                  stream: widget.showScanned,
                  // Initially we show everything.
                  initialData: true,
                  builder: (_, snapshot){
                    return CupertinoSwitch(
                      value: snapshot.data!,
                      onChanged: widget.onShowScannedChanged,
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlatformAwareWidget(
      android: () => _buildAndroidLayout(context),
      ios: () => _buildIosLayout(context),
    );
  }
}