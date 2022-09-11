import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/theme/app_theme.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

/// This class represents a generic error widget.
///
/// This widget centers itself within its parent.
class GenericError extends StatelessWidget {
  GenericError({
    super.key,
    required this.text,
    this.iconBuilder,
  })  : assert(text.isNotEmpty);

  final String text;
  final Widget Function(BuildContext context)? iconBuilder;

  /// Build a Widget that serves as the icon.
  /// Returns the result of [iconBuilder]
  /// or a default warning icon.
  Widget _buildIcon(BuildContext context) {
    final builder = iconBuilder;

    if (builder != null) {
      return builder(context);
    }

    return PlatformAwareWidget(
      android: () => Icon(
        Icons.warning,
        color: ApplicationTheme.listInformationalIconColor,
        size: MediaQuery.of(context).size.shortestSide * .1,
      ),
      ios: () => Icon(
        CupertinoIcons.exclamationmark_triangle_fill,
        color: ApplicationTheme.listInformationalIconColor,
        size: MediaQuery.of(context).size.shortestSide * .1,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _buildIcon(context),
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(text),
          )
        ],
      ),
    );
  }
}
