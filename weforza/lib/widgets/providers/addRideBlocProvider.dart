import 'package:flutter/widgets.dart';
import 'package:weforza/blocs/addRideBloc.dart';

class AddRideBlocProvider extends InheritedWidget {
  const AddRideBlocProvider({
    Key? key,
    required this.bloc,
    required Widget child,
  }): super(key: key, child: child);

  final AddRideBloc bloc;

  static AddRideBlocProvider of(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<AddRideBlocProvider>();

    assert(provider != null, "There is no AddRideBlocProvider in the Widget tree.");

    return provider!;
  }

  @override
  bool updateShouldNotify(AddRideBlocProvider old) => bloc != old.bloc;
}