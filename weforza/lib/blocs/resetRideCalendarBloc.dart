
import 'package:meta/meta.dart';
import 'package:weforza/blocs/bloc.dart';
import 'package:weforza/repository/rideRepository.dart';

class ResetRideCalendarBloc extends Bloc {
  ResetRideCalendarBloc({
    @required this.repository,
  }): assert(repository != null);

  final RideRepository repository;

  Future<void> deleteCalendarFuture;

  void deleteRideCalendar(void Function() onSuccess) {
    deleteCalendarFuture = repository.deleteRideCalendar()
        .then((_) => onSuccess());
  }

  @override
  void dispose() {}
}