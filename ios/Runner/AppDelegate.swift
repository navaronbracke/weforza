import UIKit
import Flutter

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)

    self.setUpMethodChannels(engineBridge: engineBridge)
  }

  private func setUpMethodChannels(engineBridge: FlutterImplicitEngineBridge) {
    let bluetoothAdapterDelegate = BluetoothAdapterDelegate()
    let mediaDelegate = MediaDelegate()

    let methodChannel = FlutterMethodChannel(
        name: "be.weforza.app/methods", binaryMessenger: engineBridge.applicationRegistrar.messenger()
    )

    let bluetoothDeviceDiscoveryChannel = FlutterEventChannel(
        name: "be.weforza.app/bluetooth_device_discovery", binaryMessenger: engineBridge.applicationRegistrar.messenger()
    )

    let bluetoothStateChannel = FlutterEventChannel(
        name: "be.weforza.app/bluetooth_state", binaryMessenger: engineBridge.applicationRegistrar.messenger()
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
