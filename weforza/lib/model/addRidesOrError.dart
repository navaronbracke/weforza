
/// This class is used to wrap the save state for adding one or multiple rides.
class AddRidesOrError {
  AddRidesOrError({
    required this.saving,
    required this.noSelection
  });

  AddRidesOrError.idle(): this(saving: false, noSelection: false);

  AddRidesOrError.saving(): this(saving: true, noSelection: false);

  AddRidesOrError.noSelection(): this(saving: false, noSelection: true);

  final bool saving;
  final bool noSelection;
}