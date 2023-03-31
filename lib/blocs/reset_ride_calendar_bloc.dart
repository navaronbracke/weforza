
import 'package:weforza/blocs/bloc.dart';
import 'package:weforza/repository/rideRepository.dart';

class ResetRideCalendarBloc extends Bloc {
  ResetRideCalendarBloc({
    required this.repository,
  });

  final RideRepository repository;

  Future<void>? deleteCalendarFuture;

  void deleteRideCalendar(void Function() onSuccess) {
    deleteCalendarFuture = repository.deleteRideCalendar()
        .then((_) => onSuccess());
  }

  @override
  void dispose() {}
}