import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:weforza/model/member.dart';
import 'package:flutter/material.dart';
import 'package:weforza/model/scanResultItem.dart';
import 'package:weforza/theme/appTheme.dart';

class ScanResultListItem extends StatelessWidget {
  ScanResultListItem({@required this.item}):
        assert(item != null);

  final ScanResultItem item;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Card(
        child: SizedBox(
          height: 200,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FutureBuilder<Member>(
              future: item.memberLookup,
              builder: (context, snapshot){
                if(snapshot.connectionState == ConnectionState.done){
                  if(snapshot.hasError){
                    return Row(
                      children: <Widget>[
                        Expanded(child: Text(item.deviceName, overflow: TextOverflow.ellipsis)),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Icon(
                              Icons.error_outline,
                              color: ApplicationTheme.rideAttendeeScanResultWarningColor
                          ),
                        ),
                      ],
                    );
                  }else{
                    if(snapshot.data == null){
                      return Row(
                        children: <Widget>[
                          Expanded(child: Text(item.deviceName, overflow: TextOverflow.ellipsis)),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Icon(
                                Icons.help_outline,
                                color: ApplicationTheme.rideAttendeeScanResultUnknownDeviceColor
                            ),
                          ),
                        ],
                      );
                    }else{
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                              snapshot.data.firstname,
                              overflow: TextOverflow.ellipsis,
                              style: ApplicationTheme.rideAttendeeScanResultFirstNameTextStyle,
                          ),
                          SizedBox(height: 4),
                          Text(
                              snapshot.data.lastname,
                              overflow: TextOverflow.ellipsis
                          )
                        ],
                      );
                    }
                  }
                }else{
                  return Row(
                    children: <Widget>[
                      Expanded(child: Text(item.deviceName, overflow: TextOverflow.ellipsis)),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(ApplicationTheme.rideAttendeeScanResultLoadingColor),
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
