/// @docImport 'package:weforza/widgets/pages/settings/settings_page.dart';
library;

import 'package:flutter/widgets.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/model/settings/excluded_terms_delegate.dart';
import 'package:weforza/model/settings/rider_filter_delegate.dart';
import 'package:weforza/model/settings/scan_duration_delegate.dart';
import 'package:weforza/model/settings/settings.dart';
import 'package:weforza/riverpod/settings/settings_provider.dart';
import 'package:weforza/widgets/common/focus_absorber.dart';
import 'package:weforza/widgets/pages/settings/settings_page_sliver_navigation_bar.dart';

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
            SliverList(
              delegate: SliverChildListDelegate.fixed([riderListFilter, scanDurationOption, ?excludedTermsListHeader]),
            ),
            excludedTermsList,
            SliverList(delegate: SliverChildListDelegate.fixed([excludedTermsListFooter, resetRideCalendarButton])),
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
