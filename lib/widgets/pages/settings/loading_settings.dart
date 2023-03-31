import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/widgets/platform/platform_aware_loading_indicator.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

class LoadingSettings extends StatelessWidget {
  const LoadingSettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => PlatformAwareWidget(
        android: () => Scaffold(
          appBar: AppBar(
            title: Text(S.of(context).Settings),
          ),
          body: _buildBody(context),
        ),
        ios: () => CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            middle: Text(S.of(context).Settings),
            transitionBetweenRoutes: false,
          ),
          child: _buildBody(context),
        ),
      );

  Widget _buildBody(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const PlatformAwareLoadingIndicator(),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(S.of(context).SettingsLoading),
          ),
        ],
      ),
    );
  }
}
