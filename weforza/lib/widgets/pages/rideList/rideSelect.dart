
///This interface defines a contract for selectable rides.
abstract class IRideSelectable {

  ///This is a callback for an item that is selected.
  void select();
  ///This is a callback for an item that is unselected.
  void unSelect();
}

///This interface defines a contract for selecting rides.
abstract class IRideSelector {}