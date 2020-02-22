
import 'package:weforza/model/device.dart';

///This class defines a contract for managing the devices of a user.
abstract class IDeviceManager {

  ///Request a new AddDevice form.
  void requestAddForm();

  ///Request a new EditDevice form and start with the data of [device].
  ///[onSuccess] provides the updated device, when it was successful.
  void requestEditForm(Device device, void Function(Device editedDevice) onSuccess);

  ///Notify that [device] got created.
  void onDeviceAdded(Device device);

  void updateDevice(Device device, int index);

  ///Hide the + Button for switching to AddDeviceForm.
  void hideAddDeviceButton();

  ///Show the + Button for switching to AddDeviceForm.
  void showAddDeviceButton();

  //TODO requestDeleteForm(String deviceName, int itemIndex)

  ///Get the list of loaded devices.
  List<Device> get devices;

  ///Get a [Stream] which says if the add device form is shown or not.
  Stream<bool> get isShowingAddDeviceForm;
}