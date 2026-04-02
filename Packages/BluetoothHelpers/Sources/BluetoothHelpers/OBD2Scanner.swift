import CoreBluetooth
import Combine
import Foundation

/// Discovers OBD2 BLE peripherals and manages a single active connection.
public final class OBD2Scanner: NSObject, @unchecked Sendable {

    // MARK: - Public publishers

    /// Emits each discovered peripheral along with its advertisement data and RSSI.
    public let discoveredPeripheralSubject = PassthroughSubject<CBPeripheral, Never>()
    /// Emits connection-level errors.
    public let errorSubject = PassthroughSubject<BluetoothError, Never>()
    /// Emits whenever a connected peripheral sends data on its notify characteristic.
    public let receivedDataSubject = PassthroughSubject<Data, Never>()

    // MARK: - Private state

    private var centralManager: CBCentralManager!
    private var connectedPeripheral: CBPeripheral?
    private var notifyCharacteristic: CBCharacteristic?

    /// The OBD2 standard service UUID.
    private static let obd2ServiceUUID = CBUUID(string: "FFF0")

    public override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: .main)
    }

    // MARK: - Public API

    /// Begins scanning for OBD2 BLE peripherals.
    public func startScanning() {
        guard centralManager.state == .poweredOn else { return }
        centralManager.scanForPeripherals(
            withServices: [Self.obd2ServiceUUID],
            options: [CBCentralManagerScanOptionAllowDuplicatesKey: false]
        )
    }

    /// Stops an ongoing scan.
    public func stopScanning() {
        centralManager.stopScan()
    }

    /// Connects to a discovered peripheral.
    public func connect(to peripheral: CBPeripheral) {
        connectedPeripheral = peripheral
        centralManager.connect(peripheral, options: nil)
    }

    /// Disconnects the currently connected peripheral.
    public func disconnect() {
        guard let peripheral = connectedPeripheral else { return }
        centralManager.cancelPeripheralConnection(peripheral)
    }
}

// MARK: - CBCentralManagerDelegate

extension OBD2Scanner: CBCentralManagerDelegate {
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .unauthorized:
            errorSubject.send(.notAuthorized)
        case .unsupported:
            errorSubject.send(.notSupported)
        case .poweredOn:
            break
        default:
            break
        }
    }

    public func centralManager(
        _ central: CBCentralManager,
        didDiscover peripheral: CBPeripheral,
        advertisementData: [String: Any],
        rssi RSSI: NSNumber
    ) {
        discoveredPeripheralSubject.send(peripheral)
    }

    public func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.delegate = self
        peripheral.discoverServices([Self.obd2ServiceUUID])
    }

    public func centralManager(
        _ central: CBCentralManager,
        didFailToConnect peripheral: CBPeripheral,
        error: Error?
    ) {
        errorSubject.send(.connectionFailed(reason: error?.localizedDescription ?? "Unknown"))
    }
}

// MARK: - CBPeripheralDelegate

extension OBD2Scanner: CBPeripheralDelegate {
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        for service in services {
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }

    public func peripheral(
        _ peripheral: CBPeripheral,
        didDiscoverCharacteristicsFor service: CBService,
        error: Error?
    ) {
        guard let characteristics = service.characteristics else { return }
        for characteristic in characteristics where characteristic.properties.contains(.notify) {
            notifyCharacteristic = characteristic
            peripheral.setNotifyValue(true, for: characteristic)
        }
    }

    public func peripheral(
        _ peripheral: CBPeripheral,
        didUpdateValueFor characteristic: CBCharacteristic,
        error: Error?
    ) {
        guard let data = characteristic.value else { return }
        receivedDataSubject.send(data)
    }
}
