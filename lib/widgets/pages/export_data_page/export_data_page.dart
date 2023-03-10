import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/model/export/export_delegate.dart';
import 'package:weforza/widgets/common/export_file_format_selection.dart';
import 'package:weforza/widgets/common/focus_absorber.dart';
import 'package:weforza/widgets/common/form_submit_button.dart';
import 'package:weforza/widgets/common/generic_error.dart';
import 'package:weforza/widgets/custom/animated_circle_checkmark.dart';
import 'package:weforza/widgets/custom/directory_selection_form_field.dart';
import 'package:weforza/widgets/pages/export_data_page/export_data_file_name_text_field.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

/// This widget represents a page for exporting a piece of data.
class ExportDataPage<T> extends StatelessWidget {
  const ExportDataPage({
    required this.checkmarkAnimationController,
    required this.delegate,
    required this.options,
    required this.title,
    super.key,
  });

  /// The animation controller for the 'Done' checkmark widget.
  final AnimationController checkmarkAnimationController;

  /// The delegate that handles the export.
  final ExportDelegate<T> delegate;

  /// The options for the export handler.
  final T options;

  /// The title for the page.
  final String title;

  String? _validateDirectory(Directory? directory, S translator) {
    if (directory == null) {
      return translator.directoryRequired;
    }

    if (!directory.existsSync()) {
      return translator.directoryDoesNotExist;
    }

    if (Platform.isAndroid && directory.path == Platform.pathSeparator) {
      return translator.directoryIsProtected;
    }

    return null;
  }

  Widget _buildAndroidForm(BuildContext context, {required Widget child}) {
    final translator = S.of(context);

    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 24),
      child: Column(
        children: [
          ExportDataFileNameTextField<T>(delegate: delegate),
          Padding(
            padding: const EdgeInsets.only(top: 32, bottom: 48),
            child: DirectorySelectionFormField(
              controller: delegate.directoryController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (directory) => _validateDirectory(directory, translator),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 40),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Text(translator.fileFormat, maxLines: 2),
                  ),
                ),
                ExportFileFormatSelection(
                  initialValue: delegate.currentFileFormat,
                  onFormatSelected: delegate.setFileFormat,
                  stream: delegate.fileFormatStream,
                ),
              ],
            ),
          ),
          child,
        ],
      ),
    );
  }

  /// Build the body of the export page.
  ///
  /// The [builder] function is used to build the form when the export has not started yet.
  /// If the export failed because of an error, the [genericErrorIndicator] is displayed.
  ///
  /// The [doneIndicator] is shown when the export has finished successfully.
  Widget _buildBody({
    required Widget Function(BuildContext context, {bool isExporting}) builder,
    required Widget doneIndicator,
    required Widget genericErrorIndicator,
  }) {
    return Form(
      child: StreamBuilder<AsyncValue<void>?>(
        initialData: delegate.currentState,
        stream: delegate.stream,
        builder: (context, snapshot) {
          final value = snapshot.data;

          if (value == null) {
            return FocusAbsorber(child: builder(context, isExporting: false));
          }

          return value.when(
            data: (_) => doneIndicator,
            error: (error, stackTrace) => genericErrorIndicator,
            loading: () => FocusAbsorber(child: builder(context, isExporting: true)),
          );
        },
      ),
    );
  }

  Widget _buildIosForm(BuildContext context, {required Widget child}) {
    final translator = S.of(context);

    return CupertinoFormSection.insetGrouped(
      children: [
        ExportDataFileNameTextField<T>(delegate: delegate),
        DirectorySelectionFormField(
          controller: delegate.directoryController,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (directory) => _validateDirectory(directory, translator),
        ),
        CupertinoFormRow(
          padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 6, 20),
          prefix: Flexible(child: Text(translator.fileFormat, maxLines: 2)),
          child: ExportFileFormatSelection(
            initialValue: delegate.currentFileFormat,
            onFormatSelected: delegate.setFileFormat,
            stream: delegate.fileFormatStream,
          ),
        ),
        child,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final doneIndicator = AnimatedCircleCheckmark(
      controller: checkmarkAnimationController,
    );
    final translator = S.of(context);
    final label = translator.export;
    final genericErrorIndicator = Center(
      child: GenericErrorWithBackButton(
        message: translator.exportGenericErrorMessage,
      ),
    );

    return PlatformAwareWidget(
      android: (context) => Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(title: Text(title)),
        body: _buildBody(
          builder: (context, {bool isExporting = false}) => _buildAndroidForm(
            context,
            child: isExporting
                ? const FixedHeightSubmitButton.loading()
                : FixedHeightSubmitButton(label: label, onPressed: () => delegate.exportDataToFile(context, options)),
          ),
          doneIndicator: doneIndicator,
          genericErrorIndicator: genericErrorIndicator,
        ),
      ),
      ios: (context) {
        final backgroundColor = CupertinoDynamicColor.resolve(
          CupertinoColors.systemGroupedBackground,
          context,
        );

        return CupertinoPageScaffold(
          backgroundColor: backgroundColor,
          resizeToAvoidBottomInset: false,
          navigationBar: CupertinoNavigationBar(
            backgroundColor: backgroundColor,
            border: null,
            middle: Text(title),
            transitionBetweenRoutes: false,
          ),
          child: _buildBody(
            builder: (context, {bool isExporting = false}) => _buildIosForm(
              context,
              child: isExporting
                  ? const FixedHeightSubmitButton.loading()
                  : FixedHeightSubmitButton(label: label, onPressed: () => delegate.exportDataToFile(context, options)),
            ),
            doneIndicator: doneIndicator,
            genericErrorIndicator: genericErrorIndicator,
          ),
        );
      },
    );
  }
}
