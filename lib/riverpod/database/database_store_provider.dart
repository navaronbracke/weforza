import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sembast/sembast.dart';

/// This provider provides the member database store.
final memberStoreProvider = Provider(
  (_) => stringMapStoreFactory.store('member'),
);

/// This provider provides the ride database store.
final rideStoreProvider = Provider(
  (_) => stringMapStoreFactory.store('ride'),
);

/// This provider provides the ride attendee database store.
final rideAttendeeStoreProvider = Provider(
  (_) => stringMapStoreFactory.store('rideAttendee'),
);

/// This provider provides the device database store.
final deviceStoreProvider = Provider(
  (_) => stringMapStoreFactory.store('device'),
);

/// This provider provides the general application settings database store.
final settingsStoreProvider = Provider(
  (_) => stringMapStoreFactory.store('settings'),
);
