import Foundation
import CoreBluetooth

import Flutter

/// This class represents the delegate that manages a ``CBCentralManager``.
class BluetoothAdapterDelegate : NSObject, CBCentralManagerDelegate {
    private let BLUETOOTH_SCAN_RESULT_ERROR_CODE = "BLUETOOTH_SCAN_RESULT_ERROR"
    private let BLUETOOTH_SCAN_RESULT_ERROR_MESSAGE = "A scan result returned an error."
    
    private let BLUETOOTH_UNAUTHORIZED_ERROR_CODE = "BLUETOOTH_UNAUTHORIZED"
    private let BLUETOOTH_UNAUTHORIZED_ERROR_MESSAGE = "Access to Bluetooth was denied."

    private let BLUETOOTH_UNAVAILABLE_ERROR_CODE = "BLUETOOTH_UNAVAILABLE"
    private let BLUETOOTH_UNAVAILABLE_ERROR_MESSAGE = "Bluetooth is not supported on this device."
    
    private let BLUETOOTH_PERMISSION_REQUEST_ONGOING_ERROR_CODE = "BLUETOOTH_PERMISSION_REQUEST_ONGOING"
    private let BLUETOOTH_PERMISSION_REQUEST_ONGOING_ERROR_MESSAGE = "A Bluetooth permission request is in progress."
    
    /// The internal Bluetooth manager.
    private var _bluetoothManager: CBCentralManager?
    
    /// The pending Bluetooth permission result.
    ///
    /// This result is cached when the Bluetooth permission is requested.
    /// It will be resolved with a boolean once the permission request completed.
    /// Only one pending permission result can be active at once.
    private var _pendingPermissionResult: FlutterResult?
    
    /// The pending Bluetooth on/off state result.
    ///
    /// This result is cached when the Bluetooth on/off state is queried on-demand
    /// and the state is either ``CBManagerState.unknown`` or ``CBManagerState.resetting``.
    /// It will be resolved with a boolean once ``CBManagerState.poweredOn`` or ``CBManagerState.poweredOff``
    /// is the current state.
    /// Only one pending Bluetooth state result result can be active at once.
    private var _pendingBluetoothIsOnOrOffResult: FlutterResult?
    
    public let bluetoothStateStreamHandler = BluetoothStateStreamHandler()
    
    public let bluetoothDiscoveryStreamHandler = BluetoothDeviceDiscoveryStreamHandler()
    
