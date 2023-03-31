import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/exceptions/exceptions.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

class ExportDataFolderSelection extends StatelessWidget {
  const ExportDataFolderSelection({
    required this.initialData,
    required this.selectDirectory,
    required this.stream,
    super.key,
  });

  /// The initial data for the stream builder.
  final AsyncValue<Directory?> initialData;

  /// The function that selects a new directory.
  final void Function() selectDirectory;

  /// The stream that provides updates for the selected directory.
  final Stream<AsyncValue<Directory?>> stream;

  Widget _buildSelectDirectoryButton(
    String directoryPathLabel, {
    String? errorMessage,
  }) {
    return GestureDetector(
      onTap: selectDirectory,
      child: PlatformAwareWidget(
        android: (context) {
          final theme = Theme.of(context);

          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.folder, color: theme.primaryColor),
                  Flexible(child: Text(directoryPathLabel, maxLines: 1, overflow: TextOverflow.ellipsis)),
                ],
              ),
              if (errorMessage != null)
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(errorMessage, style: theme.inputDecorationTheme.errorStyle),
                  ),
                ),
            ],
          );
        },
        ios: (_) => CupertinoFormRow(
          prefix: const Icon(CupertinoIcons.folder_fill, color: CupertinoColors.systemTeal),
          error: errorMessage != null ? Text(errorMessage) : null,
          child: Text(directoryPathLabel, maxLines: 1, overflow: TextOverflow.ellipsis),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final S translator = S.of(context);
    final String selectDirectoryLabel = translator.selectDirectory;

    return StreamBuilder<AsyncValue<Directory?>>(
      initialData: initialData,
      stream: stream,
      builder: (context, snapshot) {
        final AsyncValue<Directory?> asyncValue = snapshot.data!;

        final String selectedDirectoryPathLabel = asyncValue.value?.path ?? selectDirectoryLabel;

        if (asyncValue.isLoading) {
          return PlatformAwareWidget(
            android: (_) => Row(
              children: [
                const CircularProgressIndicator(),
                Flexible(child: Text(selectedDirectoryPathLabel, maxLines: 1, overflow: TextOverflow.ellipsis)),
              ],
            ),
            ios: (_) => CupertinoFormRow(
              prefix: const CupertinoActivityIndicator(),
              child: Text(selectedDirectoryPathLabel, maxLines: 1, overflow: TextOverflow.ellipsis),
            ),
          );
        }

        final Object? error = asyncValue.error;

        if (error != null) {
          if (error is DirectoryNotFoundException) {
            return _buildSelectDirectoryButton(
              selectedDirectoryPathLabel,
              errorMessage: translator.directoryDoesNotExist,
            );
          }

          if (error is DirectoryRequiredException) {
            return _buildSelectDirectoryButton(selectedDirectoryPathLabel, errorMessage: translator.directoryRequired);
          }

          return _buildSelectDirectoryButton(selectedDirectoryPathLabel, errorMessage: translator.genericError);
        }

        return _buildSelectDirectoryButton(selectedDirectoryPathLabel);
      },
    );
  }
}
