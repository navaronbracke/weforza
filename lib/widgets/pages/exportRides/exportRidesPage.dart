import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/blocs/export_rides_bloc.dart';
import 'package:weforza/file/file_handler.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/injection/injectionContainer.dart';
import 'package:weforza/model/export_data_or_error.dart';
import 'package:weforza/repository/export_rides_repository.dart';
import 'package:weforza/theme/app_theme.dart';
import 'package:weforza/widgets/common/fileExtensionSelection.dart';
import 'package:weforza/widgets/common/genericError.dart';
import 'package:weforza/widgets/custom/animatedCheckmark/animatedCheckmark.dart';
import 'package:weforza/widgets/platform/cupertinoFormErrorFormatter.dart';
import 'package:weforza/widgets/platform/platformAwareLoadingIndicator.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

class ExportRidesPage extends StatefulWidget {
  const ExportRidesPage({Key? key}) : super(key: key);

  @override
  _ExportRidesPageState createState() => _ExportRidesPageState(
          bloc: ExportRidesBloc(
        repository: InjectionContainer.get<ExportRidesRepository>(),
        fileHandler: InjectionContainer.get<IFileHandler>(),
      ));
}

class _ExportRidesPageState extends State<ExportRidesPage> {
  _ExportRidesPageState({required this.bloc});

  final ExportRidesBloc bloc;
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  Widget build(BuildContext context) => PlatformAwareWidget(
        android: () => _buildAndroidLayout(context),
        ios: () => _buildIosLayout(context),
      );

  Widget _buildAndroidLayout(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(S.of(context).ExportRidesTitle),
      ),
      body: Center(child: _buildBody(context)),
    );
  }

  Widget _buildIosLayout(BuildContext context) {
    return CupertinoPageScaffold(
      resizeToAvoidBottomInset: false,
      navigationBar: CupertinoNavigationBar(
        middle: Text(S.of(context).ExportRidesTitle),
        transitionBetweenRoutes: false,
      ),
      child: Center(child: _buildBody(context)),
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<ExportDataOrError>(
      stream: bloc.stream,
      initialData: ExportDataOrError.idle(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return GenericError(text: S.of(context).GenericError);
        } else {
          if (snapshot.data!.exporting) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 5),
                  child: PlatformAwareLoadingIndicator(),
                ),
                Text(S.of(context).ExportingRidesDescription),
              ],
            );
          } else if (snapshot.data!.success) {
            return LayoutBuilder(
              builder: (context, constraints) {
                final paintSize = constraints.biggest.shortestSide * .3;
                return Center(
                    child: SizedBox(
                  width: paintSize,
                  height: paintSize,
                  child: Center(
                    child: AnimatedCheckmark(
                      color: ApplicationTheme.secondaryColor,
                      size: Size.square(paintSize),
                    ),
                  ),
                ));
              },
            );
          } else {
            return Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _buildFilenameField(context),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: FileExtensionSelection(
                        onExtensionSelected: (ext) =>
                            bloc.onSelectFileExtension(ext),
                        initialValue: FileExtension.csv,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: StreamBuilder<bool>(
                        initialData: false,
                        stream: bloc.fileNameExistsStream,
                        builder: (context, snapshot) {
                          return Text(
                              snapshot.data! ? S.of(context).FileExists : '');
                        },
                      ),
                    ),
                    PlatformAwareWidget(
                      android: () => ElevatedButton(
                        child: Text(S.of(context).Export),
                        onPressed: () async {
                          final formState = _formKey.currentState;

                          if (formState != null && formState.validate()) {
                            await bloc.exportRidesWithAttendees();
                          }
                        },
                      ),
                      ios: () => CupertinoButton.filled(
                        child: Text(
                          S.of(context).Export,
                          style: const TextStyle(color: Colors.white),
                        ),
                        onPressed: () async {
                          if (_iosValidateFilename(context)) {
                            await bloc.exportRidesWithAttendees();
                          } else {
                            setState(() {});
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        }
      },
    );
  }

  Widget _buildFilenameField(BuildContext context) {
    return PlatformAwareWidget(
      android: () => TextFormField(
        textInputAction: TextInputAction.done,
        keyboardType: TextInputType.text,
        autocorrect: false,
        controller: bloc.fileNameController,
        validator: (value) => bloc.validateFileName(
            value,
            S.of(context).ValueIsRequired(S.of(context).Filename),
            S.of(context).FilenameWhitespace,
            S.of(context).FilenameMaxLength('${bloc.filenameMaxLength}'),
            S.of(context).InvalidFilename),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 5),
          labelText: S.of(context).Filename,
          helperText: ' ',
        ),
        autovalidateMode: AutovalidateMode.onUserInteraction,
      ),
      ios: () => Column(
        children: [
          CupertinoTextField(
            textInputAction: TextInputAction.done,
            keyboardType: TextInputType.text,
            placeholder: S.of(context).Filename,
            autocorrect: false,
            controller: bloc.fileNameController,
            onChanged: (value) {
              setState(() {
                bloc.validateFileName(
                  value,
                  S.of(context).ValueIsRequired(S.of(context).Filename),
                  S.of(context).FilenameWhitespace,
                  S.of(context).FilenameMaxLength('${bloc.filenameMaxLength}'),
                  S.of(context).InvalidFilename,
                );
              });
            },
          ),
          Row(
            children: [
              Text(
                  CupertinoFormErrorFormatter.formatErrorMessage(
                      bloc.filenameError),
                  style: ApplicationTheme.iosFormErrorStyle),
            ],
          ),
        ],
      ),
    );
  }

  bool _iosValidateFilename(BuildContext context) {
    return bloc.validateFileName(
            bloc.fileNameController.text,
            S.of(context).ValueIsRequired(S.of(context).Filename),
            S.of(context).FilenameWhitespace,
            S.of(context).FilenameMaxLength('${bloc.filenameMaxLength}'),
            S.of(context).InvalidFilename) ==
        null;
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }
}
