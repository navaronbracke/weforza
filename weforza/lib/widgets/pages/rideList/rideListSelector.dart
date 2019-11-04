
import 'package:weforza/model/ride.dart';

abstract class IRideSelector {
  void selectRide(IRideSelectable item);
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
  DateTime getDateOfRide();

  int getIndex();

  void unSelect();

  void select();

  int getCount();
}