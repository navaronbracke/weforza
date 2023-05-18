import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/file/file_handler.dart';

/// This provider provides the file handler.
final fileHandlerProvider = Provider<FileHandler>((ref) => IoFileHandler(ref.read(fileHandlerDirectoriesProvider)));

/// This provider provides the [FileHandlerDirectories] for the [FileHandler].
final fileHandlerDirectoriesProvider = Provider<FileHandlerDirectories>(
  (_) => throw UnimplementedError('This implementation is a stub. Instead, preload the directories on startup.'),
);
