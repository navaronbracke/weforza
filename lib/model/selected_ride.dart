import 'package:weforza/model/member.dart';
import 'package:weforza/model/ride.dart';

/// This class represents a selected ride.
class SelectedRide {
  const SelectedRide(this.value, this.attendees);

  /// The ride that was selected.
  final Ride value;

  /// The attendees for this ride.
  final Future<List<Member>> attendees;
}
