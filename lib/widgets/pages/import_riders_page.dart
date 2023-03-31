import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weforza/exceptions/exceptions.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/model/import_riders_state.dart';
import 'package:weforza/riverpod/member/import_riders_provider.dart';
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
  late final ImportRidersNotifier notifier;

  final _importController = BehaviorSubject.seeded(ImportRidersState.idle);

  @override
  void initState() {
    super.initState();
    notifier = ref.read(importRidersProvider);
  }

  @override
  Widget build(BuildContext context) {
    final title = Text(S.of(context).ImportRiders);

    return PlatformAwareWidget(
      android: (context) => Scaffold(
        appBar: AppBar(title: title),
        body: Center(child: _buildBody()),
      ),
      ios: (context) => CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: title,
          transitionBetweenRoutes: false,
        ),
        child: Center(child: _buildBody()),
      ),
    );
  }

  Widget _buildBody() {
    return StreamBuilder<ImportRidersState>(
      initialData: _importController.value,
      stream: _importController,
      builder: (context, snapshot) {
        final translator = S.of(context);
        final buttonLabel = translator.PickFile;

        final error = snapshot.error;
        final data = snapshot.data;

        if (error is NoFileChosenError) {
          return _ImportRidersButton(
            errorMessage: translator.ImportRidersFileRequired,
            label: buttonLabel,
            onPressed: _onImportRidersPressed,
          );
        }

        if (error is InvalidFileExtensionError) {
          return _ImportRidersButton(
            errorMessage: translator.PickFileJsonOrCsvRequired,
            label: buttonLabel,
            onPressed: _onImportRidersPressed,
          );
        }

        if (error is CsvHeaderMissingError) {
          return _ImportRidersButton(
            errorMessage: translator.ImportRidersCsvHeaderRequired,
            label: buttonLabel,
            onPressed: _onImportRidersPressed,
          );
        }

        if (error is JsonFormatIncompatibleException) {
          return _ImportRidersButton(
            errorMessage: translator.PickFileJsonIncompatible,
            label: buttonLabel,
            onPressed: _onImportRidersPressed,
          );
        }

        if (error != null || data == null) {
          return GenericError(text: translator.GenericError);
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
    );
  }

  void _onImportRidersPressed() {
    notifier.importRiders(
      (progress) {
        if (!_importController.isClosed) {
          _importController.add(progress);
        }
      },
      (error) {
        if (!_importController.isClosed) {
          _importController.addError(error);
        }
      },
    );
  }

  @override
  void dispose() {
    _importController.close();
    super.dispose();
  }
}

class _ImportRidersButton extends StatelessWidget {
  const _ImportRidersButton({
    required this.label,
    required this.onPressed,
    this.errorMessage,
  });

  /// The error message that is displayed above the button.
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
                  : Text(errorMessage!, textAlign: TextAlign.center),
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
