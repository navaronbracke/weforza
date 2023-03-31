import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/subjects.dart';
import 'package:weforza/exceptions/exceptions.dart';
import 'package:weforza/file/file_handler.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/riverpod/member/export_members_provider.dart';
import 'package:weforza/theme/app_theme.dart';
import 'package:weforza/widgets/common/file_extension_selection.dart';
import 'package:weforza/widgets/common/generic_error.dart';
import 'package:weforza/widgets/common/validation_label.dart';
import 'package:weforza/widgets/custom/animated_checkmark.dart';
import 'package:weforza/widgets/platform/platform_aware_loading_indicator.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

class ExportMembersPage extends ConsumerStatefulWidget {
  const ExportMembersPage({Key? key}) : super(key: key);

  @override
  _ExportMembersPageState createState() => _ExportMembersPageState();
}

class _ExportMembersPageState extends ConsumerState<ExportMembersPage> {
  late final ExportMembersProvider exportProvider;

  final RegExp filenamePattern = RegExp(r'^[\w\s-]{1,80}$');

  final int filenameMaxLength = 80;

  final GlobalKey<FormState> _formKey = GlobalKey();
  final _filenameController = TextEditingController();

  Future<void>? _exportFuture;
  FileExtension _fileExtension = FileExtension.csv;

  final _filenameErrorController = BehaviorSubject.seeded('');

  String? validateFileName(
    String? filename, {
    required String fileNameIsRequired,
    required String isWhitespaceMessage,
    required String filenameNameMaxLengthMessage,
    required String invalidFilenameMessage,
  }) {
    if (filename == null || filename.isEmpty) {
      return fileNameIsRequired;
    }
    if (filename.trim().isEmpty) {
      return isWhitespaceMessage;
    }
    if (filenameMaxLength < filename.length) {
      return filenameNameMaxLengthMessage;
    }
    if (!filenamePattern.hasMatch(filename)) {
      return invalidFilenameMessage;
    }

    return null;
  }

  bool _iosValidateFilename(S translator) {
    final error = validateFileName(
      _filenameController.text,
      fileNameIsRequired: translator.FilenameRequired,
      isWhitespaceMessage: translator.FilenameWhitespace,
      filenameNameMaxLengthMessage: translator.FilenameMaxLength(
        filenameMaxLength,
      ),
      invalidFilenameMessage: translator.InvalidFilename,
    );

    return error == null;
  }

  void onSelectFileExtension(FileExtension extension) {
    if (_fileExtension != extension) {
      _filenameErrorController.add('');
      _fileExtension = extension;
    }
  }

  Future<void> _submitForm(S translator) async {
    try {
      return exportProvider.exportMembers(
        csvHeader: translator.ExportMembersCsvHeader,
        fileExtension: _fileExtension.extension(),
        fileName: _filenameController.text,
      );
    } catch (error) {
      // Forward the file exists exception to the validation label.
      if (error is FileExistsException && !_filenameErrorController.isClosed) {
        _filenameErrorController.add(translator.FileExists);
      }

      rethrow;
    }
  }

  @override
  void initState() {
    super.initState();
    exportProvider = ref.read(exportMembersProvider);
  }

  Widget _buildAndroidLayout(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(S.of(context).ExportMembersTitle),
      ),
      body: Center(child: _buildBody(context)),
    );
  }

  Widget _buildIosLayout(BuildContext context) {
    return CupertinoPageScaffold(
      resizeToAvoidBottomInset: false,
      navigationBar: CupertinoNavigationBar(
        middle: Text(S.of(context).ExportMembersTitle),
        transitionBetweenRoutes: false,
      ),
      child: Center(child: _buildBody(context)),
    );
  }

  Widget _buildBody(BuildContext context) {
    return FutureBuilder<void>(
      future: _exportFuture,
      builder: (context, snapshot) {
        final translator = S.of(context);

        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return _buildForm(translator);
          case ConnectionState.waiting:
          case ConnectionState.active:
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: PlatformAwareLoadingIndicator(),
                ),
                Text(translator.ExportingMembersDescription),
              ],
            );
          case ConnectionState.done:
            final error = snapshot.error;

            if (error is FileExistsException) {
              return _buildForm(translator);
            }

            if (error != null) {
              return GenericError(text: translator.GenericError);
            }

            return LayoutBuilder(
              builder: (context, constraints) {
                final paintSize = constraints.biggest.shortestSide * .3;
                return Center(
                  child: SizedBox.square(
                    dimension: paintSize,
                    child: Center(
                      child: AnimatedCheckmark(
                        color: ApplicationTheme.secondaryColor,
                        size: Size.square(paintSize),
                      ),
                    ),
                  ),
                );
              },
            );
        }
      },
    );
  }

  Widget _buildFilenameInputField(S translator) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          PlatformAwareWidget(
            android: () => TextFormField(
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.text,
              autocorrect: false,
              controller: _filenameController,
              validator: (value) {
                // Clear the file exists message.
                _filenameErrorController.add('');

                return validateFileName(
                  value,
                  fileNameIsRequired: translator.FilenameRequired,
                  isWhitespaceMessage: translator.FilenameWhitespace,
                  filenameNameMaxLengthMessage: translator.FilenameMaxLength(
                    filenameMaxLength,
                  ),
                  invalidFilenameMessage: translator.InvalidFilename,
                );
              },
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                labelText: translator.Filename,
                helperText: ' ',
              ),
              autovalidateMode: AutovalidateMode.onUserInteraction,
            ),
            ios: () => CupertinoTextField(
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.text,
              placeholder: translator.Filename,
              autocorrect: false,
              controller: _filenameController,
              onChanged: (value) {
                final validationError = validateFileName(
                  value,
                  fileNameIsRequired: translator.FilenameRequired,
                  isWhitespaceMessage: translator.FilenameWhitespace,
                  filenameNameMaxLengthMessage: translator.FilenameMaxLength(
                    filenameMaxLength,
                  ),
                  invalidFilenameMessage: translator.InvalidFilename,
                );

                _filenameErrorController.add(validationError ?? '');
              },
            ),
          ),
          PlatformAwareWidget(
            android: () => ValidationLabel(
              stream: _filenameErrorController,
              style: ApplicationTheme.androidFormErrorStyle,
            ),
            ios: () => ValidationLabel(
              stream: _filenameErrorController,
              style: ApplicationTheme.iosFormErrorStyle,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForm(S translator) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _buildFilenameInputField(translator),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: FileExtensionSelection(
                onExtensionSelected: onSelectFileExtension,
                initialValue: FileExtension.csv,
              ),
            ),
            PlatformAwareWidget(
              android: () => ElevatedButton(
                child: Text(translator.Export),
                onPressed: () {
                  final formState = _formKey.currentState;

                  if (formState != null && formState.validate()) {
                    _exportFuture = _submitForm(translator);

                    setState(() {});
                  }
                },
              ),
              ios: () => CupertinoButton.filled(
                child: Text(
                  translator.Export,
                  style: const TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  if (_iosValidateFilename(translator)) {
                    _exportFuture = _submitForm(translator);
                  }

                  setState(() {});
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlatformAwareWidget(
      android: () => _buildAndroidLayout(context),
      ios: () => _buildIosLayout(context),
    );
  }

  @override
  void dispose() {
    _filenameController.dispose();
    _filenameErrorController.close();
    super.dispose();
  }
}
