import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weforza/exceptions/exceptions.dart';
import 'package:weforza/file/file_handler.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/model/ride.dart';
import 'package:weforza/riverpod/ride/export_rides_provider.dart';
import 'package:weforza/theme/app_theme.dart';
import 'package:weforza/widgets/common/file_extension_selection.dart';
import 'package:weforza/widgets/common/filename_input_field.dart';
import 'package:weforza/widgets/common/generic_error.dart';
import 'package:weforza/widgets/custom/animated_checkmark.dart';
import 'package:weforza/widgets/platform/platform_aware_loading_indicator.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

/// This widget represents a page for exporting rides.
/// It supports both exporting a single ride and exporting all rides.
class ExportRidePage extends ConsumerStatefulWidget {
  const ExportRidePage({Key? key, this.rideToExport}) : super(key: key);

  final Ride? rideToExport;

  @override
  _ExportRidePageState createState() => _ExportRidePageState();
}

class _ExportRidePageState extends ConsumerState<ExportRidePage> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  late final TextEditingController _filenameController;
  final _filenameErrorController = BehaviorSubject.seeded('');
  late final ExportRidesProvider exportProvider;

  Future<void>? _exportFuture;

  FileExtension _fileExtension = FileExtension.csv;

  void onSelectFileExtension(FileExtension value) {
    if (_fileExtension != value) {
      _filenameErrorController.add('');
      _fileExtension = value;
    }
  }

  Future<void> _submitForm(S translator) {
    try {
      return exportProvider.exportRidesWithAttendees(
        fileExtension: _fileExtension.ext,
        fileName: _filenameController.text,
        ride: widget.rideToExport?.date,
      );
    } catch (error) {
      // Forward the file exists exception to the validation label.
      if (error is FileExistsException && !_filenameErrorController.isClosed) {
        _filenameErrorController.add(translator.FileExists);
      }

      rethrow;
    }
  }

  Widget _buildAndroidLayout(BuildContext context) {
    final translator = S.of(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          widget.rideToExport == null
              ? translator.ExportRides
              : translator.ExportRide,
        ),
      ),
      body: Center(child: _buildBody(context)),
    );
  }

  Widget _buildIosLayout(BuildContext context) {
    final translator = S.of(context);

    return CupertinoPageScaffold(
      resizeToAvoidBottomInset: false,
      navigationBar: CupertinoNavigationBar(
        middle: Text(
          widget.rideToExport == null
              ? translator.ExportRides
              : translator.ExportRide,
        ),
        transitionBetweenRoutes: false,
      ),
      child: Center(child: _buildBody(context)),
    );
  }

  Widget _buildBody(BuildContext context) {
    return FutureBuilder<void>(
      future: _exportFuture,
      builder: (context, snapshot) {
        final translator = S.of(context);

        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return _buildForm(translator);
          case ConnectionState.waiting:
          case ConnectionState.active:
            final label = widget.rideToExport == null
                ? translator.ExportingAllRides
                : translator.ExportingRide;

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: PlatformAwareLoadingIndicator(),
                ),
                Text(label),
              ],
            );
          case ConnectionState.done:
            final error = snapshot.error;

            if (error is FileExistsException) {
              return _buildForm(translator);
            }

            if (error != null) {
              return GenericError(text: translator.GenericError);
            }

            return LayoutBuilder(
              builder: (context, constraints) {
                final paintSize = constraints.biggest.shortestSide * .3;

                return Center(
                  child: AnimatedCheckmark(
                    color: ApplicationTheme.secondaryColor,
                    size: Size.square(paintSize),
                  ),
                );
              },
            );
        }
      },
    );
  }

  Widget _buildForm(S translator) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FileNameInputField(
              controller: _filenameController,
              errorController: _filenameErrorController,
              padding: const EdgeInsets.only(bottom: 8),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: FileExtensionSelection(
                onExtensionSelected: onSelectFileExtension,
                initialValue: FileExtension.csv,
              ),
            ),
            PlatformAwareWidget(
              android: () => ElevatedButton(
                child: Text(translator.Export),
                onPressed: () {
                  final formState = _formKey.currentState;

                  if (formState != null && formState.validate()) {
                    _exportFuture = _submitForm(translator);

                    setState(() {});
                  }
                },
              ),
              ios: () => CupertinoButton.filled(
                child: Text(
                  translator.Export,
                  style: const TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  if (_filenameErrorController.value.isEmpty) {
                    _exportFuture = _submitForm(translator);
                  }

                  setState(() {});
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    exportProvider = ref.read(exportRidesProvider);

    if (widget.rideToExport == null) {
      _filenameController = TextEditingController();
    } else {
      _filenameController = TextEditingController(
        text: S.current.ExportRideFileNamePlaceholder(
          widget.rideToExport!.dateToDDMMYYYY(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PlatformAwareWidget(
      android: () => _buildAndroidLayout(context),
      ios: () => _buildIosLayout(context),
    );
  }

  @override
  void dispose() {
    _filenameController.dispose();
    _filenameErrorController.close();
    super.dispose();
  }
}
