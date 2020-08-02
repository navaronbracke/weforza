import 'package:flutter/material.dart';
import 'package:weforza/theme/appTheme.dart';

class ImportExportChoiceCard extends StatefulWidget {
  ImportExportChoiceCard({
    @required this.cardIcon,
    @required this.cardText,
    @required this.onTap
  }): assert(
    cardIcon != null && cardText != null && cardText.isNotEmpty && onTap != null
  );

  final String cardText;
  final IconData cardIcon;
  final VoidCallback onTap;

  @override
  _ImportExportChoiceCardState createState() => _ImportExportChoiceCardState();
}

class _ImportExportChoiceCardState extends State<ImportExportChoiceCard> {

  TextStyle textStyle = ApplicationTheme.importExportChoiceTextStyle;
  Color iconColor = ApplicationTheme.primaryColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_){
        setState(() {
          textStyle = ApplicationTheme.importExportChoiceTextStyle.copyWith(
              color: ApplicationTheme.accentColor
          );
          iconColor = ApplicationTheme.accentColor;
        });
      },
      onTapUp: (_){
        setState(() {
          textStyle = ApplicationTheme.importExportChoiceTextStyle;
          iconColor = ApplicationTheme.primaryColor;
        });
      },
      onTap: widget.onTap,
      child: GridTile(
        child: Center(
          child: Icon(
            widget.cardIcon,
            color: iconColor,
          ),
        ),
        footer: GridTileBar(
          title: Text(
            widget.cardText,
            style: textStyle,
            softWrap: true,
          ),
        ),
      ),
    );
  }
}
