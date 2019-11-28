
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
  DateTime getDateOfRide();

  int getIndex();

  void unSelect();

  void select();

  int getCount();
}