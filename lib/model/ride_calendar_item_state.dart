/// This enum defines the different states for ride calendar items.
enum RideCalendarItemState {
  /// The ride calendar item is a day in the current selection.
  currentSelection,

  /// The ride calendar item is a day in the future, with a scheduled ride.
  futureRide,

  /// The ride calendar item is a day in the past, without a scheduled ride.
  pastDay,

  /// The ride calendar item is a day in the past, with a scheduled ride.
  pastRide,
}
