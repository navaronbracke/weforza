import 'package:flutter/widgets.dart';
import 'package:weforza/generated/i18n.dart';

///This class represents an error [Widget] for [PersonListPage].
class PersonListPageError extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Center(
    child: Text(S.of(context).PersonCatalogLoadingFailed),
  );
}