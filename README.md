# WeForza App

### Translations

The application uses `flutter gen-l10n` to generate the translations.

To generate the translations, run `flutter gen-l10n`.

During hot reload the tool will regenerate translations
for arb files that were originally passed to the build input.
If a new locale is added, a [full restart is required](https://github.com/flutter/flutter/issues/58183).

See also: https://docs.flutter.dev/development/accessibility-and-localization/internationalization

### IOS on device testing

Before runing the app on a real IOS device, this checklist should be performed.

- Make sure the signing config is correct.
  Check the bundle ID / development team through the `Signing Config` tab in XCode.

- Let XCode set up the device for development.
  * Check that the device is shown in XCode as the selected device.
  * If it is shown as `untrusted`, trust the host machine from the device when connecting.
    The device will ask this through a confirmation dialog.
  * When prompted, register the device with XCode. Xcode will show a dialog for this.

- If required, run `pods install` in the terminal. (preferably from the flutter project dir)
  Usually the Flutter tool does this automatically when building.

### IOS Deployment target version

To bump the minimum iOS version for a project do the following:
- Open the project in XCode
- Set the iOS version under `Runner > General > Minimum Deployments > iOS`
- In `ios/Flutter/AppFrameworkInfo.plist` set `MinimumOSVersion`
- Update the `platform :ios, <version number>` section in the Podfile.
- Ensure that the `flutter_additional_ios_build_settings(target)` section in ios/Podfile has set `IPHONEOS_DEPLOYMENT_TARGET`
```
    post_install do |installer|
      installer.pods_project.targets.each do |target|
        flutter_additional_ios_build_settings(target)
        target.build_configurations.each do |config|
          config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '<version number>'
        end
      end
    end
```

#### Note

If the iOS compilation fails, even after incrementing the supported iOS version, try running `flutter clean` and restarting your IDE.
