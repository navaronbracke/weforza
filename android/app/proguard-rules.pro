# This file keeps Flutter sources intact while using Proguard.

-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

-keepclassmembernames class com.boskokg.flutter_blue_plus.* { *; }
-keep class com.boskokg.flutter_blue_plus.** { *; }