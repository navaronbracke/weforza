import 'package:flutter/widgets.dart';

///This class checks the screen dimensions, more precisely the width, and returns an appropriate [Widget].
///None of the builder functions can be null.
class ScreenSizeAwareWidget extends StatelessWidget {
  ///A breakpoint for tablet layouts.
  static final int tabletBreakpoint = 768;
  ///A breakpoint for desktop layouts.
  static final int desktopBreakpoint = 992;
  ///A breakpoint for ultra wide screen layouts.
  static final int ultraWideBreakpoint = 1200;

  ScreenSizeAwareWidget({
    @required this.phone,
    @required this.tablet,
    @required this.desktop,
    @required this.ultraWide,
    Key key
  }): assert(
    phone != null && tablet != null && desktop != null && ultraWide != null
  ), super(key: key);

  ///The builder for phone layouts.
  final Widget Function() phone;

  ///The builder for tablet layouts.
  final Widget Function() tablet;

  ///The builder for desktop layouts.
  final Widget Function() desktop;

  ///The builder for ultra-wide desktop layouts.
  final Widget Function() ultraWide;



  ///Build a responsive [Widget].
  ///Returns the result of calling [ultraWide] if the device is equal to or larger than [ultraWideBreakpoint] in size.
  ///Returns the result of calling [desktop] if the device is equal to or larger than [desktopBreakpoint] and smaller than [ultraWideBreakpoint] in size.
  ///Returns the result of calling [tablet] if the device is equal to or larger than [tabletBreakpoint] and smaller than [desktopBreakpoint] in size.
  ///Returns the result of calling [phone] otherwise.
  @override
  Widget build(BuildContext context) {
    final currentSize = MediaQuery.of(context).size.width;

    if(currentSize >= ultraWideBreakpoint){
      assert(ultraWide != null);
      return ultraWide();
    } else if(currentSize >= desktopBreakpoint){
      assert(desktop != null);
      return desktop();
    } else if (currentSize >= tabletBreakpoint){
      assert(tablet != null);
      return tablet();
    }else {
      assert(phone != null);
      return phone();
    }
  }
}