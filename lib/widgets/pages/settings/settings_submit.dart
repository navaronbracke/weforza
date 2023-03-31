import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/widgets/platform/cupertino_icon_button.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

class SettingsSubmit extends StatelessWidget {
  const SettingsSubmit({super.key, this.future, required this.onSaveSettings});

  final Future<void>? future;

  final void Function() onSaveSettings;

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

  Widget _buildSubmitButton() {
    return PlatformAwareWidget(
      android: () => IconButton(
        icon: const Icon(Icons.done, color: Colors.white),
        onPressed: onSaveSettings,
      ),
      ios: () => Padding(
        padding: const EdgeInsets.only(right: 8),
        child: CupertinoIconButton.fromAppTheme(
          icon: CupertinoIcons.checkmark_alt,
          onPressed: onSaveSettings,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: future,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return _buildSubmitButton();
          case ConnectionState.done:
            return snapshot.hasError ? _buildError() : _buildSubmitButton();
          default:
            return Padding(
              padding: const EdgeInsets.only(right: 8),
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
}
