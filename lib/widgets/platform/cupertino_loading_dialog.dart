import 'package:flutter/cupertino.dart';

class CupertinoLoadingDialog extends StatelessWidget {
  const CupertinoLoadingDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CupertinoPopupSurface(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: CupertinoActivityIndicator(),
        ),
      ),
    );
  }
}