
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weforza/blocs/personSelectBloc.dart';
import 'package:weforza/generated/i18n.dart';
import 'package:weforza/injection/injector.dart';
import 'package:weforza/model/person.dart';
import 'package:weforza/widgets/platformAwareWidgetBuilder.dart';

class PersonDetailsPage extends StatefulWidget {
  @override
  _PersonDetailsPageState createState() => _PersonDetailsPageState(InjectionContainer.get<PersonSelectBloc>().person);
}

class _PersonDetailsPageState extends State<PersonDetailsPage> implements PlatformAwareWidget {
  _PersonDetailsPageState(this._person);

  final Person _person;

  @override
  Widget build(BuildContext context) => PlatformAwareWidgetBuilder.buildPlatformAwareWidget(context, this);

  @override
  Widget buildAndroidWidget(BuildContext context) {
    // TODO: implement buildAndroidWidget
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).PersonDetailsTitle),
      ),
      body: Container(),
    );
  }

  @override
  Widget buildIosWidget(BuildContext context) {
    // TODO: implement buildIosWidget
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(S.of(context).PersonDetailsTitle),
      ),
      child: Container(),
    );
  }



}