import 'package:flutter/material.dart';
import 'package:weforza/theme/appTheme.dart';

///This widget represents a 'something went wrong'-like generic error widget.
class GenericError extends StatelessWidget {
  GenericError({
    @required this.text,
    this.icon = Icons.warning,
  }): assert(icon != null && text != null && text.isNotEmpty);

  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context){
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            icon,
            color: ApplicationTheme.listInformationalIconColor,
            size: MediaQuery.of(context).size.shortestSide * .1,
          ),
          SizedBox(height: 5),
          Text(text)
        ],
      ),
    );
  }
}