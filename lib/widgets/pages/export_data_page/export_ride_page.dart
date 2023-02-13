import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/model/export/export_rides_delegate.dart';
import 'package:weforza/model/ride.dart';
import 'package:weforza/riverpod/file_handler_provider.dart';
import 'package:weforza/riverpod/repository/export_rides_repository_provider.dart';
import 'package:weforza/widgets/custom/animated_circle_checkmark.dart';
import 'package:weforza/widgets/pages/export_data_page/export_data_page.dart';

/// This widget represents a page for exporting rides.
/// It supports both exporting a single ride and exporting all rides.
class ExportRidePage extends ConsumerStatefulWidget {
  const ExportRidePage({super.key, this.selectedRide});

  /// The selected ride that should be exported.
  ///
  /// If this is null, all the rides are exported.
  final Ride? selectedRide;

  @override
  ConsumerState<ExportRidePage> createState() => _ExportRidePageState();
}

class _ExportRidePageState extends ConsumerState<ExportRidePage> with SingleTickerProviderStateMixin {
  late final ExportRidesDelegate _delegate;

  late final AnimationController checkmarkController;

  String _getInitialFileName(Ride? ride) {
    final translator = S.current;

    return ride == null
        ? translator.ExportRidesFileNamePlaceholder
        : translator.ExportRideFileNamePlaceholder(ride.dateAsDayMonthYear);
  }

  @override
  void initState() {
    super.initState();
    _delegate = ExportRidesDelegate(
      fileHandler: ref.read(fileHandlerProvider),
      initialFileName: _getInitialFileName(widget.selectedRide),
      repository: ref.read(exportRidesRepositoryProvider),
    );

    checkmarkController = AnimationController(
      vsync: this,
      duration: AnimatedCircleCheckmark.kCheckmarkAnimationDuration,
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedRide = widget.selectedRide;
    final translator = S.of(context);

    return ExportDataPage(
      checkmarkAnimationController: checkmarkController,
      delegate: _delegate,
      onPressed: () => _delegate.exportDataToFile(
        ExportRidesOptions(ride: selectedRide?.date),
      ),
      title: selectedRide == null ? translator.exportRides : translator.exportRide,
    );
  }

  @override
  void dispose() {
    _delegate.dispose();
    checkmarkController.dispose();
    super.dispose();
  }
}
