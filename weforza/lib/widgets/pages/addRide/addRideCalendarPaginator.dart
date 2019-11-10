
abstract class IAddRideCalendarPaginator {

  ///Get the date that corresponds to the currently visible month.
  DateTime get pageDate;

  ///Move back one page.
  void pageBack();

  ///Move forward one page.
  void pageForward();
}