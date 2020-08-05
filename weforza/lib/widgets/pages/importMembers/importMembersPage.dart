import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/blocs/importMembersBloc.dart';
import 'package:weforza/file/fileHandler.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/injection/injector.dart';
import 'package:weforza/repository/importMembersRepository.dart';
import 'package:weforza/theme/appTheme.dart';
import 'package:weforza/widgets/common/genericError.dart';
import 'package:weforza/widgets/pages/importMembers/importMembersComplete.dart';
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
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                    S.of(context).ImportMembersPickFileWarning,
                    style: ApplicationTheme.importWarningTextStyle,
                    softWrap: true
                ),
                SizedBox(height: 10),
                _buildButton(context),
              ],
            );
          }else if(snapshot.error is InvalidFileFormatError){
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                    S.of(context).ImportMembersInvalidFileFormat,
                    style: ApplicationTheme.importWarningTextStyle,
                    softWrap: true
                ),
                SizedBox(height: 10),
                _buildButton(context),
                SizedBox(height: 10),
                LayoutBuilder(
                  builder: (context, constraints){
                    return SizedBox(
                      width: constraints.biggest.shortestSide * .8,
                      child: Center(
                        child: Text(S.of(context).ImportMembersHeaderStrippedMessage,
                            style: ApplicationTheme.importMembersHeaderRemovalMessageTextStyle,
                            softWrap: true, maxLines: 2
                        ),
                      ),
                    );
                  },
                ),
              ],
            );
          }else{
            return GenericError(text: S.of(context).GenericError);
          }
        }else{
          switch(snapshot.data){
            case ImportMembersState.IDLE: return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(""),
                SizedBox(height: 10),
                _buildButton(context),
                SizedBox(height: 10),
                LayoutBuilder(
                  builder: (context, constraints){
                    return SizedBox(
                      width: constraints.biggest.shortestSide * .8,
                      child: Center(
                        child: Text(S.of(context).ImportMembersHeaderStrippedMessage,
                            style: ApplicationTheme.importMembersHeaderRemovalMessageTextStyle,
                            softWrap: true, maxLines: 2
                        ),
                      ),
                    );
                  },
                ),
              ],
            );
            case ImportMembersState.PICKING_FILE: return Center(
                child: PlatformAwareLoadingIndicator()
            );
            case ImportMembersState.IMPORTING: return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                PlatformAwareLoadingIndicator(),
                SizedBox(height: 10),
                Text(S.of(context).ImportMembersImporting, softWrap: true),
              ],
            );
            case ImportMembersState.DONE: return Center(
              child: LayoutBuilder(
                builder: (context,constraints){
                  final size = constraints.biggest.shortestSide * .8;
                  return SizedBox(
                    width: size,
                    height: size,
                    child: ImportMembersComplete(),
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
    bloc.pickFileAndImportMembers(
        S.of(context).ImportMembersCsvHeaderRegex,
        ReloadDataProvider.of(context).reloadMembers
    );
  }

  Widget _buildButton(BuildContext context){
    return PlatformAwareWidget(
      android: () => FlatButton(
        onPressed: () => onImportMembers(context),
        child: Text(
          S.of(context).ImportMembersPickFile,
          style: TextStyle(color: ApplicationTheme.primaryColor),
        ),
      ),
      ios: () => CupertinoButton(
        child: Text(
          S.of(context).ImportMembersPickFile,
          style: TextStyle(color: ApplicationTheme.primaryColor),
        ),
        onPressed: () => onImportMembers(context),
      ),
    );
  }

}
