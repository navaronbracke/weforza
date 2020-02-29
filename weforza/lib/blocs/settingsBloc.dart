
import 'package:weforza/blocs/bloc.dart';
import 'package:weforza/model/settings/settings.dart';
import 'package:weforza/repository/settingsRepository.dart';
import 'package:weforza/widgets/pages/settings/scanDurationOption.dart';
import 'package:weforza/widgets/pages/settings/showAllScanDevicesOption.dart';

class SettingsBloc extends Bloc {
  SettingsBloc(this._repository): assert(_repository != null);

  final SettingsRepository _repository;

  final ScanDurationHandlerDelegate _scanDurationHandler = ScanDurationHandlerDelegate();
  final ShowAllDevicesHandlerDelegate _showAllDevicesHandler = ShowAllDevicesHandlerDelegate();

  ScanDurationHandler get scanDurationHandler => _scanDurationHandler;
  ShowAllScanDevicesHandler get showAllDevicesHandler => _showAllDevicesHandler;

  bool get shouldLoadSettings => Settings.instance == null;

  Future<void> loadSettings() async {
    await _repository.loadApplicationSettings();
    final settings = Settings.instance;
    _scanDurationHandler.scanDuration = settings.scanDuration;
    _showAllDevicesHandler.showAllScannedDevices = settings.showAllScannedDevices;
  }

  @override
  void dispose() {}

}

///This class handles changes for the scan duration for [SettingsBloc].
class ScanDurationHandlerDelegate implements ScanDurationHandler {
  ScanDurationHandlerDelegate(){
    onChanged = (value) => scanDuration = value.floor();
  }

  int scanDuration;

  @override
  void Function(double value) onChanged;

  @override
  double get currentValue => scanDuration.floorToDouble();

  @override
  double get maxScanValue => 60;

  @override
  double get minScanValue => 10;
}


class ShowAllDevicesHandlerDelegate implements ShowAllScanDevicesHandler {
  ShowAllDevicesHandlerDelegate(){
    onChanged = (value) => showAllScannedDevices = value;
  }

  bool showAllScannedDevices;

  @override
  void Function(bool value) onChanged;

  @override
  bool get currentValue => showAllScannedDevices;

}