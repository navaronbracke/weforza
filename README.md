# WeForza App

### IOS on device testing

Before runing the app on a real IOS device, this checklist should be performed.

- Make sure the signing config is correct.
Check the bundle ID / development team through the `Signing Config` tab in XCode.

- Run `pods install` in the terminal.
(preferably from the flutter project dir)

- Make sure that FlutterBlue can be built.
In the file `<flutter project dir>/ios/.symlinks/plugins/flutter_blue/ios/flutter_blue.podspec`
put the line `ss.header_mappings_dir ...` in comment (line 24).
This is due to the fact that the project was set up with Swift support, but the plugin is Objective C.

- let xcode set up the device for development 
(check that the device is shown in XCode as the selected device)

- trust the developer on the device
On the device itself go to `Device Management` and trust the developer.


### IOS Deployment target version

To bump the minimum iOS version for a project do the following:

- Set MinimumOSVersion to (version number, e.g. 14.4 for iOS 14.4) in ios/Flutter/AppFrameworkInfo.plist
- Ensure that you uncomment platform :ios, '(version number, e.g. 14.4 for iOS 14.4)' in ios/Podfile 
- Ensure that the `flutter_additional_ios_build_settings(target)` section in ios/Podfile has set `IPHONEOS_DEPLOYMENT_TARGET`
```
    post_install do |installer|
      installer.pods_project.targets.each do |target|
        flutter_additional_ios_build_settings(target)
        target.build_configurations.each do |config|
          config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '(version number, e.g. 14.4 for iOS 14.4)'
        end
      end
    end
```

#### Note

If the iOS compilation fails, even after incrementing the supported iOS version, try running `flutter clean` and restarting your IDE.
