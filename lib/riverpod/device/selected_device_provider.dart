import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/model/device.dart';

/// This provider provides the selected device.
final selectedDeviceProvider = StateProvider<Device?>((_) => null);
