
import 'package:flutter/widgets.dart';

///This class checks the [Orientation] and returns an appropriate [Widget].
///[portrait] and [landscape] must not be null.
class OrientationAwareWidget extends StatelessWidget {
  OrientationAwareWidget({@required this.portrait, @required this.landscape, Key key}):
        assert(portrait != null && landscape != null), super(key: key);

  ///The [Widget] builder for [Orientation.portrait].
  final Function() portrait;
  ///The [Widget] builder for [Orientation.landscape].
  final Function() landscape;

  @override
  Widget build(BuildContext context) {
      final orientation = MediaQuery.of(context).orientation;
      return orientation == Orientation.portrait ? portrait(): landscape();
  }
}