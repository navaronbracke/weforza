import 'package:weforza/database/export_rides_dao.dart';
import 'package:weforza/model/export/exportable_ride.dart';

class ExportRidesRepository {
  ExportRidesRepository(this.dao);

  final ExportRidesDao dao;

  Future<Iterable<ExportableRide>> getRides(DateTime? ride) {
    return dao.getRides(ride);
  }
}
