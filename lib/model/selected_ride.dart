import 'package:weforza/model/member.dart';
import 'package:weforza/model/ride.dart';

/// This class represents a selected ride.
class SelectedRide {
  const SelectedRide(this.attendees, this.value);

  /// The attendees for this ride.
  final Future<List<Member>> attendees;

  /// The ride that was selected.
  final Ride value;

  @override
  int get hashCode => Object.hash(attendees, value);

  @override
  bool operator ==(Object other) {
    return other is SelectedRide &&
        attendees == other.attendees &&
        value == other.value;
  }
}