    /// Check whether Bluetooth permission is granted or denied.
    private func checkBluetoothPermissionStatus(bluetoothManager: CBCentralManager) -> Bool? {
        if #available(iOS 13.1, *) {
            switch(CBCentralManager.authorization) {
            case .notDetermined:
                return nil
            case .restricted:
                return false
            case .denied:
                return false
            case .allowedAlways:
                return true
            @unknown default:
                return false
            }
        } else if #available(iOS 13.0, *) {
            switch(bluetoothManager.authorization) {
            case .notDetermined:
                return nil
            case .restricted:
                return false
            case .denied:
                return false
            case .allowedAlways:
                return true
            @unknown default:
                return false
            }
        } else {
            // Below iOS 13.0, Bluetooh permissions do not exist.
            return true
        }
    }
    
    /// Handle changes in the state of the ``CBCentralManager``.
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        // Check if the permission result was pending and resolve it now.
        if(self._pendingPermissionResult != nil) {
            let permissionStatus = checkBluetoothPermissionStatus(bluetoothManager: central)
            
            // If the permission state is still undetermined, return false.
            self._pendingPermissionResult?(permissionStatus ?? false)
            self._pendingPermissionResult = nil
        }
        
        let bluetoothAdapterState = central.state

        self.bluetoothStateStreamHandler.onBluetoothStateChanged(state: bluetoothAdapterState)
        
        // Check if the Bluetooth on/off result was pending and resolve it now.
        if(self._pendingBluetoothIsOnOrOffResult != nil) {
            switch(bluetoothAdapterState) {
            case .unknown:
                break
            case .resetting:
                break
            case .unsupported:
                self._pendingBluetoothIsOnOrOffResult?(FlutterError(
                    code: BLUETOOTH_UNAVAILABLE_ERROR_CODE,
                    message: BLUETOOTH_UNAVAILABLE_ERROR_MESSAGE,
                    details: nil))
                self._pendingBluetoothIsOnOrOffResult = nil
            case .unauthorized:
                self._pendingBluetoothIsOnOrOffResult?(FlutterError(
                    code: BLUETOOTH_UNAUTHORIZED_ERROR_CODE,
                    message: BLUETOOTH_UNAUTHORIZED_ERROR_MESSAGE,
                    details: nil))
                self._pendingBluetoothIsOnOrOffResult = nil
            case .poweredOff:
                self._pendingBluetoothIsOnOrOffResult?(false)
                self._pendingBluetoothIsOnOrOffResult = nil
            case .poweredOn:
                self._pendingBluetoothIsOnOrOffResult?(true)
                self._pendingBluetoothIsOnOrOffResult = nil
            @unknown default:
                break
            }
        }
    }
    
    /// Handle Bleutooth device discovery results.
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        bluetoothDiscoveryStreamHandler.onDeviceFound(device: peripheral, advertisementData: advertisementData)
    }
    
    /// Get the current state of the Bluetooth adapter.
    func getBluetoothAdapterState(result: @escaping FlutterResult) {
        let state = _bluetoothManager?.state ?? CBManagerState.unsupported
        
        result(state.toSerializedString())
    }
    
    /// Initialize the ``CBCentralManager`` without showing a permission dialog.
    private func initializeBluetoothManager() {
        if(_bluetoothManager == nil) {
            // Allocating the `CBCentralManager` requests Bluetooth permissions.
            _bluetoothManager = CBCentralManager(delegate: self, queue: nil, options: [CBCentralManagerOptionShowPowerAlertKey: false])
            self.bluetoothStateStreamHandler.setCachedState(state: _bluetoothManager?.state)
        }
    }
    
    /// Check whether Bluetooth is currently on.
    func isBluetoothOn(result: @escaping FlutterResult) {
        guard let bluetoothManager = _bluetoothManager else {
            result(FlutterError(
                code: BLUETOOTH_UNAVAILABLE_ERROR_CODE,
                message: BLUETOOTH_UNAVAILABLE_ERROR_MESSAGE,
                details: nil))
            return
        }
        
        // If the current state is unknown or resetting,
        // cache the pending result and wait for a state change.
        switch(bluetoothManager.state) {
        case .unknown:
            _pendingBluetoothIsOnOrOffResult = result
        case .resetting:
            _pendingBluetoothIsOnOrOffResult = result
        case .unsupported:
            result(FlutterError(
                code: BLUETOOTH_UNAVAILABLE_ERROR_CODE,
                message: BLUETOOTH_UNAVAILABLE_ERROR_MESSAGE,
                details: nil))
        case .unauthorized:
            result(FlutterError(
                code: BLUETOOTH_UNAUTHORIZED_ERROR_CODE,
                message: BLUETOOTH_UNAUTHORIZED_ERROR_MESSAGE,
                details: nil))
        case .poweredOff:
            result(false)
        case .poweredOn:
            result(true)
        @unknown default:
            break
        }
    }
    
    /// Set up the ``CBCentralManager`` and request Bluetooth permissions.
    func requestBluetoothPermission(result: @escaping FlutterResult) {
        if(_pendingPermissionResult != nil) {
            result(FlutterError(
                code: BLUETOOTH_PERMISSION_REQUEST_ONGOING_ERROR_CODE,
                message: BLUETOOTH_PERMISSION_REQUEST_ONGOING_ERROR_MESSAGE,
                details: nil))
            
            return
        }
        
        _pendingPermissionResult = result
        
        // Set up the CBCentralManager if needed.
        initializeBluetoothManager()
        
        guard let bluetoothManager = _bluetoothManager else {
            result(FlutterError(
                code: BLUETOOTH_UNAVAILABLE_ERROR_CODE,
                message: BLUETOOTH_UNAVAILABLE_ERROR_MESSAGE,
                details: nil))
            return
        }
        
        let hasBluetoothPermision = checkBluetoothPermissionStatus(bluetoothManager: bluetoothManager)
        
        // Reset the pending result if the permission was granted or denied before.
        // Finally, resolve the permission if it is known.
        // If the permission is not known, it is resolved in `centralManagerDidUpdateState`.
        if(hasBluetoothPermision != nil) {
            result(hasBluetoothPermision)
            _pendingPermissionResult = nil
        }
    }
    
    /// Start a new Bluetooth scan.
    ///
    /// This method assumes that permission was granted before,
    /// since checking the authorization status might show a permission dialog.
    func startBluetoothScan(result: @escaping FlutterResult) {
        guard let bluetoothManager = _bluetoothManager else {
            result(FlutterError(
                code: BLUETOOTH_UNAVAILABLE_ERROR_CODE,
                message: BLUETOOTH_UNAVAILABLE_ERROR_MESSAGE,
                details: nil))
            return
        }
        
        if(!bluetoothManager.isScanning) {
            bluetoothManager.scanForPeripherals(withServices: [], options: [:])
        }
        
        result(nil)
    }
    
    /// Stop a running Bluetooth scan.
    ///
    /// This method assumes that permission was granted before,
    /// since checking the authorization status might show a permission dialog.
    func stopBluetoothScan(result: @escaping FlutterResult) {
        guard let bluetoothManager = _bluetoothManager else {
            result(FlutterError(
                code: BLUETOOTH_UNAVAILABLE_ERROR_CODE,
                message: BLUETOOTH_UNAVAILABLE_ERROR_MESSAGE,
                details: nil))
            return
        }
        
        if(bluetoothManager.isScanning) {
            bluetoothManager.stopScan()
        }

        result(nil)
    }
}

