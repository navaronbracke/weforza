
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weforza/blocs/memberDetailsBloc.dart';
import 'package:weforza/generated/i18n.dart';
import 'package:weforza/injection/injector.dart';
import 'package:weforza/model/member.dart';
import 'package:weforza/widgets/platformAwareWidgetBuilder.dart';

///This class represents the detail page for a [Member].
class MemberDetailsPage extends StatefulWidget {
  @override
  _MemberDetailsPageState createState() => _MemberDetailsPageState(InjectionContainer.get<MemberDetailsBloc>());
}

///This is the [State] class for [MemberDetailsPage].
class _MemberDetailsPageState extends State<MemberDetailsPage> implements PlatformAwareWidget {
  _MemberDetailsPageState(this._bloc);

  ///The BLoC in charge of the content.
  final MemberDetailsBloc _bloc;

  @override
  Widget build(BuildContext context) => PlatformAwareWidgetBuilder.buildPlatformAwareWidget(context, this);

  @override
  Widget buildAndroidWidget(BuildContext context) {
    // TODO: implement buildAndroidWidget
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).MemberDetailsTitle),
      ),
      body: Container(),
    );
  }

  @override
  Widget buildIosWidget(BuildContext context) {
    // TODO: implement buildIosWidget
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(S.of(context).MemberDetailsTitle),
        transitionBetweenRoutes: false,
      ),
      child: Container(),
    );
  }



}