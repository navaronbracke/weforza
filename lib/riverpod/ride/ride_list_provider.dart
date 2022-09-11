import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/subjects.dart';
import 'package:weforza/model/ride.dart';
import 'package:weforza/riverpod/repository/ride_repository_provider.dart';

/// This provider provides the list of rides.
final rideListProvider = FutureProvider<List<Ride>>((ref) {
  final repository = ref.read(rideRepositoryProvider);

  return repository.getRides();
});

/// This provider provides a stream of changes to the number of rides.
final rideListCountProvider = StreamProvider<int>((ref) async* {
  final repository = ref.read(rideRepositoryProvider);

  final curentRideCount = await repository.getRidesCount();

  final controller = BehaviorSubject.seeded(curentRideCount);

  final subscription = repository.watchRidesCount().listen((event) {
    if (controller.isClosed) {
      return;
    }

    controller.add(event);
  });

  ref.onDispose(() {
    subscription.cancel();
    controller.close();
  });

  yield* controller.stream;
});
