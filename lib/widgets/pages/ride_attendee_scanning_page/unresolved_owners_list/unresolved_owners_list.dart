import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/model/member.dart';
import 'package:weforza/theme/app_theme.dart';
import 'package:weforza/widgets/platform/platform_aware_loading_indicator.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

class UnresolvedOwnersList extends StatelessWidget {
  const UnresolvedOwnersList({
    Key? key,
    required this.future,
    required this.itemBuilder,
    required this.onButtonPressed,
  }) : super(key: key);

  final Future<List<Member>> future;
  final Widget Function(Member member) itemBuilder;
  final void Function() onButtonPressed;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Member>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final list = snapshot.data ?? [];

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Center(
                  child: Text(
                    S.of(context).UnresolvedOwnersDescription,
                    style: ApplicationTheme.multipleOwnersListTooltipStyle,
                    softWrap: true,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemBuilder: (context, index) => itemBuilder(list[index]),
                  itemCount: list.length,
                ),
              ),
              Center(child: _buildButton(context)),
            ],
          );
        }

        return const Center(child: PlatformAwareLoadingIndicator());
      },
    );
  }

  Widget _buildButton(BuildContext context) {
    final translator = S.of(context);

    return PlatformAwareWidget(
      android: () => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: TextButton(
          onPressed: onButtonPressed,
          child: Text(translator.Continue),
        ),
      ),
      ios: () {
        final double bottomPadding = MediaQuery.of(context).padding.bottom;

        return Padding(
          padding: EdgeInsets.only(bottom: 20 + bottomPadding, top: 8),
          child: CupertinoButton.filled(
            onPressed: onButtonPressed,
            child: Text(
              translator.Continue,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }
}
