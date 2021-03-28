import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:weforza/widgets/custom/rectangleAndCircleQuarter/rectangleAndCircleQuarter.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

class ManualSelectionItemCounter extends StatelessWidget {
  ManualSelectionItemCounter({
    required this.backgroundColor,
    required this.countStream,
    required this.initialData
  });

  final Color backgroundColor;
  final Stream<int> countStream;
  final int initialData;

  @override
  Widget build(BuildContext context) {
    final textColor = Colors.white;
    final width = 95.0;
    final height = 40.0;

    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        children: [
          RectangleAndCircleQuarter(
            color: backgroundColor,
            size: Size(width, height),
          ),
          Positioned(
            top: 5,
            left: 10,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                PlatformAwareWidget(
                  android: () => Icon(
                    Icons.people,
                    color: textColor,
                    size: 30,
                  ),
                  ios: () => Icon(
                    CupertinoIcons.person_2_fill,
                    color: textColor,
                    size: 30,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: StreamBuilder<int>(
                    initialData: initialData,
                    stream: countStream,
                    builder: (context, snapshot){
                      final count = snapshot.data;
                      if(snapshot.hasError || count == null){
                        return Text(
                          "-",
                          style: TextStyle(
                            fontSize: 16,
                            color: textColor,
                          ),
                        );
                      }

                      // Limit the maximum shown number.
                      // This is an edge case for overflow.
                      if(count > 999){
                        return Text(
                          "999+",
                          style: TextStyle(
                            fontSize: 16,
                            color: textColor,
                          ),
                        );
                      }

                      return Text(
                        "${snapshot.data}",
                        style: TextStyle(
                          fontSize: 16,
                          color: textColor,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}