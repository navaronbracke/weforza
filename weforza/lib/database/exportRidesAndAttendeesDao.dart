

import 'package:sembast/sembast.dart';
import 'package:weforza/database/databaseProvider.dart';

abstract class IExportRidesAndAttendeesDao {
  //Get all the rides with their attendees.
  Future<List<Map<String,dynamic>>> getRidesAndAttendees();
}

class ExportRidesAndAttendeesDao implements IExportRidesAndAttendeesDao {
  ExportRidesAndAttendeesDao(this._database): assert(_database != null);

  final Database _database;
  ///A reference to the [RideAttendee] store.
  final _rideAttendeeStore = DatabaseProvider.rideAttendeeStore;
  ///A reference to the [Ride] store.
  final _rideStore = DatabaseProvider.rideStore;
  ///A reference to the [Member] store.
  final _memberStore = DatabaseProvider.memberStore;

  @override
  Future<List<Map<String, dynamic>>> getRidesAndAttendees() {
    // TODO: implement getRidesAndAttendees
  }
}