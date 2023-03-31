import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/exceptions/exceptions.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/model/export/export_delegate.dart';
import 'package:weforza/model/export/export_file_format.dart';
import 'package:weforza/widgets/common/export_file_format_selection.dart';
import 'package:weforza/widgets/common/focus_absorber.dart';
import 'package:weforza/widgets/common/form_submit_button.dart';
import 'package:weforza/widgets/common/generic_error.dart';
import 'package:weforza/widgets/custom/animated_circle_checkmark.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';
import 'package:weforza/widgets/theme.dart';

/// This widget represents a page for exporting a piece of data.
class ExportDataPage<T> extends StatelessWidget {
  ExportDataPage({
    required this.checkmarkAnimationController,
    required this.delegate,
    required this.onPressed,
    required this.title,
    super.key,
  }) : inputFormatters = [
          FilteringTextInputFormatter.allow(RegExp(r'[\w-\.]')),
          LengthLimitingTextInputFormatter(maxLength),
        ];

  /// The maximum length for the file name input field.
  static const int maxLength = 80;

  /// The animation controller for the 'Done' checkmark widget.
  final AnimationController checkmarkAnimationController;

  /// The delegate that handles the export.
  final ExportDelegate<T> delegate;

  /// The input formatters for the file name input field.
  final List<TextInputFormatter> inputFormatters;

  /// The onPressed handler for the export button.
  final void Function() onPressed;

  /// The title for the page.
  final String title;

  Widget _buildAndroidForm(BuildContext context, {required Widget child}) {
    final translator = S.of(context);

    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 24),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: TextFormField(
              autocorrect: false,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: delegate.fileNameController,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                labelText: translator.fileName,
                errorMaxLines: 3,
              ),
              inputFormatters: inputFormatters,
              key: delegate.fileNameKey,
              keyboardType: TextInputType.text,
              maxLength: maxLength,
              textInputAction: TextInputAction.done,
              validator: (fileName) => _validateFileName(fileName, translator),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 24, bottom: 40),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 6, right: 8),
                    child: Text(
                      translator.fileFormat,
                      style: Theme.of(context).textTheme.labelMedium,
                      maxLines: 2,
                    ),
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
          Theme(
            data: ThemeData(
              useMaterial3: true,
              colorScheme: AppTheme.colorScheme,
            ),
            child: child,
          ),
        ],
      ),
    );
  }

  /// Build the body of the export page.
  ///
  /// The [builder] function is used to build the form when the export has not started yet,
  /// or when the export failed with a [FileExistsException].
  /// If the export failed because of a different error,
  /// the [genericErrorIndicator] is displayed.
  ///
  /// The [doneIndicator] is shown when the export has finished successfully.
  Widget _buildBody({
    required Widget Function(BuildContext context, {bool isExporting}) builder,
    required Widget doneIndicator,
    required Widget genericErrorIndicator,
  }) {
    return StreamBuilder<AsyncValue<void>?>(
      initialData: delegate.currentState,
      stream: delegate.stream,
      builder: (context, snapshot) {
        final value = snapshot.data;

        if (value == null) {
          return FocusAbsorber(child: builder(context, isExporting: false));
        }

        return value.when(
          data: (_) => doneIndicator,
          error: (error, stackTrace) {
            if (error is FileExistsException) {
              return FocusAbsorber(child: builder(context, isExporting: false));
            }

            return genericErrorIndicator;
          },
          loading: () => FocusAbsorber(
            child: builder(context, isExporting: true),
          ),
        );
      },
    );
  }

  Widget _buildIosForm(BuildContext context, {required Widget child}) {
    final translator = S.of(context);

    return CupertinoFormSection.insetGrouped(
      children: [
        CupertinoTextFormFieldRow(
          autocorrect: false,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          controller: delegate.fileNameController,
          inputFormatters: inputFormatters,
          key: delegate.fileNameKey,
          keyboardType: TextInputType.text,
          maxLength: maxLength,
          placeholder: translator.fileName,
          textInputAction: TextInputAction.done,
          validator: (fileName) => _validateFileName(fileName, translator),
        ),
        CupertinoFormRow(
          padding: const EdgeInsetsDirectional.fromSTEB(20, 16, 6, 16),
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

  /// Validate the given [fileName].
  ///
  /// Returns an error message or null if the file name is valid.
  String? _validateFileName(String? fileName, S translator) {
    if (fileName == null || fileName.isEmpty) {
      return translator.fileNameRequired;
    }

    if (fileName.startsWith('.')) {
      return translator.fileNameCantStartWithDot;
    }

    final ExportFileFormat fileFormat = delegate.currentFileFormat;
    final String fileExtension = fileFormat.formatExtension;

    if (!fileName.endsWith(fileExtension)) {
      return translator.fileNameInvalidExtension(
        fileFormat.asUpperCase,
        fileExtension,
      );
    }

    if (delegate.fileExists(fileName)) {
      return translator.fileNameExists;
    }

    return null;
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
                : FixedHeightSubmitButton(label: label, onPressed: onPressed),
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
                  : FixedHeightSubmitButton(label: label, onPressed: onPressed),
            ),
            doneIndicator: doneIndicator,
            genericErrorIndicator: genericErrorIndicator,
          ),
        );
      },
    );
  }
}
