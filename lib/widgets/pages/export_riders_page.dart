import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/model/rider/export_riders_delegate.dart';
import 'package:weforza/riverpod/file_handler_provider.dart';
import 'package:weforza/riverpod/repository/serialize_riders_repository_provider.dart';
import 'package:weforza/widgets/common/export_file_format_selection.dart';
import 'package:weforza/widgets/pages/export_data_page/export_data_page.dart';

class ExportRidersPage extends ConsumerStatefulWidget {
  const ExportRidersPage({super.key});

  @override
  ConsumerState<ExportRidersPage> createState() => _ExportRidersPageState();
}

class _ExportRidersPageState extends ConsumerState<ExportRidersPage> {
  late final ExportRidersDelegate _delegate;

  @override
  void initState() {
    super.initState();
    _delegate = ExportRidersDelegate(
      fileHandler: ref.read(fileHandlerProvider),
      initialFileName: S.current.ExportRidersDefaultFileName,
      serializeRidersRepository: ref.read(serializeRidersRepositoryProvider),
    );
  }

  @override
  Widget build(BuildContext context) {
    final translator = S.of(context);

    return ExportDataPage(
      exportingLabel: translator.ExportingRiders,
      fileExistsLabel: ExportFileNameExistsLabel(
        initialData: _delegate.fileExists,
        stream: _delegate.fileExistsStream,
      ),
      fileFormatSelection: ExportFileFormatSelection(
        initialValue: _delegate.currentFileFormat,
        onFormatSelected: _delegate.setFileFormat,
        stream: _delegate.fileFormatStream,
      ),
      fileNameController: _delegate.fileNameController,
      fileNameFormFieldKey: _delegate.fileNameKey,
      initialData: _delegate.currentState,
      onPressed: () => _delegate.exportRiders(
        csvHeader: translator.ExportRidersCsvHeader,
      ),
      stream: _delegate.stream,
      title: translator.ExportRiders,
    );
  }

  @override
  void dispose() {
    _delegate.dispose();
    super.dispose();
  }
}
