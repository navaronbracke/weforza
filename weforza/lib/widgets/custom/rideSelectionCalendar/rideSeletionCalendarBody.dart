//We need the body to do the following
//- support swiping left/right -> pageview
//- handle item taps -> update specific item
//- update when the header changes -> listen to current date stream, animate to page if the date changes
import 'package:flutter/material.dart';

class RideSelectionCalendarBody extends StatefulWidget {
  @override
  _RideSelectionCalendarBodyState createState() => _RideSelectionCalendarBodyState();
}

class _RideSelectionCalendarBodyState extends State<RideSelectionCalendarBody> {
  @override
  Widget build(BuildContext context) {
    //TODO: build -> use pageview, set initial page to current year , current month
    //item count = 12 * 6000 (12 months in a year , 3000 years forward and backward)
    //initial index = half of item count = 12 * 3000
    //on page changed -> if + pagenr -> add month else remove month
    //reuse the body build method of the old calendar
    //redo the styling / method calls on the items
    //add / subtract month should update the internal current page and the stream for the header
  }

}
