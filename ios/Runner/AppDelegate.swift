import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
  ) -> Bool {      
    let controller =  window?.rootViewController as! FlutterViewController
    let bluetoothAdapterDelegate = BluetoothAdapterDelegate()
      
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
            case "requestBluetoothScanPermission":
                bluetoothAdapterDelegate.requestBluetoothPermission(result: result)
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
      
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
