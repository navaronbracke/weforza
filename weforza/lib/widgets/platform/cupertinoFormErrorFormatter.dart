import 'dart:io';

///This class formats form errors for IOS. 
class CupertinoFormErrorFormatter {
  ///Format the given [message], adapted for Cupertino.
  ///Returns an empty string if [message] is null and [Platform.isIOS] is true.
  ///Ohterwise returns [message] unmodified.
  static String formatErrorMessage(String message) => (Platform.isIOS && message == null) ? "": message;
}