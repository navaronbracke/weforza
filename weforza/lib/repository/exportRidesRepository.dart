

import 'package:weforza/database/exportRidesDao.dart';
import 'package:weforza/model/exportableRide.dart';

class ExportRidesRepository {
  ExportRidesRepository(this.dao): assert(dao != null);

  final IExportRidesDao dao;

  Future<Iterable<ExportableRide>> getRides() => dao.getRides();
}