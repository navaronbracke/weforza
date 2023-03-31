import 'package:weforza/database/export_rides_dao.dart';
import 'package:weforza/model/exportable_ride.dart';

class ExportRidesRepository {
  ExportRidesRepository(this.dao);

  final IExportRidesDao dao;

  Future<Iterable<ExportableRide>> getRides(DateTime? ride) {
    return dao.getRides(ride);
  }
}
