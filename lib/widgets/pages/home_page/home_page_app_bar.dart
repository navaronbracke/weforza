import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/model/home_page_tab.dart';
import 'package:weforza/widgets/pages/add_ride_page.dart';
import 'package:weforza/widgets/pages/export_data_page/export_ride_page.dart';
import 'package:weforza/widgets/pages/export_data_page/export_riders_page.dart';
import 'package:weforza/widgets/pages/import_riders_page.dart';
import 'package:weforza/widgets/pages/rider_form.dart';
import 'package:weforza/widgets/pages/rider_list/rider_list_title.dart';
import 'package:weforza/widgets/platform/cupertino_icon_button.dart';

/// This widget represents the app bar / navigation bar at the top of the home page.
abstract class _HomePageAppBar extends StatelessWidget {
  const _HomePageAppBar({required this.selectedTab, super.key});

  /// The selected home page tab.
  final HomePageTab selectedTab;

  void _goToAddRidePage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const AddRidePage()),
    );
  }

  void _goToAddRiderPage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const RiderForm()),
    );
  }

  void _goToExportRidePage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const ExportRidePage()),
    );
  }

  void _goToExportRidersPage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const ExportRidersPage(),
      ),
    );
  }

  void _goToImportRidersPage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const ImportRidersPage(),
      ),
    );
  }
}

/// This widget represents the [AppBar] at the top of the [HomePage].
class HomePageAppBar extends _HomePageAppBar implements PreferredSizeWidget {
  const HomePageAppBar({required super.selectedTab, super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final translator = S.of(context);

    switch (selectedTab) {
      case HomePageTab.riders:
        return AppBar(
          title: const RiderListTitle(),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.person_add),
              onPressed: () => _goToAddRiderPage(context),
            ),
            IconButton(
              icon: const Icon(Icons.file_download),
              onPressed: () => _goToImportRidersPage(context),
            ),
            IconButton(
              icon: const Icon(Icons.file_upload),
              onPressed: () => _goToExportRidersPage(context),
            ),
          ],
        );
      case HomePageTab.rides:
        return AppBar(
          title: Text(translator.rides),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => _goToAddRidePage(context),
            ),
            IconButton(
              icon: const Icon(Icons.file_upload),
              onPressed: () => _goToExportRidePage(context),
            ),
          ],
        );
      case HomePageTab.settings:
        return AppBar(title: Text(translator.settings));
    }
  }
}

/// This widget represents the [CupertinoNavigationBar] for the [HomePage].
class HomePageCupertinoNavigationBar extends _HomePageAppBar implements ObstructingPreferredSizeWidget {
  const HomePageCupertinoNavigationBar({required super.selectedTab, super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kMinInteractiveDimensionCupertino);

  @override
  bool shouldFullyObstruct(BuildContext context) {
    Color? color;

    switch (selectedTab) {
      case HomePageTab.riders:
      case HomePageTab.rides:
        color = null;
        break;
      case HomePageTab.settings:
        color = CupertinoColors.systemGroupedBackground;
        break;
    }

    // This widget only fully obstructs widgets underneath if the background color has no transparency.
    final Color backgroundColor =
        CupertinoDynamicColor.maybeResolve(color, context) ?? CupertinoTheme.of(context).barBackgroundColor;

    return backgroundColor.alpha == 0xFF;
  }

  @override
  Widget build(BuildContext context) {
    final translator = S.of(context);

    switch (selectedTab) {
      case HomePageTab.riders:
        return CupertinoNavigationBar(
          transitionBetweenRoutes: false,
          middle: Row(
            children: <Widget>[
              const Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: RiderListTitle(),
                ),
              ),
              CupertinoIconButton(
                icon: CupertinoIcons.person_badge_plus_fill,
                onPressed: () => _goToAddRiderPage(context),
              ),
              CupertinoIconButton(
                icon: CupertinoIcons.arrow_down_doc_fill,
                onPressed: () => _goToImportRidersPage(context),
              ),
              CupertinoIconButton(
                icon: CupertinoIcons.arrow_up_doc_fill,
                onPressed: () => _goToExportRidersPage(context),
              ),
            ],
          ),
        );
      case HomePageTab.rides:
        return CupertinoNavigationBar(
          transitionBetweenRoutes: false,
          middle: Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text(translator.rides),
                ),
              ),
              CupertinoIconButton(
                icon: CupertinoIcons.add,
                onPressed: () => _goToAddRidePage(context),
              ),
              CupertinoIconButton(
                icon: CupertinoIcons.arrow_up_doc_fill,
                onPressed: () => _goToExportRidePage(context),
              ),
            ],
          ),
        );
      case HomePageTab.settings:
        return CupertinoNavigationBar(
          backgroundColor: CupertinoColors.systemGroupedBackground,
          border: null,
          middle: Text(translator.settings),
          transitionBetweenRoutes: false,
        );
    }
  }
}
