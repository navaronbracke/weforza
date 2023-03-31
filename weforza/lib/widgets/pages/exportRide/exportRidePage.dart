import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:weforza/blocs/exportRideBloc.dart';
import 'package:weforza/file/fileHandler.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/model/exportDataOrError.dart';
import 'package:weforza/theme/appTheme.dart';
import 'package:weforza/widgets/common/fileExtensionSelection.dart';
import 'package:weforza/widgets/common/genericError.dart';
import 'package:weforza/widgets/custom/animatedCheckmark/animatedCheckmark.dart';
import 'package:weforza/widgets/platform/cupertinoFormErrorFormatter.dart';
import 'package:weforza/widgets/platform/platformAwareLoadingIndicator.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

class ExportRidePage extends StatefulWidget {
  ExportRidePage({
    @required this.bloc
  }): assert(bloc != null);

  final ExportRideBloc bloc;

  @override
  _ExportRidePageState createState() => _ExportRidePageState();
}

class _ExportRidePageState extends State<ExportRidePage> {

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
        title: Text(S.of(context).ExportRideTitle),
      ),
      body: Center(child: _buildBody(context)),
    );
  }

  Widget _buildIosLayout(BuildContext context){
    return CupertinoPageScaffold(
      resizeToAvoidBottomInset: false,
      navigationBar: CupertinoNavigationBar(
        middle: Text(S.of(context).ExportRideTitle),
        transitionBetweenRoutes: false,
      ),
      child: Center(child: _buildBody(context)),
    );
  }

  Widget _buildBody(BuildContext context){
    return StreamBuilder<ExportDataOrError>(
      initialData: ExportDataOrError.idle(),
      stream: widget.bloc.stream,
      builder: (context, snapshot){
        if(snapshot.hasError){
          return GenericError(text: S.of(context).GenericError);
        }else{
          if(snapshot.data.exporting){
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PlatformAwareLoadingIndicator(),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(S.of(context).ExportRideExportingToFile),
                ),
              ],
            );
          }else if(snapshot.data.success){
            return LayoutBuilder(
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
          }else{
            return Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _buildFilenameInputField(context),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: FileExtensionSelection(
                      onExtensionSelected: (ext) => widget.bloc.onSelectFileExtension(ext),
                      initialValue: FileExtension.CSV,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: StreamBuilder<bool>(
                      initialData: false,
                      stream: widget.bloc.fileNameExistsStream,
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
                      onPressed: (){
                        if(_formKey.currentState.validate()){
                          widget.bloc.exportRide();
                        }
                      },
                    ),
                    ios: () => CupertinoButton(
                      child: Text(S.of(context).Export),
                      onPressed: (){
                        if (_iosValidateFilename(context)) {
                          widget.bloc.exportRide();
                        }else {
                          setState(() {});
                        }
                      },
                    ),
                  ),
                ],
              ),
            );
          }
        }
      },
    );
  }

  Widget _buildFilenameInputField(BuildContext context){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: PlatformAwareWidget(
        android: () => TextFormField(
          textInputAction: TextInputAction.done,
          keyboardType: TextInputType.text,
          autocorrect: false,
          controller: widget.bloc.fileNameController,
          validator: (value) => widget.bloc.validateFileName(
            value,
            S.of(context).ValueIsRequired(S.of(context).Filename),
            S.of(context).FilenameWhitespace,
            S.of(context).FilenameMaxLength("${widget.bloc.filenameMaxLength}"),
            S.of(context).InvalidFilename
          ),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 5),
            labelText: S.of(context).Filename,
            helperText: " ",
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
              controller: widget.bloc.fileNameController,
              onChanged: (value){
                setState(() {
                  widget.bloc.validateFileName(
                      value,
                      S.of(context).ValueIsRequired(S.of(context).Filename),
                      S.of(context).FilenameWhitespace,
                      S.of(context).FilenameMaxLength("${widget.bloc.filenameMaxLength}"),
                      S.of(context).InvalidFilename
                  );
                });
              },
            ),
            Row(
              children: [
                Text(
                    CupertinoFormErrorFormatter.formatErrorMessage(widget.bloc.filenameError),
                    style: ApplicationTheme.iosFormErrorStyle
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  bool _iosValidateFilename(BuildContext context) {
    return widget.bloc.validateFileName(
        widget.bloc.fileNameController.text,
        S.of(context).ValueIsRequired(S.of(context).Filename),
        S.of(context).FilenameWhitespace,
        S.of(context).FilenameMaxLength("${widget.bloc.filenameMaxLength}"),
        S.of(context).InvalidFilename
    ) == null;
  }

  @override
  void dispose() {
    widget.bloc.dispose();
    super.dispose();
  }
}
