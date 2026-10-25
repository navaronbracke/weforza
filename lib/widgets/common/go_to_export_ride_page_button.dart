import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/riverpod/ride/ride_list_count_provider.dart';
import 'package:weforza/widgets/pages/export_data_page/export_ride_page.dart';
import 'package:weforza/widgets/platform/cupertino_icon_button.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

class GoToExportRidePageButton extends ConsumerWidget {
  const new({super.key});

  void _goToExportRidePage(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ExportRidePage()));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int amountOfRides = switch (ref.watch(rideListCountProvider)) {
      AsyncLoading<int>() || AsyncError<int>() => 0,
      AsyncData<int>(:final value) => value,
    };

    if (amountOfRides == 0) {
      return const SizedBox.shrink();
    }

    return PlatformAwareWidget(
      android: (BuildContext context) {
        return IconButton(icon: const Icon(Icons.file_upload), onPressed: () => _goToExportRidePage(context));
      },
      ios: (BuildContext context) {
        return CupertinoIconButton(
          icon: CupertinoIcons.arrow_up_doc_fill,
          onPressed: () => _goToExportRidePage(context),
        );
      },
    );
  }
}
