/// This enum declares the different filter options for filtering riders.
/// [RiderFilterOption.all] No filter.
/// [RiderFilterOption.active] Only active riders.
/// [RiderFilterOption.inactive] Only inactive riders.
enum RiderFilterOption {
  all(1),
  active(2),
  inactive(3);

  const RiderFilterOption(this.value);

  /// The raw value of this filter option.
  final int value;
}
