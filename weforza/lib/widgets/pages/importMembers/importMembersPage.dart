import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/blocs/importMembersBloc.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/theme/appTheme.dart';
import 'package:weforza/widgets/common/genericError.dart';
import 'package:weforza/widgets/custom/checkmarkPainter/checkmarkPainter.dart';
import 'package:weforza/widgets/platform/platformAwareLoadingIndicator.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';
import 'package:weforza/widgets/providers/reloadDataProvider.dart';

class ImportMembersPage extends StatefulWidget {

  @override
  _ImportMembersPageState createState() => _ImportMembersPageState();
}

class _ImportMembersPageState extends State<ImportMembersPage> {

  final ImportMembersBloc bloc = ImportMembersBloc();

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
    return FutureBuilder<void>(
      initialData: bloc.importMembersFuture,
      builder: (context, snapshot){
        if(snapshot.connectionState == ConnectionState.done){
          if(snapshot.hasError){
            return !bloc.fileChosen ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(S.of(context).ImportMembersPickFileWarning),
                SizedBox(height: 10),
                _buildButton(context),
              ],
            ): GenericError(text: S.of(context).GenericError);
          }else{
            return Column(
              children: <Widget>[
                Flexible(
                  flex: 3,
                  child: Center(
                    child: LayoutBuilder(
                      builder: (context, constraints) => CheckmarkPainter(
                        strokeWidth: 4.0,
                        color: ApplicationTheme.primaryColor,
                        canvasSize: Size.square(constraints.biggest.shortestSide * .4),
                        duration: Duration(milliseconds: 1500),
                      ),
                    ),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Center(
                    child: PlatformAwareWidget(
                      android: () => RaisedButton(
                          color: ApplicationTheme.primaryColor,
                          child: Text(S.of(context).GoBack, style: TextStyle(color: Colors.white)),
                          onPressed: () => Navigator.of(context).pop()
                      ),
                      ios: () => CupertinoButton.filled(
                          child: Text(S.of(context).GoBack, style: TextStyle(color: Colors.white)),
                          onPressed: () => Navigator.of(context).pop()
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
        }else if(snapshot.connectionState == ConnectionState.waiting){
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(""),
              SizedBox(height: 10),
              _buildButton(context),
            ],
          );
        }else {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              PlatformAwareLoadingIndicator(),
              SizedBox(height: 10),
              Text(S.of(context).ImportMembersImporting),
            ],
          );
        }
      },
    );
  }

  Widget _buildButton(BuildContext context){
    return PlatformAwareWidget(
      android: () => RaisedButton(
        onPressed: () => setState(() =>
            bloc.pickFileAndImportMembers(
                ReloadDataProvider.of(context).reloadMembers
            )
        ),
        color: ApplicationTheme.primaryColor,
        child: Text(
          S.of(context).ImportMembersPickFile,
          style: TextStyle(color: Colors.white),
        ),
      ),
      ios: () => CupertinoButton.filled(
          child: Text(S.of(context).ImportMembersPickFile),
          onPressed: () => setState(() =>
              bloc.pickFileAndImportMembers(
                  ReloadDataProvider.of(context).reloadMembers
              )
          )
      ),
    );
  }

}
