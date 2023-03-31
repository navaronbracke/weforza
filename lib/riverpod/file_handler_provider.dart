import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/file/file_handler.dart';

/// This provider provides the file handler.
final fileHandlerProvider = Provider<FileHandler>((_) => IoFileHandler());

/// This provider provides the default [Directory] for export files.
final exportDataDefaultDirectoryProvider = Provider<Directory?>((_) => null);
