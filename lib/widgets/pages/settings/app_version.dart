import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/riverpod/settings_provider.dart';
import 'package:weforza/theme/app_theme.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

/// This widget represents the app version display.
class AppVersion extends ConsumerWidget {
  const AppVersion({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final translator = S.of(context);
    final settings = ref.watch(settingsProvider);

    return PlatformAwareWidget(
      android: () => Text(
        translator.AppVersionNumber(settings.appVersion),
        style: ApplicationTheme.appVersionTextStyle,
      ),
      ios: () => Text(
        translator.AppVersionNumber(settings.appVersion),
        style: ApplicationTheme.appVersionTextStyle.copyWith(
          fontSize: 14,
        ),
      ),
    );
  }
}
