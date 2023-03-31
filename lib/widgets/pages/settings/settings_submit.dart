import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/model/save_settings_delegate.dart';
import 'package:weforza/widgets/platform/cupertino_icon_button.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

class SettingsSubmit extends StatefulWidget {
  const SettingsSubmit({
    Key? key,
    required this.delegate,
  }) : super(key: key);

  final SaveSettingsDelegate delegate;

  @override
  _SettingsSubmitState createState() => _SettingsSubmitState();
}

class _SettingsSubmitState extends State<SettingsSubmit> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: widget.delegate.future,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return _buildSubmitButton();
          case ConnectionState.done:
            return snapshot.hasError ? _buildError() : _buildSubmitButton();
          default:
            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Center(
                child: PlatformAwareWidget(
                  android: () => const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                  ios: () => const CupertinoActivityIndicator(),
                ),
              ),
            );
        }
      },
    );
  }

  Widget _buildSubmitButton() {
    return PlatformAwareWidget(
      android: () => IconButton(
        icon: const Icon(Icons.done, color: Colors.white),
        onPressed: onSaveSettings,
      ),
      ios: () => Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: CupertinoIconButton.fromAppTheme(
          icon: CupertinoIcons.checkmark_alt,
          onPressed: onSaveSettings,
        ),
      ),
    );
  }

  Widget _buildError() {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: PlatformAwareWidget(
        android: () => Icon(
          Icons.warning,
          color: Colors.orange.shade200,
        ),
        ios: () => const Icon(
          CupertinoIcons.exclamationmark_triangle_fill,
          color: Colors.orange,
        ),
      ),
    );
  }

  void onSaveSettings() {
    setState(() {
      widget.delegate.saveSettings();
    });
  }
}
