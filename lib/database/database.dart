import 'package:drift/drift.dart';
import 'package:weforza/database/devices.dart';
import 'package:weforza/database/excluded_terms.dart';
import 'package:weforza/database/ride_attendees.dart';
import 'package:weforza/database/riders.dart';
import 'package:weforza/database/rides.dart';

part 'database.g.dart';

/// The database for the application.
///
/// The definition is generated from the tables listed in `tables`.
@DriftDatabase(tables: [Riders, Rides, RideAttendees, Devices, ExcludedTerms])
class WeForzaDatabase extends _$WeForzaDatabase {}
