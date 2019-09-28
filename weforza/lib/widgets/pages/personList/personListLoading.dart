import 'package:flutter/widgets.dart';
import 'package:weforza/generated/i18n.dart';
import 'package:weforza/widgets/loadingIndicator.dart';

///This class represents a loading [Widget] for [PersonListPage].
class PersonListPageLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          PlatformAwareLoadingIndicator(),
          SizedBox(height: 5),
          Text(S.of(context).PersonCatalogLoadingInProgress),
        ],
      ),
    );
  }
}