import 'package:flutter/widgets.dart';
import 'package:weforza/blocs/addRideBloc.dart';

class AddRideBlocProvider extends InheritedWidget {
  const AddRideBlocProvider({
    Key key,
    @required this.bloc,
    @required Widget child,
  }) : assert(bloc != null),
       assert(child != null),
       super(key: key, child: child);

  final AddRideBloc bloc;

  static AddRideBlocProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AddRideBlocProvider>();
  }

  @override
  bool updateShouldNotify(AddRideBlocProvider old) => bloc != old.bloc;
}