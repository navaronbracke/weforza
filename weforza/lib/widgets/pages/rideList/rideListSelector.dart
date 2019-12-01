
import 'package:weforza/model/ride.dart';

abstract class IRideSelector {
  ///Select or un-select [item]
  void selectRide(IRideSelectable item);
  ///Whether we are in delete mode
  bool get isDeleteMode;

  void enableDeleteMode();
}

abstract class IRideAttendeeSelector {
  void selectAttendee(IRideAttendeeSelectable item);
}

abstract class IRideAttendeeSelectable {
  Attendee getAttendee();

  void select();

  void unSelect();
}

abstract class IRideSelectable {

  Ride getRide();

  int getCount() => getRide()?.attendees?.length ?? 0;

  bool isAttendeeOfRide(Attendee attendee) => getRide().attendees.contains(attendee);

  void addAttendee(Attendee attendee);

  void removeAttendee(Attendee attendee);

  void unSelect();

  void select();

  @override
  bool operator ==(Object other) => other is IRideSelectable && getRide() == other.getRide();

  @override
  int get hashCode => getRide().hashCode;
}