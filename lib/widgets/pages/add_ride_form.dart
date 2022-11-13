import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/model/add_ride_form_delegate.dart';
import 'package:weforza/widgets/custom/add_ride_calendar/add_ride_calendar.dart';
import 'package:weforza/widgets/custom/add_ride_calendar/add_ride_calendar_color_legend.dart';
import 'package:weforza/widgets/platform/cupertino_icon_button.dart';
import 'package:weforza/widgets/platform/platform_aware_loading_indicator.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

class AddRideForm extends ConsumerStatefulWidget {
  const AddRideForm({super.key});

  @override
  AddRideFormState createState() => AddRideFormState();
}

class AddRideFormState extends ConsumerState<AddRideForm> {
  late final AddRideFormDelegate delegate;

  @override
  void initState() {
    super.initState();
    delegate = AddRideFormDelegate(ref);
  }

  Widget _buildAndroidLayout(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).NewRide),
        actions: [_ClearRideSelectionButton(delegate)],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildIosLayout(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(S.of(context).NewRide),
        transitionBetweenRoutes: false,
        trailing: _ClearRideSelectionButton(delegate),
      ),
      child: SafeArea(child: _buildBody()),
    );
  }

  Widget _buildBody() {
    return FutureBuilder<void>(
      future: delegate.initializeFuture,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            if (snapshot.hasError) {
              return Center(child: Text(S.of(context).GenericError));
            }

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AddRideCalendar(delegate: delegate),
                const Padding(
                  padding: EdgeInsets.only(top: 4),
                  child: AddRideCalendarColorLegend(),
                ),
                _AddRideFormSubmitButton(delegate: delegate),
              ],
            );
          default:
            return const Center(child: PlatformAwareLoadingIndicator());
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlatformAwareWidget(
      android: _buildAndroidLayout,
      ios: _buildIosLayout,
    );
  }

  @override
  void dispose() {
    delegate.dispose();
    super.dispose();
  }
}

class _ClearRideSelectionButton extends StatelessWidget {
  const _ClearRideSelectionButton(this.delegate);

  final AddRideFormDelegate delegate;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Set<DateTime>>(
      initialData: delegate.currentSelection,
      stream: delegate.selection,
      builder: (context, snapshot) {
        final selection = snapshot.data!;

        if (selection.isEmpty) {
          return const SizedBox.shrink();
        }

        return PlatformAwareWidget(
          android: (_) => IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: delegate.clearSelection,
          ),
          ios: (_) => CupertinoIconButton(
            color: CupertinoColors.systemRed,
            icon: CupertinoIcons.xmark_rectangle_fill,
            onPressed: delegate.clearSelection,
          ),
        );
      },
    );
  }
}

class _AddRideFormSubmitButton extends StatefulWidget {
  const _AddRideFormSubmitButton({required this.delegate});

  final AddRideFormDelegate delegate;

  @override
  State<_AddRideFormSubmitButton> createState() =>
      _AddRideFormSubmitButtonState();
}

class _AddRideFormSubmitButtonState extends State<_AddRideFormSubmitButton> {
  Widget _buildButton({
    String errorMessage = '',
    required String label,
    void Function()? onTap,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 2),
          child: Text(errorMessage),
        ),
        PlatformAwareWidget(
          android: (_) => ElevatedButton(onPressed: onTap, child: Text(label)),
          ios: (_) => CupertinoButton.filled(
            onPressed: onTap,
            child: Text(label),
          ),
        ),
      ],
    );
  }

  void _onSubmitPressed() {
    setState(widget.delegate.saveSelectedRides);
  }

  @override
  Widget build(BuildContext context) {
    // Observe the ride selection
    // so that any submit errors are cleared when the selection is updated.
    // The delegate locks the selection when it is being saved.
    return StreamBuilder<Set<DateTime>>(
      initialData: widget.delegate.currentSelection,
      stream: widget.delegate.selection,
      builder: (_, selectionSnapshot) {
        final hasSelection = selectionSnapshot.data?.isNotEmpty ?? false;

        return FutureBuilder<void>(
          future: widget.delegate.submitFuture?.then((_) {
            if (mounted) {
              Navigator.of(context).pop();
            }
          }),
          builder: (context, submitSnapshot) {
            final translator = S.of(context);

            switch (submitSnapshot.connectionState) {
              case ConnectionState.none:
                return _buildButton(
                  label: translator.AddSelection,
                  onTap: hasSelection ? _onSubmitPressed : null,
                );
              case ConnectionState.active:
              case ConnectionState.waiting:
                return const PlatformAwareLoadingIndicator();
              case ConnectionState.done:
                if (submitSnapshot.hasError) {
                  return _buildButton(
                    errorMessage: translator.GenericError,
                    label: translator.AddSelection,
                    onTap: hasSelection ? _onSubmitPressed : null,
                  );
                }

                return const PlatformAwareLoadingIndicator();
            }
          },
        );
      },
    );
  }
}
