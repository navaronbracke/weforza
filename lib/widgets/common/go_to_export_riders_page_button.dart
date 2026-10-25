import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/riverpod/rider/rider_amount_provider.dart';
import 'package:weforza/widgets/pages/export_data_page/export_riders_page.dart';
import 'package:weforza/widgets/platform/cupertino_icon_button.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

class GoToExportRidersPageButton extends ConsumerWidget {
  const new({super.key});

  void _goToExportRidersPage(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ExportRidersPage()));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int amountOfRiders = switch (ref.watch(riderAmountProvider)) {
      AsyncLoading<int>() || AsyncError<int>() => 0,
      AsyncData<int>(:final value) => value,
    };

    if (amountOfRiders == 0) {
      return const SizedBox.shrink();
    }

    return PlatformAwareWidget(
      android: (context) {
        return IconButton(icon: const Icon(Icons.file_upload), onPressed: () => _goToExportRidersPage(context));
      },
      ios: (context) {
        return CupertinoIconButton(
          icon: CupertinoIcons.arrow_up_doc_fill,
          onPressed: () => _goToExportRidersPage(context),
        );
      },
    );
  }
}
