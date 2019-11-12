
import 'package:weforza/widgets/pages/addRide/addRidePage.dart';

///This interface defines a page switching handler for [AddRidePage].
abstract class IAddRideCalendarPaginator {

  ///Get the date that corresponds to the currently visible month.
  DateTime get pageDate;

  ///Move back one page.
  void pageBack();

  ///Move forward one page.
  void pageForward();

  ///Get the days in the current month.
  int get daysInMonth;
}