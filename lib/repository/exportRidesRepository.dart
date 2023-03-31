import 'package:weforza/database/export_rides_dao.dart';
import 'package:weforza/model/exportableRide.dart';

class ExportRidesRepository {
  ExportRidesRepository(this.dao);

  final IExportRidesDao dao;

  Future<Iterable<ExportableRide>> getRides() => dao.getRides();
}
