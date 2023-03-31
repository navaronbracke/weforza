import 'package:flutter/cupertino.dart';

class CupertinoLoadingDialog extends StatelessWidget {
  const CupertinoLoadingDialog({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CupertinoPopupSurface(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: CupertinoActivityIndicator(),
        ),
      ),
    );
  }
}