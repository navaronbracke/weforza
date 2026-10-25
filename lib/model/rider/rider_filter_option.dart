/// This enum declares the different filter options for filtering riders.
/// [RiderFilterOption.all] No filter.
/// [RiderFilterOption.active] Only active riders.
/// [RiderFilterOption.inactive] Only inactive riders.
enum RiderFilterOption {
  all(0),
  active(1),
  inactive(2);

  const new(this.value);

  /// The raw value of this filter option.
  final int value;

  static RiderFilterOption fromInt(int? value) => switch (value) {
    1 => .active,
    2 => .inactive,
    _ => .all,
  };
}
