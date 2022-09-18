import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weforza/exceptions/exceptions.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/model/import_members_state.dart';
import 'package:weforza/riverpod/member/import_members_provider.dart';
import 'package:weforza/theme/app_theme.dart';
import 'package:weforza/widgets/common/generic_error.dart';
import 'package:weforza/widgets/custom/animated_checkmark.dart';
import 'package:weforza/widgets/platform/platform_aware_loading_indicator.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';
import 'package:weforza/widgets/theme.dart';

class ImportMembersPage extends ConsumerStatefulWidget {
  const ImportMembersPage({super.key});

  @override
  ImportMembersPageState createState() => ImportMembersPageState();
}

class ImportMembersPageState extends ConsumerState<ImportMembersPage> {
  final _importController = BehaviorSubject.seeded(ImportMembersState.idle);

  late final ImportMembersNotifier notifier;

  Widget _buildAndroidWidget(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).ImportMembersPageTitle),
      ),
      body: Center(child: _buildBody(context)),
    );
  }

  Widget _buildErrorMessage(String errorMessage) {
    return PlatformAwareWidget(
      android: () => Text(
        errorMessage,
        softWrap: true,
        style: AppTheme.desctructiveAction.androidErrorStyle,
      ),
      ios: () => Text(
        errorMessage,
        softWrap: true,
        style: const TextStyle(
          color: CupertinoColors.destructiveRed,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildIosWidget(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(S.of(context).ImportMembersPageTitle),
      ),
      child: Center(child: _buildBody(context)),
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<ImportMembersState>(
      initialData: _importController.value,
      stream: _importController,
      builder: (context, snapshot) {
        final translator = S.of(context);

        final error = snapshot.error;

        final button = _ImportMembersButton(
          text: translator.ImportMembersPickFile,
          onTap: () => notifier.importMembers(
            translator.ImportMembersCsvHeaderRegex,
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
          ),
        );

        if (error is NoFileChosenError) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildErrorMessage(translator.ImportMembersPickFileWarning),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: button,
              ),
            ],
          );
        }

        if (error is InvalidFileExtensionError) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildErrorMessage(translator.ImportMembersInvalidFileExtension),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: button,
              ),
            ],
          );
        }

        if (error is CsvHeaderMissingError) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildErrorMessage(translator.ImportMembersCsvHeaderRequired),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: button,
              ),
            ],
          );
        }

        if (error is JsonFormatIncompatibleException) {
          return GenericError(
            androidIcon: Icons.insert_drive_file,
            iosIcon: CupertinoIcons.doc_fill,
            text: translator.ImportMembersIncompatibleFileJsonContents,
          );
        }

        if (error != null) {
          return GenericError(text: translator.GenericError);
        }

        switch (snapshot.data!) {
          case ImportMembersState.idle:
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(''),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: button,
                ),
              ],
            );
          case ImportMembersState.pickingFile:
            return const Center(child: PlatformAwareLoadingIndicator());
          case ImportMembersState.importing:
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const PlatformAwareLoadingIndicator(),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    translator.ImportMembersImporting,
                    softWrap: true,
                  ),
                ),
              ],
            );
          case ImportMembersState.done:
            return Center(
              child: LayoutBuilder(
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
              ),
            );
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    notifier = ref.read(importMembersProvider);
  }

  @override
  Widget build(BuildContext context) {
    return PlatformAwareWidget(
      android: () => _buildAndroidWidget(context),
      ios: () => _buildIosWidget(context),
    );
  }

  @override
  void dispose() {
    _importController.close();
    super.dispose();
  }
}

class _ImportMembersButton extends StatelessWidget {
  const _ImportMembersButton({required this.text, required this.onTap});

  /// The text for the button.
  final String text;

  /// The onTap handler for the button.
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return PlatformAwareWidget(
      android: () => TextButton(onPressed: onTap, child: Text(text)),
      ios: () => CupertinoButton.filled(
        onPressed: onTap,
        child: Text(text, style: const TextStyle(color: Colors.white)),
      ),
    );
  }
}
