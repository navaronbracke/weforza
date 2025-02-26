import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/model/settings/excluded_terms_delegate.dart';
import 'package:weforza/model/settings/rider_filter_delegate.dart';
import 'package:weforza/model/settings/scan_duration_delegate.dart';
import 'package:weforza/riverpod/settings_provider.dart';
import 'package:weforza/widgets/common/focus_absorber.dart';
import 'package:weforza/widgets/pages/settings/app_version.dart';
import 'package:weforza/widgets/pages/settings/excluded_terms/add_excluded_term_input_field.dart';
import 'package:weforza/widgets/pages/settings/excluded_terms/edit_excluded_term_input_field.dart';
import 'package:weforza/widgets/pages/settings/excluded_terms/excluded_terms_list.dart';
import 'package:weforza/widgets/pages/settings/excluded_terms/excluded_terms_list_footer.dart';
import 'package:weforza/widgets/pages/settings/excluded_terms/excluded_terms_list_header.dart';
import 'package:weforza/widgets/pages/settings/reset_ride_calendar_button.dart';
import 'package:weforza/widgets/pages/settings/rider_list_filter.dart';
import 'package:weforza/widgets/pages/settings/scan_duration_option.dart';
import 'package:weforza/widgets/pages/settings/settings_page_scroll_view.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends ConsumerState<SettingsPage> {
  final addTermController = TextEditingController();
  final addTermFocusNode = FocusNode();
  final addTermFormKey = GlobalKey<FormFieldState<String>>();

  final ScrollController scrollController = ScrollController();

  late final ExcludedTermsDelegate excludedTermsDelegate;

  late final RiderFilterDelegate riderFilterDelegate;

  late final ScanDurationDelegate scanDurationDelegate;

  @override
  void initState() {
    super.initState();

    final settingsDelegate = ref.read(settingsProvider.notifier);
    final currentSettings = ref.read(settingsProvider);

    excludedTermsDelegate = ExcludedTermsDelegate(
      settingsDelegate: settingsDelegate,
      initialValue: currentSettings.excludedTermsFilter.map((t) => ExcludedTerm(term: t)).toList(),
    );
    riderFilterDelegate = RiderFilterDelegate(
      settingsDelegate: settingsDelegate,
      initialValue: currentSettings.riderListFilter,
    );
    scanDurationDelegate = ScanDurationDelegate(
      settingsDelegate: settingsDelegate,
      initialValue: currentSettings.scanDuration.toDouble(),
    );

    addTermFocusNode.addListener(_handleAddTermFocusChange);
  }

  void _handleAddTermFocusChange() {
    if (addTermFocusNode.hasPrimaryFocus) {
      return;
    }

    addTermFormKey.currentState?.reset();
  }

  @override
  Widget build(BuildContext context) {
    return FocusAbsorber(child: PlatformAwareWidget(android: _buildAndroidWidget, ios: _buildIosWidget));
  }

  Widget _buildAndroidWidget(BuildContext context) {
    final translator = S.of(context);
    final textTheme = TextTheme.of(context);

    return SettingsPageScrollView(
      scrollController: scrollController,
      excludedTermsListHeader: const Padding(
        padding: EdgeInsets.only(left: 12, right: 12, bottom: 8),
        child: ExcludedTermsListHeader(),
      ),
      excludedTermsList: SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        sliver: ExcludedTermsList(
          addTermInputField: AddExcludedTermInputField(
            controller: addTermController,
            delegate: excludedTermsDelegate,
            focusNode: addTermFocusNode,
            formKey: addTermFormKey,
          ),
          builder: _buildExcludedTermItem,
          initialData: excludedTermsDelegate.terms,
          stream: excludedTermsDelegate.stream,
        ),
      ),
      excludedTermsListFooter: const Padding(
        padding: EdgeInsets.only(left: 12, right: 12, top: 12),
        child: ExcludedTermsListFooter(),
      ),
      riderListFilter: Padding(
        padding: const EdgeInsets.fromLTRB(12, 16, 12, 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(translator.ridersListFilter, style: textTheme.titleMedium),
            RiderListFilter(delegate: riderFilterDelegate),
            Text(
              translator.ridersListFilterDescription,
              style: textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
      resetRideCalendarButton: const Padding(
        padding: EdgeInsets.fromLTRB(24, 56, 24, 0),
        child: Center(child: ResetRideCalendarButton()),
      ),
      scanDurationOption: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 32),
        child: ScanDurationOption(delegate: scanDurationDelegate),
      ),
      version: SliverFillRemaining(
        hasScrollBody: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: AppVersion(
              builder: (version) {
                return Text(
                  '${translator.version} $version',
                  style: textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExcludedTermItem(List<ExcludedTerm> terms, int index, {BoxDecoration? decoration, Widget? divider}) {
    final term = terms[index];

    return EditExcludedTermInputField(
      decoration: decoration,
      delegate: excludedTermsDelegate,
      divider: divider,
      index: index,
      excludedTerm: term,
      scrollController: scrollController,
    );
  }

  Widget _buildIosWidget(BuildContext context) {
    final translator = S.of(context);
    final excludedTermDivider = BorderSide(
      color: CupertinoColors.separator.resolveFrom(context),
      width: 1.0 / MediaQuery.devicePixelRatioOf(context),
    );

    final decorationBackgroundColor = CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context);

    return SettingsPageScrollView(
      scrollController: scrollController,
      excludedTermsList: SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        sliver: ExcludedTermsList(
          addTermInputField: AddExcludedTermInputField(
            controller: addTermController,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
              color: decorationBackgroundColor,
            ),
            delegate: excludedTermsDelegate,
            focusNode: addTermFocusNode,
            formKey: addTermFormKey,
          ),
          initialData: excludedTermsDelegate.terms,
          stream: excludedTermsDelegate.stream,
          builder: (items, index) {
            BorderRadius borderRadius = BorderRadius.zero;

            if (index == items.length - 1) {
              borderRadius = const BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10));
            }

            return _buildExcludedTermItem(
              items,
              index,
              decoration: BoxDecoration(borderRadius: borderRadius, color: decorationBackgroundColor),
              divider: Container(
                color: excludedTermDivider.color,
                height: excludedTermDivider.width,
                margin: const EdgeInsetsDirectional.only(start: 15.0),
              ),
            );
          },
        ),
      ),
      excludedTermsListFooter: const Padding(
        // Both the CupertinoFormSection and CupertinoListSection (which is used by the former)
        // add 20 default horizontal padding to the fotter, so account for 40 total in the footer,
        // since it is not inserted using a `CupertinoFormSection.insetGrouped`.
        padding: EdgeInsetsDirectional.fromSTEB(40.0, 10.0, 40.0, 0.0),
        child: ExcludedTermsListFooter(),
      ),
      riderListFilter: CupertinoFormSection.insetGrouped(
        header: Text(translator.riders.toUpperCase()),
        footer: Text(translator.ridersListFilterDescription),
        children: [
          Padding(
            padding: const EdgeInsets.all(6),
            child: Center(child: RiderListFilter(delegate: riderFilterDelegate)),
          ),
        ],
      ),
      navigationBar: CupertinoSliverNavigationBar(
        backgroundColor: CupertinoColors.systemGroupedBackground,
        border: null,
        largeTitle: Text(translator.settings),
        transitionBetweenRoutes: false,
      ),
      resetRideCalendarButton: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: CupertinoFormSection.insetGrouped(
          header: Text(translator.rideCalendar.toUpperCase()),
          children: const [
            CupertinoFormRow(
              padding: EdgeInsetsDirectional.only(start: 20, end: 6),
              prefix: ResetRideCalendarButton(),
              child: SizedBox.shrink(),
            ),
          ],
        ),
      ),
      scanDurationOption: CupertinoFormSection.insetGrouped(
        header: Text(translator.scanSettings.toUpperCase()),
        children: [ScanDurationOption(delegate: scanDurationDelegate)],
      ),
      version: SliverToBoxAdapter(
        child: CupertinoFormSection.insetGrouped(
          children: [CupertinoFormRow(prefix: Text(translator.version), child: const AppVersion(builder: Text.new))],
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
    scrollController.dispose();
    super.dispose();
  }
}
