# WeForza App

### Translations

The application uses `flutter gen-l10n` to generate the translations.

To generate the translations, run `flutter gen-l10n`.

During hot reload the tool will regenerate translations
for arb files that were originally passed to the build input.
If a new locale is added, a [full restart is required](https://github.com/flutter/flutter/issues/58183).

See also: https://docs.flutter.dev/development/accessibility-and-localization/internationalization

#### Translating the iOS Information Property List file (Info.plist)

The `Info.plist` file contains `NSUsageDescription` tags that should be translated.
These contain the descriptions for system defined permission dialogs.
The title and button labels are provided by the system and do not have to be translated.

To translate the Info.plist file do the following:

A) If the InfoPlist.strings file does not yet exist:

- Create a new Resource file under `ios > Runner > Runner`
- Select the inner `Runner` target
- Right click and select `New File`
- Select `Strings File` under the `Resource` category
- Create the new file with the name `InfoPlist.strings`
- Add the baseline translations (usually in English) in this file using the format `Key="Translation";`
- Back in XCode, select the `InfoPlist.strings` file
- Press the `Localise` button on the right
- Select the languages that the `InfoPlist.strings` file should be localised in
- Add the translations to the newly created `InfoPlist.strings` variants (one per selected language)

b) If the InfoPlist.strings file does exist:

- Select the `InfoPlist.strings` file
- Add the desired languages that should have their `InfoPlist.strings` variants added
- Add the translations to the newly created `InfoPlist.strings` variants (one per selected language)

### IOS on device testing

Before runing the app on a real IOS device, this checklist should be performed.

- Make sure the signing config is correct.
  Check the bundle ID / development team through the `Signing Config` tab in XCode.

- Let XCode set up the device for development.
  * Check that the device is shown in XCode as the selected device.
  * iOS 15 and lower: If the device is shown as `untrusted`, trust the host machine from the device when connecting.
    The device will display a confirmation dialog. When prompted, register the device with XCode.
  * iOS 16 and higher: On iOS 16 and higher Developer mode should be enabled on the device.
  See https://developer.apple.com/documentation/xcode/enabling-developer-mode-on-a-device

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
