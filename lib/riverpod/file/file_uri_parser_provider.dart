import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/file/file_uri_parser.dart';
import 'package:weforza/riverpod/file/file_system_provider.dart';

final fileUriParserProvider = Provider<FileUriParser>((ref) {
  return FileUriParser(ref.read(fileSystemProvider));
});
