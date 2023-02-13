import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/model/export/export_riders_delegate.dart';
import 'package:weforza/riverpod/file_handler_provider.dart';
import 'package:weforza/riverpod/repository/serialize_riders_repository_provider.dart';
import 'package:weforza/widgets/pages/export_data_page/export_data_page.dart';

class ExportRidersPage extends ConsumerStatefulWidget {
  const ExportRidersPage({super.key});

  @override
  ConsumerState<ExportRidersPage> createState() => _ExportRidersPageState();
}

class _ExportRidersPageState extends ConsumerState<ExportRidersPage>
    with SingleTickerProviderStateMixin {
  late final ExportRidersDelegate _delegate;

  late final AnimationController checkmarkController;

  @override
  void initState() {
    super.initState();
    _delegate = ExportRidersDelegate(
      fileHandler: ref.read(fileHandlerProvider),
      initialFileName: S.current.ExportRidersDefaultFileName,
      serializeRidersRepository: ref.read(serializeRidersRepositoryProvider),
    );

    checkmarkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  @override
  Widget build(BuildContext context) {
    final translator = S.of(context);

    return ExportDataPage(
      checkmarkAnimationController: checkmarkController,
      delegate: _delegate,
      onPressed: () => _delegate.exportDataToFile(
        ExportRidersOptions(csvHeader: translator.ExportRidersCsvHeader),
      ),
      title: translator.ExportRiders,
    );
  }

  @override
  void dispose() {
    _delegate.dispose();
    checkmarkController.dispose();
    super.dispose();
  }
}
