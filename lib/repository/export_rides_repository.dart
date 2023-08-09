import 'package:weforza/database/export_rides_dao.dart';
import 'package:weforza/file/file_uri_parser.dart';
import 'package:weforza/model/export/exportable_ride.dart';

class ExportRidesRepository {
  ExportRidesRepository(this.dao, this.fileUriParser);

  final ExportRidesDao dao;

  final FileUriParser fileUriParser;

  Future<Iterable<ExportableRide>> getRides(DateTime? ride) {
    return dao.getRides(ride, fileUriParser: fileUriParser);
  }
}
