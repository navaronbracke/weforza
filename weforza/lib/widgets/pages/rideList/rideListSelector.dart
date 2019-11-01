
import 'package:weforza/model/ride.dart';

///This interface defines a contract for selectable rides.
abstract class IRideSelectable {

  ///This is a callback for an item that is selected.
  void select();

  ///Get the date of this item's ride.
  DateTime getDate();

  ///Check whether [attendee] is attending this ride.
  bool isAttendeeOf(Attendee attendee);

  void add(Attendee attendee);

  void remove(Attendee attendee);

  Ride getRide();
}

///This interface defines a contract for selecting rides.
abstract class IRideSelector {
  void selectRide(IRideSelectable item);
}

///This interface defines a contract for selectable ride attendees.
abstract class IRideAttendeeSelectable {
  ///This is a callback for an item that is selected.
  void select();

  Attendee getAttendee();
}

///This interface defines a contract for selecting ride attendees.
abstract class IRideAttendeeSelector {
  void selectAttendee(IRideAttendeeSelectable item);
}