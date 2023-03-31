import 'dart:io' show Platform;

///This class formats form errors for IOS. 
class CupertinoFormErrorFormatter {
  ///Format the given [message], adapted for Cupertino.
  ///Returns an empty string if [Platform.isIOS] is true.
  ///Otherwise returns [message] unmodified.
  static String formatErrorMessage(String message) => Platform.isIOS ? "": message;
}