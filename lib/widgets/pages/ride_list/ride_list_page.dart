import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/widgets/pages/add_ride_page.dart';
import 'package:weforza/widgets/pages/export_data_page/export_ride_page.dart';
import 'package:weforza/widgets/pages/ride_list/ride_list.dart';
import 'package:weforza/widgets/platform/cupertino_icon_button.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

class RideListPage extends StatelessWidget {
  const RideListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PlatformAwareWidget(
      android: _buildAndroidWidget,
      ios: _buildIosWidget,
    );
  }

  Widget _buildAndroidWidget(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).rides),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const AddRidePage()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.file_upload),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const ExportRidePage()),
            ),
          ),
        ],
      ),
      body: const RideList(),
    );
  }

  Widget _buildIosWidget(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        transitionBetweenRoutes: false,
        middle: Row(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(S.of(context).rides),
              ),
            ),
            CupertinoIconButton(
              icon: CupertinoIcons.add,
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const AddRidePage()),
              ),
            ),
            CupertinoIconButton(
              icon: CupertinoIcons.arrow_up_doc_fill,
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const ExportRidePage()),
              ),
            ),
          ],
        ),
      ),
      child: const SafeArea(bottom: false, child: RideList()),
    );
  }
}
