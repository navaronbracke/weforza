import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/riverpod/package_info_provider.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';
import 'package:weforza/widgets/theme.dart';

/// This widget represents the app version display.
class AppVersion extends ConsumerWidget {
  const AppVersion({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final translator = S.of(context);
    final packageInfo = ref.watch(packageInfoProvider);

    const theme = AppTheme.settings;

    return PlatformAwareWidget(
      android: () => Text(
        translator.AppVersionNumber(packageInfo.version),
        style: theme.optionDescriptionStyle,
      ),
      ios: () => Text(
        translator.AppVersionNumber(packageInfo.version),
        style: theme.optionDescriptionStyle.copyWith(fontSize: 14),
      ),
    );
  }
}
