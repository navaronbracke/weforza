/// This enum declares the different filter options for filtering riders.
///
/// [RiderFilterOption.all] No filter.
/// [RiderFilterOption.active] Only active riders.
/// [RiderFilterOption.inactive] Only inactive riders.
enum RiderFilterOption {
  all(0),
  active(1),
  inactive(2);

  const RiderFilterOption(this.value);

  final int value;
}
