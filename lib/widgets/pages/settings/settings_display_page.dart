/// @docImport 'package:weforza/widgets/pages/settings/settings_page.dart';
library;

import 'package:flutter/widgets.dart';
import 'package:weforza/database/database.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/model/settings/excluded_terms_delegate.dart';
import 'package:weforza/model/settings/rider_filter_delegate.dart';
import 'package:weforza/model/settings/scan_duration_delegate.dart';
import 'package:weforza/model/settings/settings.dart';
import 'package:weforza/riverpod/settings/settings_provider.dart';
import 'package:weforza/widgets/common/focus_absorber.dart';
import 'package:weforza/widgets/pages/settings/excluded_terms/add_excluded_term_input_field.dart';
import 'package:weforza/widgets/pages/settings/excluded_terms/edit_excluded_term_input_field.dart';
import 'package:weforza/widgets/pages/settings/excluded_terms/excluded_terms_list.dart';
import 'package:weforza/widgets/pages/settings/excluded_terms/excluded_terms_list_footer.dart';
import 'package:weforza/widgets/pages/settings/excluded_terms/excluded_terms_list_header.dart';
import 'package:weforza/widgets/pages/settings/excluded_terms/excluded_terms_list_sliver.dart';
import 'package:weforza/widgets/pages/settings/settings_page_sliver_navigation_bar.dart';
import 'package:weforza/widgets/pages/settings/settings_page_sliver_reset_ride_calendar_button.dart';
import 'package:weforza/widgets/pages/settings/settings_page_sliver_rider_list_filter.dart';

/// The display page for a [SettingsPage] layout, that displays the provided [Settings].
class SettingsDisplayPage extends StatefulWidget {
  const new({required this.scrollController, required this.settings, required this.settingsDelegate, super.key});

  final ScrollController scrollController;
  final Settings settings;
  final SettingsNotifier settingsDelegate;

  @override
  State<SettingsDisplayPage> createState() => _SettingsDisplayPageState();
}

class _SettingsDisplayPageState extends State<SettingsDisplayPage> {
  late final ExcludedTermsDelegate excludedTermsDelegate;
  late final RiderFilterDelegate riderFilterDelegate;
  late final ScanDurationDelegate scanDurationDelegate;

  final addTermController = TextEditingController();
  final addTermFocusNode = FocusNode();
  final addTermFormKey = GlobalKey<FormFieldState<String>>();

  void _handleAddTermFocusChange() {
    if (addTermFocusNode.hasPrimaryFocus) {
      return;
    }

    addTermFormKey.currentState?.reset();
  }

  Widget _buildAddTermInputField([BoxDecoration? decoration]) {
    return AddExcludedTermInputField(
      controller: addTermController,
      decoration: decoration,
      delegate: excludedTermsDelegate,
      focusNode: addTermFocusNode,
      formKey: addTermFormKey,
    );
  }

  Widget _buildExcludedTermItem(List<ExcludedTerm> terms, int index, {BoxDecoration? decoration, Widget? divider}) {
    return EditExcludedTermInputField(
      decoration: decoration,
      delegate: excludedTermsDelegate,
      divider: divider,
      index: index,
      excludedTerm: terms[index],
      scrollController: widget.scrollController,
    );
  }

  @override
  void initState() {
    super.initState();
    excludedTermsDelegate = ExcludedTermsDelegate(
      settingsDelegate: widget.settingsDelegate,
      initialValue: widget.settings.excludedTermsFilter,
    );
    riderFilterDelegate = RiderFilterDelegate(
      settingsDelegate: widget.settingsDelegate,
      initialValue: widget.settings.riderListFilter,
    );
    scanDurationDelegate = ScanDurationDelegate(
      settingsDelegate: widget.settingsDelegate,
      initialValue: widget.settings.scanDuration.toDouble(),
    );

    addTermFocusNode.addListener(_handleAddTermFocusChange);
  }

  @override
  Widget build(BuildContext context) {
    return FocusAbsorber(
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) => CustomScrollView(
          controller: widget.scrollController,
          slivers: [
            ?SettingsPageSliverNavigationBar.buildForConstraints(constraints),
            SettingsPageSliverRiderListFilter(delegate: riderFilterDelegate),
            SliverList(delegate: SliverChildListDelegate.fixed([scanDurationOption])),
            ExcludedTermsListSliver(
              buildAddTermInputField: _buildAddTermInputField,
              excludedTermItemBuilder: _buildExcludedTermItem,
              excludedTermsListenable: excludedTermsDelegate.listenable,
            ),
            const SettingsPageSliverResetRideCalendarButton(),
            version,
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    addTermController.dispose();
    addTermFocusNode.removeListener(_handleAddTermFocusChange);
    addTermFocusNode.dispose();
    excludedTermsDelegate.dispose();
    riderFilterDelegate.dispose();
    scanDurationDelegate.dispose();
    super.dispose();
  }
}
