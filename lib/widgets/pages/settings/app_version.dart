import 'package:flutter/widgets.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/theme/app_theme.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

/// This widget represents the app version display.
class AppVersion extends StatelessWidget {
  const AppVersion({Key? key, required this.version}) : super(key: key);

  final String version;

  @override
  Widget build(BuildContext context) {
    final translator = S.of(context);

    return PlatformAwareWidget(
      android: () => Text(
        translator.AppVersionNumber(version),
        style: ApplicationTheme.appVersionTextStyle,
      ),
      ios: () => Text(
        translator.AppVersionNumber(version),
        style: ApplicationTheme.appVersionTextStyle.copyWith(
          fontSize: 14,
        ),
      ),
    );
  }
}
