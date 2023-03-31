import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/blocs/importMembersBloc.dart';
import 'package:weforza/exceptions/exceptions.dart';
import 'package:weforza/file/fileHandler.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/injection/injectionContainer.dart';
import 'package:weforza/repository/importMembersRepository.dart';
import 'package:weforza/theme/appTheme.dart';
import 'package:weforza/widgets/common/genericError.dart';
import 'package:weforza/widgets/custom/animatedCheckmark/animatedCheckmark.dart';
import 'package:weforza/widgets/platform/platformAwareLoadingIndicator.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';
import 'package:weforza/widgets/providers/reloadDataProvider.dart';

class ImportMembersPage extends StatefulWidget {

  @override
  _ImportMembersPageState createState() => _ImportMembersPageState();
}

class _ImportMembersPageState extends State<ImportMembersPage> {

  final ImportMembersBloc bloc = ImportMembersBloc(
    fileHandler: InjectionContainer.get<IFileHandler>(),
    repository: InjectionContainer.get<ImportMembersRepository>(),
  );

  @override
  Widget build(BuildContext context) {
    return PlatformAwareWidget(
      android: () => _buildAndroidWidget(context),
      ios: () => _buildIosWidget(context),
    );
  }

  Widget _buildAndroidWidget(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).ImportMembersPageTitle),
      ),
      body: Center(child: _buildBody(context)),
    );
  }

  Widget _buildIosWidget(BuildContext context){
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(S.of(context).ImportMembersPageTitle),
      ),
      child: Center(child: _buildBody(context)),
    );
  }

  Widget _buildBody(BuildContext context){
    return StreamBuilder<ImportMembersState>(
      stream: bloc.importStream,
      builder: (context, snapshot){
        if(snapshot.hasError){
          if(snapshot.error is NoFileChosenError){
            return _buildNoFileChosen(context);
          }else if(snapshot.error is InvalidFileExtensionError){
            return _buildInvalidFileExtension(context);
          }else if(snapshot.error is CsvHeaderMissingError){
            return _buildCsvHeaderMissing(context);
          }else if(snapshot.error is JsonFormatIncompatibleException){
            final iconBuilder = (BuildContext ctx){
              return PlatformAwareWidget(
                android: () => Icon(
                  Icons.insert_drive_file,
                  color: ApplicationTheme.listInformationalIconColor,
                  size: MediaQuery.of(ctx).size.shortestSide * .1,
                ),
                ios: () => Icon(
                  CupertinoIcons.doc_fill,
                  color: ApplicationTheme.listInformationalIconColor,
                  size: MediaQuery.of(ctx).size.shortestSide * .1,
                ),
              );
            };

            return  GenericError(
              text: S.of(context).ImportMembersIncompatibleFileJsonContents,
              iconBuilder: iconBuilder, 
            );
          }else{
            return GenericError(text: S.of(context).GenericError);
          }
        }else{
          switch(snapshot.data){
            case ImportMembersState.IDLE: return _buildPickFileForm(context);
            case ImportMembersState.PICKING_FILE: return Center(
                child: PlatformAwareLoadingIndicator()
            );
            case ImportMembersState.IMPORTING: return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                PlatformAwareLoadingIndicator(),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(S.of(context).ImportMembersImporting, softWrap: true),
                ),
              ],
            );
            case ImportMembersState.DONE: return Center(
              child: LayoutBuilder(
                builder: (context,constraints){
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
                      )
                  );
                },
              ),
            );
            default: return GenericError(text: S.of(context).GenericError);
          }
        }
      },
    );
  }

  void onImportMembers(BuildContext context){
    final provider = ReloadDataProvider.of(context);
    bloc.pickFileAndImportMembers(
      S.of(context).ImportMembersCsvHeaderRegex,
      provider.reloadMembers,
      provider.reloadDevices
    );
  }

  Widget _buildButton(BuildContext context){
    return PlatformAwareWidget(
      android: () => TextButton(
        onPressed: () => onImportMembers(context),
        child: Text(S.of(context).ImportMembersPickFile),
      ),
      ios: () => CupertinoButton.filled(
        child: Text(
          S.of(context).ImportMembersPickFile,
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () => onImportMembers(context),
      ),
    );
  }

  Widget _buildNoFileChosen(BuildContext context){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
            S.of(context).ImportMembersPickFileWarning,
            style: ApplicationTheme.importWarningTextStyle,
            softWrap: true
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: _buildButton(context),
        ),
      ],
    );
  }

  Widget _buildInvalidFileExtension(BuildContext context){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
            S.of(context).ImportMembersInvalidFileExtension,
            style: ApplicationTheme.importWarningTextStyle,
            softWrap: true
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: _buildButton(context),
        ),
      ],
    );
  }

  Widget _buildCsvHeaderMissing(BuildContext context){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
            S.of(context).ImportMembersCsvHeaderRequired,
            style: ApplicationTheme.importWarningTextStyle,
            softWrap: true
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: _buildButton(context),
        ),
        LayoutBuilder(
          builder: (context, constraints){
            return SizedBox(
              width: constraints.biggest.shortestSide * .8,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(S.of(context).ImportMembersCsvHeaderExampleDescription,
                        style: ApplicationTheme.importMembersHeaderExampleTextStyle,
                        softWrap: true
                    ),
                  ),
                  Text(
                    S.of(context).ExportMembersCsvHeader,
                    style: ApplicationTheme.importMembersHeaderExampleTextStyle,
                    softWrap: true,
                  )
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildPickFileForm(BuildContext context){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(""),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: _buildButton(context),
        ),
      ],
    );
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

}