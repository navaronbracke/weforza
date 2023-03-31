import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weforza/extensions/artificial_delay_mixin.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/model/excluded_terms_delegate.dart';
import 'package:weforza/model/member_filter_option.dart';
import 'package:weforza/model/settings.dart';
import 'package:weforza/riverpod/repository/settings_repository_provider.dart';
import 'package:weforza/riverpod/settings_provider.dart';
import 'package:weforza/widgets/common/focus_absorber.dart';
import 'package:weforza/widgets/pages/settings/app_version.dart';
import 'package:weforza/widgets/pages/settings/excluded_terms/add_excluded_term_input_field.dart';
import 'package:weforza/widgets/pages/settings/excluded_terms/edit_excluded_term_input_field.dart';
import 'package:weforza/widgets/pages/settings/excluded_terms/excluded_terms_list.dart';
import 'package:weforza/widgets/pages/settings/excluded_terms/excluded_terms_list_footer.dart';
import 'package:weforza/widgets/pages/settings/excluded_terms/excluded_terms_list_header.dart';
import 'package:weforza/widgets/pages/settings/member_list_filter.dart';
import 'package:weforza/widgets/pages/settings/reset_ride_calendar_button.dart';
import 'package:weforza/widgets/pages/settings/scan_duration_option.dart';
import 'package:weforza/widgets/pages/settings/settings_page_scroll_view.dart';
import 'package:weforza/widgets/pages/settings/settings_submit.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends ConsumerState<SettingsPage>
    with ArtificialDelay {
  final addTermController = TextEditingController();
  final addTermFocusNode = FocusNode();
  final addTermFormKey = GlobalKey<FormFieldState<String>>();

  late final ExcludedTermsDelegate excludedTermsDelegate;

  late final BehaviorSubject<MemberFilterOption> memberFilterController;

  late final BehaviorSubject<double> scanDurationController;

  Future<void>? _saveSettingsFuture;

  Future<void> saveSettings() async {
    // Use an artificial delay to give the loading indicator some time to appear.
    await waitForDelay();

    final newSettings = Settings(
      excludedTermsFilter: excludedTermsDelegate.terms.toSet(),
      scanDuration: scanDurationController.value.floor(),
      memberListFilter: memberFilterController.value,
    );

    final repository = ref.read(settingsRepositoryProvider);

    await repository.write(newSettings);

    if (mounted) {
      ref.read(settingsProvider.notifier).state = newSettings;
    }
  }

  @override
  void initState() {
    super.initState();
    final settings = ref.read(settingsProvider);

    excludedTermsDelegate = ExcludedTermsDelegate(
      initialValue: settings.excludedTermsFilter.toList(),
    );
    memberFilterController = BehaviorSubject.seeded(settings.memberListFilter);
    scanDurationController = BehaviorSubject.seeded(
      settings.scanDuration.toDouble(),
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
    return FocusAbsorber(
      child: PlatformAwareWidget(
        android: _buildAndroidWidget,
        ios: _buildIosWidget,
      ),
    );
  }

  Widget _buildAndroidWidget(BuildContext context) {
    final translator = S.of(context);
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(translator.Settings),
        actions: [_buildSubmitButton()],
      ),
      body: SettingsPageScrollView(
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
        memberListFilter: Padding(
          padding: const EdgeInsets.fromLTRB(12, 16, 12, 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                translator.RiderListFilter,
                style: textTheme.titleMedium,
              ),
              Theme(
                // TODO: remove when useMaterial3 is true in MaterialApp
                data: ThemeData(useMaterial3: true, chipTheme: theme.chipTheme),
                child: MemberListFilter(
                  initialFilter: memberFilterController.value,
                  onChanged: memberFilterController.add,
                  stream: memberFilterController,
                ),
              ),
              Text(
                translator.RiderListFilterDescription,
                style: textTheme.bodySmall?.copyWith(
                  fontStyle: FontStyle.italic,
                ),
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
          child: ScanDurationOption(
            initialValue: scanDurationController.value,
            onChanged: scanDurationController.add,
            stream: scanDurationController,
          ),
        ),
        version: SliverFillRemaining(
          hasScrollBody: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 32),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: AppVersion(
                builder: (version) => Text(
                  '${translator.Version} $version',
                  style: textTheme.bodySmall?.copyWith(
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExcludedTermItem(List<String> terms, int index) {
    final term = terms[index];

    return EditExcludedTermInputField(
      delegate: excludedTermsDelegate,
      index: index,
      term: term,
    );
  }

  Widget _buildIosWidget(BuildContext context) {
    final translator = S.of(context);
    final excludedTermDivider = BorderSide(
      color: CupertinoColors.separator.resolveFrom(context),
      width: 1.0 / MediaQuery.of(context).devicePixelRatio,
    );

    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      child: SettingsPageScrollView(
        excludedTermsList: SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          sliver: ExcludedTermsList(
            addTermInputField: DecoratedBox(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                color: CupertinoColors.secondarySystemGroupedBackground,
              ),
              child: AddExcludedTermInputField(
                controller: addTermController,
                delegate: excludedTermsDelegate,
                focusNode: addTermFocusNode,
                formKey: addTermFormKey,
              ),
            ),
            initialData: excludedTermsDelegate.terms,
            stream: excludedTermsDelegate.stream,
            builder: (items, index) {
              BorderRadius borderRadius = BorderRadius.zero;

              if (index == items.length - 1) {
                borderRadius = const BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                );
              }

              return DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: borderRadius,
                  color: CupertinoColors.secondarySystemGroupedBackground,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      color: excludedTermDivider.color,
                      height: excludedTermDivider.width,
                      margin: const EdgeInsetsDirectional.only(start: 15.0),
                    ),
                    _buildExcludedTermItem(items, index),
                  ],
                ),
              );
            },
          ),
        ),
        excludedTermsListFooter: const Padding(
          padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
          child: ExcludedTermsListFooter(),
        ),
        memberListFilter: CupertinoFormSection.insetGrouped(
          header: Text(translator.Riders.toUpperCase()),
          footer: Text(translator.RiderListFilterDescription),
          children: [
            Padding(
              padding: const EdgeInsets.all(6),
              child: Center(
                child: MemberListFilter(
                  initialFilter: memberFilterController.value,
                  onChanged: memberFilterController.add,
                  stream: memberFilterController,
                ),
              ),
            ),
          ],
        ),
        navigationBar: CupertinoSliverNavigationBar(
          backgroundColor: CupertinoColors.systemGroupedBackground,
          border: null,
          largeTitle: Text(translator.Settings),
          transitionBetweenRoutes: false,
          trailing: SizedBox(
            width: 40,
            child: Center(child: _buildSubmitButton()),
          ),
        ),
        resetRideCalendarButton: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32),
          child: CupertinoFormSection.insetGrouped(
            header: Text(translator.RideCalendar.toUpperCase()),
            children: const [
              CupertinoFormRow(
                padding: EdgeInsetsDirectional.only(
                  start: 20,
                  end: 6,
                ),
                prefix: ResetRideCalendarButton(),
                child: SizedBox.shrink(),
              ),
            ],
          ),
        ),
        scanDurationOption: CupertinoFormSection.insetGrouped(
          header: Text(translator.ScanSettings.toUpperCase()),
          children: [
            ScanDurationOption(
              initialValue: scanDurationController.value,
              onChanged: scanDurationController.add,
              stream: scanDurationController,
            ),
          ],
        ),
        version: SliverToBoxAdapter(
          child: CupertinoFormSection.insetGrouped(
            children: [
              CupertinoFormRow(
                prefix: Text(translator.Version),
                child: AppVersion(
                  builder: (version) => Text(
                    version,
                    style: const TextStyle(color: CupertinoColors.systemGrey),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    // Use a stateful builder to avoid having to rebuild the entire page.
    return StatefulBuilder(
      builder: (context, setState) {
        return SettingsSubmit(
          future: _saveSettingsFuture,
          onSaveSettings: () => setState(() {
            _saveSettingsFuture = saveSettings();
          }),
        );
      },
    );
  }

  @override
  void dispose() {
    addTermController.dispose();
    addTermFocusNode.removeListener(_handleAddTermFocusChange);
    addTermFocusNode.dispose();
    excludedTermsDelegate.dispose();
    memberFilterController.close();
    scanDurationController.close();
    super.dispose();
  }
}
