/// This enum declares the different filter options for filtering riders.
/// [RiderFilterOption.all] No filter.
/// [RiderFilterOption.active] Only active riders.
/// [RiderFilterOption.inactive] Only inactive riders.
enum RiderFilterOption {
  all(0),
  active(1),
  inactive(2);

  const RiderFilterOption(this.value);

  /// The raw value of this filter option.
  final int value;

  static RiderFilterOption fromInt(int? value) {
    return switch (value) {
      1 => RiderFilterOption.active,
      2 => RiderFilterOption.inactive,
      _ => RiderFilterOption.all,
    };
  }
}