extension CBManagerState {
    func toSerializedString() -> String {
        switch(self) {
        case .unknown:
            return "unknown"
        case .resetting:
            return "resetting"
        case .unsupported:
            return "unavailable"
        case .unauthorized:
            return "unauthorized"
        case .poweredOff:
            return "off"
        case .poweredOn:
            return "on"
        @unknown default:
            return "unknown"
        }
    }
}

/// This class manages the Bluetooth device discovery ``FlutterEventSink``.
class BluetoothDeviceDiscoveryStreamHandler : NSObject, FlutterStreamHandler {
    private var sink: FlutterEventSink?
    
    func onDeviceFound(device: CBPeripheral, advertisementData: [String : Any]) {
        let deviceId: String = device.identifier.uuidString
        // If the device name is nil, check the advertisement packet.
        let deviceName: String? = device.name ?? advertisementData[CBAdvertisementDataLocalNameKey] as? String

        sink?([
            "deviceId": deviceId,
            "deviceName": deviceName,
        ])
    }
    
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        sink = events
        
        return nil
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        sink = nil
        
        return nil
    }
}

/// This class manages the stream of Bluetooth state changes.
class BluetoothStateStreamHandler : NSObject, FlutterStreamHandler {
    private var sink: FlutterEventSink?
    private var cachedBluetoothState: CBManagerState?
    
    func onBluetoothStateChanged(state: CBManagerState) {
        if(sink == nil) {
            cachedBluetoothState = state
        } else {
            sink?(state.toSerializedString())
        }
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        sink = nil
        
        return nil
    }
    
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        sink = events
        
        if(cachedBluetoothState != nil) {
            sink?(cachedBluetoothState?.toSerializedString())
        }
        
        return nil
    }
    
    func setCachedState(state: CBManagerState?) {
        cachedBluetoothState = state
    }
}
