import 'package:flutter/material.dart';
import 'package:flutter_bluetooth/app/modules/bluetooth/bluetooth_store.dart';
import 'package:flutter_bluetooth/app/modules/bluetooth/widgets/device_list_widget.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'home_store.dart';

class HomePage extends StatefulWidget {
  final String title;
  HomePage({Key? key, this.title = "Home"}) : super(key: key);
  BluetoothStore store = Modular.get();

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ModularState<HomePage, BluetoothStore> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bluetooth'),
      ),
      body: ScopedBuilder<BluetoothStore, Exception, List<DiscoveredDevice>>(
        store: store,
        onState: (_, scoped) {
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                DeviceList(
                  discoveredDevice: store.listDevices,
                ),
              ],
            ),
          );
        },
      ),
      /*floatingActionButton: TripleBuilder(
        store: store,
        builder: (_, triple) {
          return store.scanStarted
              ? FloatingActionButton(
                  onPressed: () => store.stopScan(),
                  backgroundColor: Colors.red,
                  child: const Icon(Icons.stop),
                )
              : FloatingActionButton(
                  onPressed: () => store.scanStart([]),
                  backgroundColor: Colors.blue,
                  child: const Icon(Icons.search),
                );
        },
      ),*/

      floatingActionButton: store.scanStarted
          ? FloatingActionButton(
              onPressed: () => store.stopScan(),
              backgroundColor: Colors.red,
              child: const Icon(Icons.stop),
            )
          : FloatingActionButton(
              onPressed: () => store.scanStart([]),
              backgroundColor: Colors.blue,
              child: const Icon(Icons.search),
            ),
    );
  }
}
