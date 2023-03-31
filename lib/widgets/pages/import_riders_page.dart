import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/exceptions/exceptions.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/model/import_riders_state.dart';
import 'package:weforza/model/rider/import_riders_delegate.dart';
import 'package:weforza/riverpod/file_handler_provider.dart';
import 'package:weforza/riverpod/member/member_list_provider.dart';
import 'package:weforza/riverpod/repository/serialize_riders_repository_provider.dart';
import 'package:weforza/widgets/common/generic_error.dart';
import 'package:weforza/widgets/common/progress_indicator_with_label.dart';
import 'package:weforza/widgets/custom/animated_checkmark.dart';
import 'package:weforza/widgets/platform/platform_aware_loading_indicator.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

class ImportRidersPage extends ConsumerStatefulWidget {
  const ImportRidersPage({super.key});

  @override
  ConsumerState<ImportRidersPage> createState() => _ImportRidersPageState();
}

class _ImportRidersPageState extends ConsumerState<ImportRidersPage> {
  late final ImportRidersDelegate delegate;

  void _onImportRidersPressed() {
    delegate.importRiders(
      whenComplete: () {
        if (mounted) {
          ref.invalidate(memberListProvider);
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    delegate = ImportRidersDelegate(
      ref.read(fileHandlerProvider),
      ref.read(serializeRidersRepositoryProvider),
    );
  }

  Widget _buildBody() {
    return Center(
      child: StreamBuilder<ImportRidersState>(
        initialData: delegate.currentState,
        stream: delegate.stream,
        builder: (context, snapshot) {
          final translator = S.of(context);
          final buttonLabel = translator.PickFile;
          final error = snapshot.error;

          if (error is UnsupportedFileFormatError) {
            return _ImportRidersButton(
              errorMessage: translator.OnlyCsvOrJsonAllowed,
              label: buttonLabel,
              onPressed: _onImportRidersPressed,
            );
          }

          if (error is FileRequiredException) {
            return _ImportRidersButton(
              errorMessage: translator.ImportRidersFileRequired,
              label: buttonLabel,
              onPressed: _onImportRidersPressed,
            );
          }

          if (error is FormatException) {
            return _ImportRidersButton(
              errorMessage: translator.FileMalformed,
              label: buttonLabel,
              onPressed: _onImportRidersPressed,
            );
          }

          final data = snapshot.data;

          if (error != null || data == null) {
            return Center(
              child: GenericErrorWithBackButton(
                message: translator.ImportRidersGenericErrorMessage,
              ),
            );
          }

          switch (data) {
            case ImportRidersState.done:
              return const AdaptiveAnimatedCheckmark();
            case ImportRidersState.idle:
              return _ImportRidersButton(
                label: buttonLabel,
                onPressed: _onImportRidersPressed,
              );
            case ImportRidersState.importing:
              return ProgressIndicatorWithLabel(
                label: translator.ImportRidersProcessingFile,
              );
            case ImportRidersState.pickingFile:
              return const PlatformAwareLoadingIndicator();
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlatformAwareWidget(
      android: (context) => Scaffold(
        appBar: AppBar(title: Text(S.of(context).ImportRiders)),
        body: _buildBody(),
      ),
      ios: (context) => CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text(S.of(context).ImportRiders),
          transitionBetweenRoutes: false,
        ),
        child: _buildBody(),
      ),
    );
  }

  @override
  void dispose() {
    delegate.dispose();
    super.dispose();
  }
}

class _ImportRidersButton extends StatelessWidget {
  const _ImportRidersButton({
    required this.label,
    required this.onPressed,
    this.errorMessage,
  });

  /// The error message that is displayed below the button.
  final String? errorMessage;

  /// The text for the button.
  final String label;

  /// The onTap handler for the button.
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return PlatformAwareWidget(
      android: (context) {
        final theme = Theme.of(context);

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: TextButton(onPressed: onPressed, child: Text(label)),
            ),
            Flexible(
              child: Text(
                errorMessage ?? '',
                style: theme.textTheme.labelMedium!.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
            ),
          ],
        );
      },
      ios: (_) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: CupertinoFormRow(
              error: errorMessage == null
                  ? null
                  : Center(child: Text(errorMessage!)),
              child: Center(
                child: CupertinoButton(
                  onPressed: onPressed,
                  child: Text(label),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
