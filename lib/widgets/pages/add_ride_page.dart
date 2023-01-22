import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
    _delegate = AddRidePageDelegate(
      repository: ref.read(rideRepositoryProvider),
    );
  }

  Widget _buildBody() {
    return FutureBuilder<void>(
      future: _delegate.initializeFuture,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            if (snapshot.hasError) {
              return Center(
                child: GenericErrorWithBackButton(
                  message: S.of(context).AddRideCalendarGenericErrorMessage,
                ),
              );
            }

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AddRideCalendar(delegate: _delegate),
                const Padding(
                  padding: EdgeInsets.only(top: 4),
                  child: AddRideCalendarColorLegend(),
                ),
                _AddRideSubmitButton(
                  initialSelection: _delegate.currentSelection,
                  initialState: _delegate.currentState,
                  onPressed: () => onSubmitPressed(context),
                  selectionStream: _delegate.selectionStream,
                  stateStream: _delegate.stream,
                ),
              ],
            );
          case ConnectionState.active:
          case ConnectionState.none:
          case ConnectionState.waiting:
            return const Center(child: PlatformAwareLoadingIndicator());
        }
      },
    );
  }

  Widget _buildClearSelectionButton({required Widget button}) {
    return StreamBuilder<Set<DateTime>>(
      initialData: _delegate.currentSelection,
      stream: _delegate.selectionStream,
      builder: (context, snapshot) {
        final selection = snapshot.data!;

        if (selection.isEmpty) {
          return const SizedBox.shrink();
        }

        return button;
      },
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
      android: (_) => Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).NewRide),
          actions: [
            _buildClearSelectionButton(
              button: IconButton(
                icon: const Icon(Icons.delete_sweep),
                onPressed: _delegate.clearSelection,
              ),
            ),
          ],
        ),
        body: _buildBody(),
      ),
      ios: (_) => CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text(S.of(context).NewRide),
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
      ),
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
    required this.initialSelection,
    required this.initialState,
    required this.onPressed,
    required this.selectionStream,
    required this.stateStream,
  });

  /// The initial selection of the rides that should be added.
  final Set<DateTime> initialSelection;

  /// The initial state for the button.
  final AsyncValue<void>? initialState;

  /// The onPressed handler for the button.
  final void Function() onPressed;

  /// The stream of ride selection changes.
  final Stream<Set<DateTime>> selectionStream;

  /// The stream of state changes for the button.
  final Stream<AsyncValue<void>?> stateStream;

  Widget _buildButton({required bool showButton, String errorMessage = ''}) {
    Widget button;

    if (showButton) {
      button = StreamBuilder<Set<DateTime>>(
        initialData: initialSelection,
        stream: selectionStream,
        builder: (context, snapshot) {
          final hasSelection = snapshot.data?.isNotEmpty ?? false;
          final translator = S.of(context);

          return PlatformAwareWidget(
            android: (_) => ElevatedButton(
              onPressed: hasSelection ? onPressed : null,
              child: Text(translator.AddSelection),
            ),
            ios: (_) => CupertinoButton.filled(
              onPressed: hasSelection ? onPressed : null,
              child: Text(translator.AddSelection),
            ),
          );
        },
      );
    } else {
      button = PlatformAwareWidget(
        android: (_) => const CircularProgressIndicator(),
        ios: (_) => const SizedBox(
          height: 48,
          child: Center(child: CupertinoActivityIndicator()),
        ),
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
    return StreamBuilder<AsyncValue<void>?>(
      initialData: initialState,
      stream: stateStream,
      builder: (context, snapshot) {
        final future = snapshot.data;

        if (future == null) {
          return _buildButton(showButton: true);
        }

        return future.when(
          // The submit button does not have a done state.
          data: (_) => _buildButton(showButton: false),
          error: (error, stackTrace) => _buildButton(
            showButton: true,
            errorMessage: S.of(context).GenericError,
          ),
          loading: () => _buildButton(showButton: false),
        );
      },
    );
  }
}
