/// @docImport 'package:weforza/widgets/pages/home_page/home_page.dart';
library;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/model/home_page_tab.dart';
import 'package:weforza/widgets/common/go_to_export_ride_page_button.dart';
import 'package:weforza/widgets/common/go_to_export_riders_page_button.dart';
import 'package:weforza/widgets/pages/add_ride_page.dart';
import 'package:weforza/widgets/pages/import_riders_page.dart';
import 'package:weforza/widgets/pages/rider_form.dart';
import 'package:weforza/widgets/pages/rider_list/rider_list_title.dart';
import 'package:weforza/widgets/platform/cupertino_icon_button.dart';

/// This widget represents the app bar / navigation bar at the top of the [HomePage].
abstract class _HomePageAppBar extends StatelessWidget {
  const new({required this.selectedTab, super.key});

  /// The selected home page tab.
  final HomePageTab selectedTab;

  void _goToAddRidePage(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AddRidePage()));
  }

  void _goToAddRiderPage(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const RiderForm()));
  }

  void _goToImportRidersPage(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ImportRidersPage()));
  }
}

/// This widget represents the [AppBar] at the top of the [HomePage].
class HomePageAppBar extends _HomePageAppBar implements PreferredSizeWidget {
  const new({required super.selectedTab, super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final translator = S.of(context);

    return switch (selectedTab) {
      .riders => AppBar(
        title: const RiderListTitle(),
        actions: <Widget>[
          IconButton(icon: const Icon(Icons.person_add), onPressed: () => _goToAddRiderPage(context)),
          IconButton(icon: const Icon(Icons.file_download), onPressed: () => _goToImportRidersPage(context)),
          const GoToExportRidersPageButton(),
        ],
      ),
      .rides => AppBar(
        title: Text(translator.rides),
        actions: <Widget>[
          IconButton(icon: const Icon(Icons.add), onPressed: () => _goToAddRidePage(context)),
          const GoToExportRidePageButton(),
        ],
      ),
      .settings => AppBar(title: Text(translator.settings)),
    };
  }
}

/// This widget represents the [CupertinoNavigationBar] for the [HomePage].
class HomePageCupertinoNavigationBar extends _HomePageAppBar implements ObstructingPreferredSizeWidget {
  const new({required super.selectedTab, super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kMinInteractiveDimensionCupertino);

  @override
  bool shouldFullyObstruct(BuildContext context) {
    final color = switch (selectedTab) {
      .riders || .rides => null,
      .settings => CupertinoColors.systemGroupedBackground,
    };

    // This widget only fully obstructs widgets underneath if the background color has no transparency.
    final Color backgroundColor =
        CupertinoDynamicColor.maybeResolve(color, context) ?? CupertinoTheme.of(context).barBackgroundColor;

    return backgroundColor.a == 1.0;
  }

  @override
  Widget build(BuildContext context) {
    final translator = S.of(context);

    return switch (selectedTab) {
      .riders => CupertinoNavigationBar(
        transitionBetweenRoutes: false,
        middle: Row(
          children: <Widget>[
            const Expanded(
              child: Padding(padding: .only(left: 8), child: RiderListTitle()),
            ),
            CupertinoIconButton(
              icon: CupertinoIcons.person_badge_plus_fill,
              onPressed: () => _goToAddRiderPage(context),
            ),
            CupertinoIconButton(
              icon: CupertinoIcons.arrow_down_doc_fill,
              onPressed: () => _goToImportRidersPage(context),
            ),
            const GoToExportRidersPageButton(),
          ],
        ),
      ),
      .rides => CupertinoNavigationBar(
        transitionBetweenRoutes: false,
        middle: Row(
          children: <Widget>[
            Expanded(
              child: Padding(padding: const .only(left: 8), child: Text(translator.rides)),
            ),
            CupertinoIconButton(icon: CupertinoIcons.add, onPressed: () => _goToAddRidePage(context)),
            const GoToExportRidePageButton(),
          ],
        ),
      ),
      .settings => CupertinoNavigationBar(
        backgroundColor: CupertinoColors.systemGroupedBackground,
        border: null,
        middle: Text(translator.settings),
        transitionBetweenRoutes: false,
      ),
    };
  }
}
