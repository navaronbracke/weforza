import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/exceptions/exceptions.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/widgets/common/generic_error.dart';
import 'package:weforza/widgets/custom/animated_checkmark.dart';
import 'package:weforza/widgets/platform/platform_aware_loading_indicator.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

/// This widget represents a page for exporting a piece of data.
class ExportDataPage extends StatelessWidget {
  ExportDataPage({
    required this.exportingLabel,
    required this.fileExistsLabel,
    required this.fileFormatSelection,
    required this.fileNameController,
    required this.fileNameFormFieldKey,
    required this.initialData,
    required this.onPressed,
    required this.stream,
    required this.title,
    super.key,
  }) : inputFormatters = [
          FilteringTextInputFormatter.allow(r'[\w-]'),
          LengthLimitingTextInputFormatter(maxLength),
        ];

  /// The maximum length for the file name input field.
  static const int maxLength = 80;

  /// The label that is used as description for the exporting indicator.
  final String exportingLabel;

  /// The label that displays error messages when a file already exists.
  ///
  /// Typically an [ExportFileNameExistsLabel].
  final Widget fileExistsLabel;

  /// The widget that represents the file format selection.
  final Widget fileFormatSelection;

  /// The controller for the file name input field.
  final TextEditingController fileNameController;

  /// The [Key] for the file name input field.
  final GlobalKey<FormFieldState<String>> fileNameFormFieldKey;

  /// The initial data that is used when [stream] has not yet delivered an event.
  final AsyncValue<void>? initialData;

  /// The input formatters for the file name input field.
  final List<TextInputFormatter> inputFormatters;

  /// The onPressed handler for the export button.
  final void Function() onPressed;

  /// The [Stream] that provides updates about the export state.
  final Stream<AsyncValue<void>?> stream;

  /// The title for the page.
  final String title;

  Widget _buildAndroidForm(BuildContext context) {
    final translator = S.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: TextFormField(
              autocorrect: false,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: fileNameController,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                labelText: translator.FileName,
              ),
              inputFormatters: inputFormatters,
              key: fileNameFormFieldKey,
              keyboardType: TextInputType.text,
              maxLength: maxLength,
              textInputAction: TextInputAction.done,
              validator: (fileName) {
                if (fileName == null || fileName.isEmpty) {
                  return translator.FileNameRequired;
                }

                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    translator.FileFormat,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ),
                fileFormatSelection,
              ],
            ),
          ),
          ElevatedButton(
            onPressed: onPressed,
            child: Text(translator.Export),
          ),
        ],
      ),
    );
  }

  /// Build the body of the export page.
  ///
  /// The [child] is the widget that is used as the file name input form.
  /// The [doneIndicator] is shown when the export has finished successfully.
  /// The [loadingIndicator] is shown when the export is ongoing.
  ///
  /// If the export failed and the error is an instance of [FileExistsException],
  /// then the [child] is displayed as is, since the [fileExistsLabel]
  /// handles those errors. The [genericErrorIndicator] is displayed for all other errors.
  Widget _buildBody({
    required Widget child,
    required Widget doneIndicator,
    required Widget genericErrorIndicator,
    required Widget loadingIndicator,
  }) {
    return StreamBuilder<AsyncValue<void>?>(
      initialData: initialData,
      stream: stream,
      builder: (context, snapshot) {
        final value = snapshot.data;

        if (value == null) {
          return child;
        }

        return value.when(
          data: (_) => doneIndicator,
          error: (error, stackTrace) {
            // If the export fails because a file with the given name already exists,
            // an error message is provided by the `fileExistsLabel` widget.
            if (error is FileExistsException) {
              return child;
            }

            return genericErrorIndicator;
          },
          loading: () => loadingIndicator,
        );
      },
    );
  }

  Widget _buildIosForm(BuildContext context) {
    final translator = S.of(context);

    return CupertinoFormSection.insetGrouped(
      children: [
        CupertinoTextFormFieldRow(
          autocorrect: false,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          controller: fileNameController,
          inputFormatters: inputFormatters,
          key: fileNameFormFieldKey,
          keyboardType: TextInputType.text,
          maxLength: maxLength,
          placeholder: translator.FileName,
          textInputAction: TextInputAction.done,
          validator: (fileName) {
            if (fileName == null || fileName.isEmpty) {
              return translator.FileNameRequired;
            }

            return null;
          },
        ),
        CupertinoFormRow(
          prefix: Text(translator.FileFormat),
          child: fileFormatSelection,
        ),
        CupertinoButton.filled(
          onPressed: onPressed,
          child: Text(translator.Export),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    const doneIndicator = Center(child: AdaptiveAnimatedCheckmark());
    const genericErrorIndicator = Center(child: GenericError());
    final loadingIndicator = Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 4),
            child: PlatformAwareLoadingIndicator(),
          ),
          Text(exportingLabel), // TODO: fix label style
        ],
      ),
    );

    return PlatformAwareWidget(
      android: (context) => Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(title: Text(title)),
        body: _buildBody(
          child: Center(child: _buildAndroidForm(context)),
          doneIndicator: doneIndicator,
          genericErrorIndicator: genericErrorIndicator,
          loadingIndicator: loadingIndicator,
        ),
      ),
      ios: (context) => CupertinoPageScaffold(
        resizeToAvoidBottomInset: false,
        navigationBar: CupertinoNavigationBar(
          backgroundColor: CupertinoColors.systemGroupedBackground,
          border: null,
          middle: Text(title),
          transitionBetweenRoutes: false,
        ),
        child: _buildBody(
          child: _buildIosForm(context),
          doneIndicator: doneIndicator,
          genericErrorIndicator: genericErrorIndicator,
          loadingIndicator: loadingIndicator,
        ),
      ),
    );
  }
}

/// This widget represents a validation label that displays a 'File exists'
/// message based on the state of its [stream].
class ExportFileNameExistsLabel extends StatelessWidget {
  const ExportFileNameExistsLabel({
    required this.initialData,
    required this.stream,
    this.style,
    super.key,
  });

  final bool initialData;

  final Stream<bool> stream;

  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      initialData: initialData,
      stream: stream,
      builder: (context, snapshot) {
        final exists = snapshot.data ?? false;

        return Text(exists ? S.of(context).FileNameExists : '', style: style);
      },
    );
  }
}
