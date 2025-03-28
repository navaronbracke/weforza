import UIKit
import Flutter

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    if let controller = window?.rootViewController as? FlutterViewController {
        self.setUpMethodChannels(controller: controller)
    }

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  private func setUpMethodChannels(controller: FlutterViewController) {
    let bluetoothAdapterDelegate = BluetoothAdapterDelegate()
    let mediaDelegate = MediaDelegate()

    let methodChannel = FlutterMethodChannel(
        name: "be.weforza.app/methods", binaryMessenger: controller.binaryMessenger
    )

    let bluetoothDeviceDiscoveryChannel = FlutterEventChannel(
        name: "be.weforza.app/bluetooth_device_discovery", binaryMessenger: controller.binaryMessenger
    )

    let bluetoothStateChannel = FlutterEventChannel(
        name: "be.weforza.app/bluetooth_state", binaryMessenger: controller.binaryMessenger
    )

    methodChannel.setMethodCallHandler({
        (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
        switch(call.method) {
            case "getBluetoothAdapterState":
                bluetoothAdapterDelegate.getBluetoothAdapterState(result: result)
            case "isBluetoothOn":
                bluetoothAdapterDelegate.isBluetoothOn(result: result)
            case "registerImage":
                mediaDelegate.registerImage(args: call.arguments as? Dictionary<String, Any> ?? [:], result: result)
            case "requestAddToPhotoLibraryPermission":
                mediaDelegate.requestAddToPhotoLibraryPermission(result: result)
            case "requestBluetoothScanPermission":
                bluetoothAdapterDelegate.requestBluetoothPermission(result: result)
            case "requestCameraPermission":
                mediaDelegate.requestCameraPermission(result: result)
            case "startBluetoothScan":
                bluetoothAdapterDelegate.startBluetoothScan(result: result)
            case "stopBluetoothScan":
                bluetoothAdapterDelegate.stopBluetoothScan(result: result)
            default:
                result(FlutterMethodNotImplemented)
            }
    })

    bluetoothStateChannel.setStreamHandler(bluetoothAdapterDelegate.bluetoothStateStreamHandler)
    bluetoothDeviceDiscoveryChannel.setStreamHandler(bluetoothAdapterDelegate.bluetoothDiscoveryStreamHandler)      
  }
}
