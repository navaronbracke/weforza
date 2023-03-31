# This file keeps Flutter sources intact while using Proguard.

-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# The flutter_blue dart package generates some Protobuf Java classes.
# These should be included aswell.
-keep class com.pauldemarco.flutter_blue.** { *; }