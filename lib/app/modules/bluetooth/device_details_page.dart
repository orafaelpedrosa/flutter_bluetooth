import 'package:flutter/material.dart';
import 'package:flutter_bluetooth/app/modules/bluetooth/bluetooth_store.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

class DeviceDetailsPage extends StatefulWidget {
  late DiscoveredDevice device;
  DeviceDetailsPage({
    Key? key,
    required this.device,
  }) : super(key: key);

  @override
  _DeviceDetailsPageState createState() => _DeviceDetailsPageState();
}

class _DeviceDetailsPageState extends State<DeviceDetailsPage> {
  BluetoothStore store = Modular.get();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.device.name),
      ),
      body: Container(
          child: Column(
        children: [
          ElevatedButton(
            onPressed: () => store.disconnect(widget.device),
            child: const Text('Disconnect'),
          ),
          ElevatedButton(
            onPressed: () {
              store.discoverServices(widget.device).whenComplete(
                    () => store.subscribeCharacteristic(),
                  );
            },
            child: const Text('Dados'),
          ),
        ],
      )),
    );
  }
}
