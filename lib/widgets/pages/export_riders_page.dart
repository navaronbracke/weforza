import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/subjects.dart';
import 'package:weforza/exceptions/exceptions.dart';
import 'package:weforza/file/file_handler.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/riverpod/member/export_members_provider.dart';
import 'package:weforza/widgets/common/file_extension_selection.dart';
import 'package:weforza/widgets/common/filename_input_field.dart';
import 'package:weforza/widgets/common/generic_error.dart';
import 'package:weforza/widgets/custom/animated_checkmark.dart';
import 'package:weforza/widgets/platform/platform_aware_loading_indicator.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

class ExportRidersPage extends ConsumerStatefulWidget {
  const ExportRidersPage({super.key});

  @override
  ConsumerState<ExportRidersPage> createState() => _ExportRidersPageState();
}

class _ExportRidersPageState extends ConsumerState<ExportRidersPage> {
  late final ExportMembersProvider exportProvider;

  final GlobalKey<FormState> _formKey = GlobalKey();
  final _filenameController = TextEditingController();
  final _fileExtensionController = BehaviorSubject.seeded(FileExtension.csv);

  Future<void>? _exportFuture;

  final _filenameErrorController = BehaviorSubject.seeded('');

  void onSelectFileExtension(FileExtension? value) {
    if (value != null && _fileExtensionController.value != value) {
      _filenameErrorController.add('');
      _fileExtensionController.add(value);
    }
  }

  Future<void> _submitForm(S translator) {
    try {
      return exportProvider.exportMembers(
        csvHeader: translator.ExportRidersCsvHeader,
        fileExtension: _fileExtensionController.value.ext,
        fileName: _filenameController.text,
      );
    } catch (error) {
      // Forward the file exists exception to the validation label.
      if (error is FileExistsException && !_filenameErrorController.isClosed) {
        _filenameErrorController.add(translator.FileExists);
      }

      return Future.error(error);
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
        title: Text(S.of(context).ExportRiders),
      ),
      body: Center(child: _buildBody(context)),
    );
  }

  Widget _buildIosLayout(BuildContext context) {
    return CupertinoPageScaffold(
      resizeToAvoidBottomInset: false,
      navigationBar: CupertinoNavigationBar(
        middle: Text(S.of(context).ExportRiders),
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
                Text(translator.ExportingRiders),
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

            return const AdaptiveAnimatedCheckmark();
        }
      },
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
            FileNameInputField(
              controller: _filenameController,
              errorController: _filenameErrorController,
              padding: const EdgeInsets.only(bottom: 8),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: FileExtensionSelection(
                onExtensionSelected: onSelectFileExtension,
                initialValue: _fileExtensionController.value,
                stream: _fileExtensionController,
              ),
            ),
            PlatformAwareWidget(
              android: (_) => ElevatedButton(
                child: Text(translator.Export),
                onPressed: () {
                  final formState = _formKey.currentState;

                  if (formState != null && formState.validate()) {
                    _exportFuture = _submitForm(translator);

                    setState(() {});
                  }
                },
              ),
              ios: (_) => CupertinoButton.filled(
                child: Text(translator.Export),
                onPressed: () {
                  if (_filenameErrorController.value.isEmpty) {
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
      android: _buildAndroidLayout,
      ios: _buildIosLayout,
    );
  }

  @override
  void dispose() {
    _filenameController.dispose();
    _filenameErrorController.close();
    _fileExtensionController.close();
    super.dispose();
  }
}