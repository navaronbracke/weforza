/// @docImport 'package:weforza/widgets/pages/settings/settings_page.dart';
library;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, ValueListenable;
import 'package:weforza/database/database.dart';
import 'package:weforza/widgets/pages/settings/excluded_terms/add_excluded_term_input_field.dart';
import 'package:weforza/widgets/pages/settings/excluded_terms/excluded_terms_list.dart';
import 'package:weforza/widgets/pages/settings/excluded_terms/excluded_terms_list_footer.dart';
import 'package:weforza/widgets/pages/settings/excluded_terms/excluded_terms_list_header.dart';

/// The [ExcludedTerm]s list for the [SettingsPage].
class ExcludedTermsListSliver extends StatelessWidget {
  const new({
    required this.buildAddTermInputField,
    required this.excludedTermsListenable,
    required this.excludedTermItemBuilder,
    super.key,
  });

  /// The builder for the [AddExcludedTermInputField].
  final Widget Function([BoxDecoration? decoration]) buildAddTermInputField;

  /// The [ValueListenable] for the list of excluded terms.
  final ValueListenable<Set<ExcludedTerm>> excludedTermsListenable;

  /// The item builder for the excluded term items in the list.
  final Widget Function(List<ExcludedTerm>, int, {BoxDecoration? decoration, Widget? divider}) excludedTermItemBuilder;

  Widget _buildExcludedTermDivider(BuildContext context) {
    final border = BorderSide(
      color: CupertinoColors.separator.resolveFrom(context),
      width: 1.0 / MediaQuery.devicePixelRatioOf(context),
    );

    return Container(color: border.color, height: border.width, margin: const EdgeInsetsDirectional.only(start: 15.0));
  }

  @override
  Widget build(BuildContext context) {
    return switch (defaultTargetPlatform) {
      .android || .fuchsia || .linux || .windows || .macOS => SliverPadding(
        padding: const .symmetric(horizontal: 12),
        sliver: SliverMainAxisGroup(
          slivers: [
            const SliverPadding(
              padding: .only(bottom: 8),
              sliver: SliverToBoxAdapter(child: ExcludedTermsListHeader()),
            ),
            ExcludedTermsList(
              addTermInputField: buildAddTermInputField(),
              builder: excludedTermItemBuilder,
              listenable: excludedTermsListenable,
            ),
            const SliverPadding(
              padding: .only(top: 12),
              sliver: SliverToBoxAdapter(child: ExcludedTermsListFooter()),
            ),
          ],
        ),
      ),
      .iOS => SliverPadding(
        padding: const .symmetric(horizontal: 20),
        sliver: SliverMainAxisGroup(
          slivers: [
            ExcludedTermsList(
              addTermInputField: buildAddTermInputField(
                BoxDecoration(
                  borderRadius: const .only(topLeft: .circular(10), topRight: .circular(10)),
                  color: CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context),
                ),
              ),
              listenable: excludedTermsListenable,
              builder: (items, index) => excludedTermItemBuilder(
                items,
                index,
                decoration: BoxDecoration(
                  borderRadius: index == items.length - 1
                      ? const .only(bottomLeft: .circular(10), bottomRight: .circular(10))
                      : .zero,
                  color: CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context),
                ),
                divider: _buildExcludedTermDivider(context),
              ),
            ),
            // TODO: check if the footer needs 20, 40 padding, or 0
            // See https://github.com/navaronbracke/weforza/issues/460
            // Both the CupertinoFormSection and CupertinoListSection (which is used by the former)
            // add 20 default horizontal padding to the footer, so account for 40 total in the footer,
            // since it is not inserted using a `CupertinoFormSection.insetGrouped`.
            const SliverPadding(
              padding: .fromSTEB(20.0, 10.0, 20.0, 0.0),
              sliver: SliverToBoxAdapter(child: ExcludedTermsListFooter()),
            ),
          ],
        ),
      ),
    };
  }
}
