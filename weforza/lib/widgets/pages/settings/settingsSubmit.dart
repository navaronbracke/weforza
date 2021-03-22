import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:weforza/blocs/settingsBloc.dart';
import 'package:weforza/widgets/platform/cupertinoIconButton.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

class SettingsSubmit extends StatefulWidget {
  SettingsSubmit({
    required this.bloc
  });

  final SettingsBloc bloc;

  @override
  _SettingsSubmitState createState() => _SettingsSubmitState();
}

class _SettingsSubmitState extends State<SettingsSubmit> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: widget.bloc.saveSettingsFuture,
      builder: (context,snapshot){
        // We did not submit yet, show the submit button.
        if(snapshot.connectionState == ConnectionState.none){
          return _buildSubmitButton();
        }else if (snapshot.connectionState == ConnectionState.done){
          if(snapshot.hasError){
            return _buildError();
          }else {
            return _buildSubmitButton();
          }
        } else {
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
              child: Center(
                child: PlatformAwareWidget(
                  android: () => CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
                  ios: () => CupertinoActivityIndicator(),
                ),
              ),
          );
        }
      },
    );
  }

  Widget _buildSubmitButton(){
    return PlatformAwareWidget(
      android: () => IconButton(
        icon: Icon(Icons.done,color: Colors.white),
        onPressed: onSaveSettings,
      ),
      ios: () => Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: CupertinoIconButton.fromAppTheme(
          icon: Icons.done,
          onPressed: onSaveSettings,
        ),
      ),
    );
  }

  Widget _buildError(){
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: PlatformAwareWidget(
        android: () => Icon(Icons.warning, color: Colors.orange.shade200),
        ios: () => Icon(CupertinoIcons.exclamationmark_triangle_fill, color: Colors.orange),
      ),
    );
  }

  void onSaveSettings(){
    setState((){
      widget.bloc.saveSettings();
    });
  }
}