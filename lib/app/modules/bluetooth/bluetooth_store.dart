import 'dart:async';
import 'dart:developer';

import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_triple/flutter_triple.dart';

class BluetoothStore extends NotifierStore<Exception, List<DiscoveredDevice>> {
  bool foundDeviceWaitingToConnect = false;
  bool scanStarted = false;
  bool connected = false;

  FlutterReactiveBle flutterReactiveBle = FlutterReactiveBle();
  late StreamSubscription<List<int>>? subscribeStream;
  StreamSubscription<DiscoveredDevice>? scanStream;
  late StreamSubscription<ConnectionStateUpdate> _connection;
  late StreamSubscription subscription;
  final listDevices = <DiscoveredDevice>[];
  late List<DiscoveredService> listDiscoveredService = <DiscoveredService>[];
  late QualifiedCharacteristic rxCharacteristic;
  final _deviceConnectionController = StreamController<ConnectionStateUpdate>();

  String? readOutput;
  String? writeOutput;
  String? subscribeOutput;

  BluetoothStore() : super([]);

  Future<void> scanStart(List<Uuid> serviceIds) async {
    listDevices.clear();
    stopScan();

    scanStream = flutterReactiveBle.scanForDevices(
      withServices: [],
      requireLocationServicesEnabled: false,
    ).listen(
      (device) {
        final knownDeviceIndex =
            listDevices.indexWhere((d) => d.id == device.id);
        if (knownDeviceIndex >= 0) {
          listDevices[knownDeviceIndex] = device;
        } else {
          if (device.name != '') {
            listDevices.add(device);
            update(listDevices);
          }
        }
      },
    );
  }

  Future<void> stopScan() async {
    if (scanStream != null) scanStream?.cancel();
  }

  Future<void> connect(DiscoveredDevice device) async {
    log('Start connecting to ${device.name}');
    _connection = flutterReactiveBle.connectToDevice(id: device.id).listen(
      (update) {
        log('ConnectionState for device ${device.name} : ${update.connectionState}');
        _deviceConnectionController.add(update);
        if (update.connectionState == DeviceConnectionState.connected) {
          connected = true;
        }
      },
      onError: (Object e) =>
          log('Connecting to device ${device.name} resulted in error $e'),
    );
  }

  Future<void> disconnect(DiscoveredDevice device) async {
    try {
      log('disconnecting to device: ${device.name}');
      await _connection.cancel();
    } on Exception catch (e, _) {
      log("Error disconnecting from a device: $e");
    } finally {
      _deviceConnectionController.add(
        ConnectionStateUpdate(
          deviceId: device.id,
          connectionState: DeviceConnectionState.disconnected,
          failure: null,
        ),
      );
    }
  }

  Future<void> discoverServices(DiscoveredDevice device) async {
    try {
      log('Start discovering services for: ${device.name}');
      bool onDevice = false;
      listDiscoveredService =
          await flutterReactiveBle.discoverServices(device.id);
      listDiscoveredService.forEach(
        (service) {
          service.characteristics.forEach(
            (characteristics) async {
              switch (characteristics.characteristicId.toString()) {
                case '2a35':
                  onDevice = true;

                  break;
                case '0aad7ea0-0d60-11e2-8e3c-0002a5d5c51b':
                  onDevice = true;

                  break;
                case '2a1c':
                  onDevice = true;

                  break;
                case '2a18':
                  onDevice = true;

                  break;
              }
              if (onDevice) {
                onDevice = false;
                rxCharacteristic = QualifiedCharacteristic(
                  characteristicId: characteristics.characteristicId,
                  serviceId: characteristics.serviceId,
                  deviceId: device.id,
                );
              }
            },
          );
        },
      );
    } on Exception catch (e) {
      log('Error occured when discovering services: $e');
      rethrow;
    }
  }

  Future<void> subscribeCharacteristic() async {
    log(rxCharacteristic.toString());
    if (connected) {
      await Future.delayed(const Duration(milliseconds: 500));
      log('Starting subscribe characteristic...');
      subscribeStream =
          flutterReactiveBle.subscribeToCharacteristic(rxCharacteristic).listen(
        (data) {
          subscribeOutput = data.toString();
          log(data.toString());
        },
      );
    }
  }

  Future<void> readCharacteristic() async {
    setLoading(true);
    final result =
        await flutterReactiveBle.readCharacteristic(rxCharacteristic);
    readOutput = result.toString();
    log(result.toString());
    setLoading(false);
  }

  Future<void> writeCharacteristicWithResponse() async {
    setLoading(true);
    await flutterReactiveBle.writeCharacteristicWithResponse(
      rxCharacteristic,
      value: [0xff],
    );
    setLoading(false);
  }

  Future<void> writeCharacteristicWithoutResponse() async {
    setLoading(true);
    await flutterReactiveBle.writeCharacteristicWithoutResponse(
      rxCharacteristic,
      value: [0xff],
    );
    setLoading(false);
  }

  Future<void> dispose() async {
    await _deviceConnectionController.close();
  }
}
