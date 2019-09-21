import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/model/person.dart';
import 'package:weforza/viewmodel/personListViewModel.dart';
import 'package:weforza/widgets/platformAwareWidgetBuilder.dart';

///This [Widget] represents an overview page for known people.
class PersonList extends StatelessWidget implements PlatformAwareWidget {
  PersonList(this._viewModel);

  final PersonListViewModel _viewModel;

  @override
  Widget build(BuildContext context) => PlatformAwareWidgetBuilder.buildPlatformAwareWidget(context, this);

  @override
  Widget buildAndroidWidget(BuildContext context) {
    // TODO: implement buildAndroidWidget
    // TODO: make it orientation aware?
    return Scaffold(
      appBar: AppBar(),
      body: Center()
    );
  }

  @override
  Widget buildIosWidget(BuildContext context) {
    // TODO: implement buildIosWidget
    // TODO: make it orientation aware?
    return null;
  }


}