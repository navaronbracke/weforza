import 'dart:async';

import 'package:weforza/database/rider_dao.dart';
import 'package:weforza/file/file_uri_parser.dart';
import 'package:weforza/model/rider/rider.dart';
import 'package:weforza/model/rider/rider_filter_option.dart';

/// This class provides an API to work with riders.
class RiderRepository {
  RiderRepository(this._dao, this._fileUriParser);

  final RiderDao _dao;

  final FileUriParser _fileUriParser;

  Future<void> addRider(Rider rider) => _dao.addRider(rider);

  Future<void> deleteRider(String uuid) => _dao.deleteRider(uuid);

  Future<int> getAttendingCount(String uuid) => _dao.getAttendingCount(uuid);

  Future<List<Rider>> getRiders(RiderFilterOption filter) {
    return _dao.getRiders(filter, fileUriParser: _fileUriParser);
  }

  Future<void> setRiderActive(String uuid, {required bool value}) {
    return _dao.setRiderActive(uuid, value: value);
  }

  Future<void> updateRider(Rider rider) => _dao.updateRider(rider);
}
