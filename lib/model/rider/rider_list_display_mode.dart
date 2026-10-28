/// This enum declares the different filter options for filtering riders.
/// [RiderListDisplayMode.all] No filter.
/// [RiderListDisplayMode.active] Only active riders.
/// [RiderListDisplayMode.inactive] Only inactive riders.
enum RiderListDisplayMode {
  all(0),
  active(1),
  inactive(2);

  const new(this.value);

  /// The raw value of this filter option.
  final int value;

  static RiderListDisplayMode fromInt(int? value) => switch (value) {
    1 => .active,
    2 => .inactive,
    _ => .all,
  };
}
