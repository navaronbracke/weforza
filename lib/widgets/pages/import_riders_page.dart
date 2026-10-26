import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/exceptions/exceptions.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/model/import/import_riders_delegate.dart';
import 'package:weforza/model/import/import_riders_state.dart';
import 'package:weforza/riverpod/file/import_file_delegate_provider.dart';
import 'package:weforza/riverpod/repository/serialize_riders_repository_provider.dart';
import 'package:weforza/riverpod/rider/rider_list_provider.dart';
import 'package:weforza/widgets/common/generic_error.dart';
import 'package:weforza/widgets/common/progress_indicator_with_label.dart';
import 'package:weforza/widgets/custom/animated_circle_checkmark.dart';
import 'package:weforza/widgets/platform/platform_aware_loading_indicator.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

class ImportRidersPage extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<ImportRidersPage> createState() => _ImportRidersPageState();
}

class _ImportRidersPageState extends ConsumerState<ImportRidersPage> with SingleTickerProviderStateMixin {
  late final ImportRidersDelegate delegate;

  late final AnimationController checkmarkController;

  void _onImportRidersPressed() {
    delegate.importRiders(
      whenComplete: () {
        if (mounted) {
          ref.invalidate(riderListProvider);
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    delegate = ImportRidersDelegate(ref.read(importFileDelegateProvider), ref.read(serializeRidersRepositoryProvider));

    checkmarkController = AnimationController(
      vsync: this,
      duration: AnimatedCircleCheckmark.kCheckmarkAnimationDuration,
    );
  }

  Widget _buildBody() {
    return Center(
      child: ValueListenableBuilder<AsyncValue<ImportRidersState>>(
        valueListenable: delegate.listenable,
        builder: (context, value, _) {
          final translator = S.of(context);
          final buttonLabel = translator.pickFile;

          if (value case AsyncError(:final error)) {
            if (error is UnsupportedFileFormatException) {
              return _ImportRidersButton(
                errorMessage: translator.onlyCsvOrJsonAllowed,
                label: buttonLabel,
                onPressed: _onImportRidersPressed,
              );
            }

            if (error is FileRequiredException) {
              return _ImportRidersButton(
                errorMessage: translator.importRidersFileRequired,
                label: buttonLabel,
                onPressed: _onImportRidersPressed,
              );
            }

            if (error is FormatException) {
              return _ImportRidersButton(
                errorMessage: translator.fileMalformed,
                label: buttonLabel,
                onPressed: _onImportRidersPressed,
              );
            }

            return Center(child: GenericErrorWithBackButton(message: translator.importRidersGenericErrorMessage));
          }

          if (value case AsyncData(:final value)) {
            return switch (value) {
              .done => AnimatedCircleCheckmark(controller: checkmarkController),
              .idle => _ImportRidersButton(label: buttonLabel, onPressed: _onImportRidersPressed),
              .importing => ProgressIndicatorWithLabel(label: translator.importRidersProcessingFile),
              .pickingFile => const PlatformAwareLoadingIndicator(),
            };
          }

          return Center(child: GenericErrorWithBackButton(message: translator.importRidersGenericErrorMessage));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Widget body = _buildBody();
    final Widget title = Text(S.of(context).importRiders);

    return PlatformAwareWidget(
      android: (context) => Scaffold(
        appBar: AppBar(title: title),
        body: body,
      ),
      ios: (context) => CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(middle: title, transitionBetweenRoutes: false),
        child: body,
      ),
    );
  }

  @override
  void dispose() {
    delegate.dispose();
    checkmarkController.dispose();
    super.dispose();
  }
}

class _ImportRidersButton extends StatelessWidget {
  const new({required this.label, required this.onPressed, this.errorMessage});

  /// The error message that is displayed below the button.
  final String? errorMessage;

  /// The text for the button.
  final String label;

  /// The onTap handler for the button.
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return PlatformAwareWidget(
      android: (context) => Column(
        mainAxisAlignment: .center,
        mainAxisSize: .min,
        children: [
          Padding(
            padding: const .only(bottom: 8),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.insert_drive_file_outlined),
              onPressed: onPressed,
              label: Text(label),
            ),
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                errorMessage ?? '',
                style: TextTheme.of(context).labelMedium!.copyWith(color: ColorScheme.of(context).error),
              ),
            ),
          ),
        ],
      ),
      ios: (_) {
        final Widget button = CupertinoButton.filled(
          onPressed: onPressed,
          child: Row(
            mainAxisSize: .min,
            children: [
              const Padding(
                padding: .only(right: 8),
                child: Icon(CupertinoIcons.arrow_down_doc, color: CupertinoColors.white),
              ),
              Text(label, style: const TextStyle(color: CupertinoColors.white)),
            ],
          ),
        );

        return Column(
          mainAxisAlignment: .center,
          children: [
            CupertinoFormRow(
              padding: const .symmetric(horizontal: 20),
              error: switch (errorMessage) {
                null => null,
                final errorMessage => Center(
                  child: Padding(padding: const .only(top: 8), child: Text(errorMessage)),
                ),
              },
              child: Center(child: button),
            ),
          ],
        );
      },
    );
  }
}
