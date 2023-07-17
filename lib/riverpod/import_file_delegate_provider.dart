import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/model/import/import_file_delegate.dart';
import 'package:weforza/model/import/io_import_file_delegate.dart';
import 'package:weforza/riverpod/file_system_provider.dart';

final importFileDelegateProvider = Provider<ImportFileDelegate>((ref) {
  return IoImportFileDelegate(ref.read(fileSystemProvider));
});
