import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/model/ride.dart';
import 'package:weforza/riverpod/repository/ride_repository_provider.dart';

/// This provider provides the list of rides.
final rideListProvider = FutureProvider<List<Ride>>((ref) {
  final repository = ref.read(rideRepositoryProvider);

  return repository.getRides();
});

/// This provider provides a stream of changes to the number of rides.
final rideListCountProvider = StreamProvider<int>((ref) {
  final repository = ref.read(rideRepositoryProvider);

  final controller = StreamController<int>();

  final subscription = repository.getRideCount().listen((event) {
    if (controller.isClosed) {
      return;
    }

    controller.add(event);
  });

  ref.onDispose(() {
    subscription.cancel();
    controller.close();
  });

  return controller.stream;
});
