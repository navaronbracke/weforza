import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:weforza/blocs/exportRidesBloc.dart';
import 'package:weforza/file/fileHandler.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/injection/injector.dart';
import 'package:weforza/model/rideExportState.dart';
import 'package:weforza/repository/exportRidesRepository.dart';
import 'package:weforza/theme/appTheme.dart';
import 'package:weforza/widgets/common/fileExtensionSelection.dart';
import 'package:weforza/widgets/common/genericError.dart';
import 'package:weforza/widgets/custom/animatedCheckmark/animatedCheckmark.dart';
import 'package:weforza/widgets/platform/cupertinoFormErrorFormatter.dart';
import 'package:weforza/widgets/platform/platformAwareLoadingIndicator.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

class ExportRidesPage extends StatefulWidget {

  @override
  _ExportRidesPageState createState() => _ExportRidesPageState(
    bloc: ExportRidesBloc(
      repository: InjectionContainer.get<ExportRidesRepository>(),
      fileHandler: InjectionContainer.get<IFileHandler>(),
    )
  );
}

class _ExportRidesPageState extends State<ExportRidesPage> {
  _ExportRidesPageState({ @required this.bloc }): assert(bloc != null);

  final ExportRidesBloc bloc;
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  Widget build(BuildContext context) => PlatformAwareWidget(
    android: () => _buildAndroidLayout(context),
    ios: () => _buildIosLayout(context),
  );

  Widget _buildAndroidLayout(BuildContext context){
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(S.of(context).ExportRidesTitle),
      ),
      body: Center(child: _buildBody(context)),
    );
  }

  Widget _buildIosLayout(BuildContext context){
    return CupertinoPageScaffold(
      resizeToAvoidBottomInset: false,
      navigationBar: CupertinoNavigationBar(
        middle: Text(S.of(context).ExportRidesTitle),
        transitionBetweenRoutes: false,
      ),
      child: Center(child: _buildBody(context)),
    );
  }

  Widget _buildBody(BuildContext context){
    return StreamBuilder<RideExportState>(
      stream: bloc.submitStream,
      initialData: RideExportState.IDLE,
      builder: (context, snapshot){
        if(snapshot.hasError){
          return GenericError(text: S.of(context).GenericError);
        }else {
          switch(snapshot.data){
            case RideExportState.IDLE: return Form(
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
                        onExtensionSelected: (ext) => bloc.onSelectFileExtension(ext),
                        initialValue: FileExtension.CSV,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: StreamBuilder<bool>(
                        initialData: false,
                        stream: bloc.fileExistsStream,
                        builder: (context, snapshot){
                          return Text(snapshot.data ? S.of(context).FileExists : "");
                        },
                      ),
                    ),
                    PlatformAwareWidget(
                      android: () => RaisedButton(
                        textColor: Colors.white,
                        color: ApplicationTheme.primaryColor,
                        child: Text(S.of(context).Export),
                        onPressed: () async {
                          if(_formKey.currentState.validate()){
                            await bloc.exportRidesWithAttendees();
                          }
                        },
                      ),
                      ios: () => CupertinoButton(
                        child: Text(S.of(context).Export),
                        onPressed: () async {
                          if (_iosValidateFilename(context)) {
                            await bloc.exportRidesWithAttendees();
                          }else {
                            setState(() {});
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
            case RideExportState.EXPORTING: return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: PlatformAwareLoadingIndicator(),
                ),
                Text(S.of(context).ExportingRidesDescription),
              ],
            );
            case RideExportState.DONE: return LayoutBuilder(
              builder: (context,constraints){
                final paintSize = constraints.biggest.shortestSide * .3;
                return Center(
                    child: SizedBox(
                      width: paintSize,
                      height: paintSize,
                      child: Center(
                        child: AnimatedCheckmark(
                          color: ApplicationTheme.accentColor,
                          size: Size.square(paintSize),
                        ),
                      ),
                    )
                );
              },
            );
            default: return GenericError(text: S.of(context).GenericError);
          }
        }
      },
    );
  }

  Widget _buildFilenameField(BuildContext context){
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
            S.of(context).FilenameMaxLength("${bloc.filenameMaxLength}"),
            S.of(context).InvalidFilename
        ),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 5),
          labelText: S.of(context).Filename,
          helperText: " ",
        ),
        autovalidate: bloc.autoValidateFileName,
        onChanged: (value) => setState((){
          bloc.autoValidateFileName = true;
        }),
      ), ios: () => Column(
            children: [
              CupertinoTextField(
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.text,
                placeholder: S.of(context).Filename,
                autocorrect: false,
                controller: bloc.fileNameController,
                onChanged: (value){
                  setState(() {
                    bloc.validateFileName(
                      value,
                      S.of(context).ValueIsRequired(S.of(context).Filename),
                      S.of(context).FilenameWhitespace,
                      S.of(context).FilenameMaxLength("${bloc.filenameMaxLength}"),
                      S.of(context).InvalidFilename,
                    );
                  });
                },
              ),
              Row(
                children: [
                  Text(
                    CupertinoFormErrorFormatter.formatErrorMessage(bloc.filenameError),
                    style: ApplicationTheme.iosFormErrorStyle
                  ),
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
        S.of(context).FilenameMaxLength("${bloc.filenameMaxLength}"),
        S.of(context).InvalidFilename
    ) == null;
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }
}