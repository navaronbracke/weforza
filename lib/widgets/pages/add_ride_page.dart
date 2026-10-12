import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show ValueListenable;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/model/add_ride_page_delegate.dart';
import 'package:weforza/riverpod/repository/ride_repository_provider.dart';
import 'package:weforza/riverpod/ride/ride_list_provider.dart';
import 'package:weforza/widgets/common/generic_error.dart';
import 'package:weforza/widgets/custom/add_ride_calendar/add_ride_calendar.dart';
import 'package:weforza/widgets/custom/add_ride_calendar/add_ride_calendar_color_legend.dart';
import 'package:weforza/widgets/platform/cupertino_icon_button.dart';
import 'package:weforza/widgets/platform/platform_aware_loading_indicator.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

/// This class represents the page that allows adding new rides.
class AddRidePage extends ConsumerStatefulWidget {
  const AddRidePage({super.key});

  @override
  ConsumerState<AddRidePage> createState() => _AddRidePageState();
}

class _AddRidePageState extends ConsumerState<AddRidePage> {
  late final AddRidePageDelegate _delegate;

  @override
  void initState() {
    super.initState();
    _delegate = AddRidePageDelegate(repository: ref.read(rideRepositoryProvider));
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: FutureBuilder<void>(
        future: _delegate.initializeFuture,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              if (snapshot.hasError) {
                return Center(
                  child: GenericErrorWithBackButton(message: S.of(context).addRideCalendarGenericErrorMessage),
                );
              }

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AddRideCalendar(delegate: _delegate),
                  const Padding(padding: EdgeInsets.only(top: 4), child: AddRideCalendarColorLegend()),
                  _AddRideSubmitButton(
                    onPressed: () => onSubmitPressed(context),
                    selectionListenable: _delegate.selectionListenable,
                    stateListenable: _delegate.stateListenable,
                  ),
                ],
              );
            case ConnectionState.active:
            case ConnectionState.none:
            case ConnectionState.waiting:
              return const Center(child: PlatformAwareLoadingIndicator());
          }
        },
      ),
    );
  }

  Widget _buildClearSelectionButton({required Widget button}) {
    return ValueListenableBuilder<Set<DateTime>>(
      valueListenable: _delegate.selectionListenable,
      builder: (context, selection, _) => selection.isEmpty ? const SizedBox.shrink() : button,
    );
  }

  void onSubmitPressed(BuildContext context) {
    _delegate.saveRides(
      whenComplete: () {
        if (mounted) {
          ref.invalidate(rideListProvider);
          Navigator.of(context).pop();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlatformAwareWidget(
      android: (_) {
        return Scaffold(
          appBar: AppBar(
            title: Text(S.of(context).newRide),
            actions: [
              _buildClearSelectionButton(
                button: IconButton(icon: const Icon(Icons.delete_sweep), onPressed: _delegate.clearSelection),
              ),
            ],
          ),
          body: _buildBody(),
        );
      },
      ios: (_) {
        return CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            middle: Text(S.of(context).newRide),
            transitionBetweenRoutes: false,
            trailing: _buildClearSelectionButton(
              button: CupertinoIconButton(
                color: CupertinoColors.systemRed,
                icon: CupertinoIcons.xmark_rectangle_fill,
                onPressed: _delegate.clearSelection,
              ),
            ),
          ),
          child: SafeArea(child: _buildBody()),
        );
      },
    );
  }

  @override
  void dispose() {
    _delegate.dispose();
    super.dispose();
  }
}

class _AddRideSubmitButton extends StatelessWidget {
  const _AddRideSubmitButton({
    required this.onPressed,
    required this.selectionListenable,
    required this.stateListenable,
  });

  /// The onPressed handler for the button.
  final void Function() onPressed;

  /// The [ValueListenable] that provides the selection changes.
  final ValueListenable<Set<DateTime>> selectionListenable;

  /// The [ValueListenable] that provides the state changes for the button.
  final ValueListenable<AsyncValue<void>?> stateListenable;

  Widget _buildButton({required bool showButton, String errorMessage = ''}) {
    Widget button;

    if (showButton) {
      button = ValueListenableBuilder<Set<DateTime>>(
        valueListenable: selectionListenable,
        builder: (context, selectionValue, _) {
          final hasSelection = selectionValue.isNotEmpty;
          final translator = S.of(context);

          return PlatformAwareWidget(
            android: (_) {
              return ElevatedButton(onPressed: hasSelection ? onPressed : null, child: Text(translator.addSelection));
            },
            ios: (_) => CupertinoButton.filled(
              onPressed: hasSelection ? onPressed : null,
              child: Text(
                translator.addSelection,
                style: TextStyle(color: hasSelection ? CupertinoColors.white : CupertinoColors.inactiveGray),
              ),
            ),
          );
        },
      );
    } else {
      button = PlatformAwareWidget(
        android: (_) => const CircularProgressIndicator(),
        ios: (_) => const SizedBox(height: 48, child: Center(child: CupertinoActivityIndicator())),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 12, bottom: 4),
          child: GenericErrorLabel(message: errorMessage),
        ),
        button,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AsyncValue<void>?>(
      valueListenable: stateListenable,
      builder: (context, value, _) {
        if (value == null) {
          return _buildButton(showButton: true);
        }

        return value.when(
          // The submit button does not have a done state.
          data: (_) => _buildButton(showButton: false),
          error: (error, stackTrace) => _buildButton(showButton: true, errorMessage: S.of(context).genericError),
          loading: () => _buildButton(showButton: false),
        );
      },
    );
  }
}
