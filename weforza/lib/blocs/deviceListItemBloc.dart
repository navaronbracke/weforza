
import 'package:flutter/cupertino.dart';
import 'package:weforza/blocs/bloc.dart';
import 'package:weforza/model/device.dart';

class DeviceListItemBloc extends Bloc {
  DeviceListItemBloc({@required this.device}): assert(device != null);

  Device device;

  @override
  void dispose() {}
}