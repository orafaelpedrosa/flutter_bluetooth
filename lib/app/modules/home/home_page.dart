import 'package:flutter/material.dart';
import 'package:flutter_bluetooth/app/modules/bluetooth/bluetooth_store.dart';
import 'package:flutter_bluetooth/app/modules/bluetooth/widgets/device_list_widget.dart';
import 'package:flutter_bluetooth/app/modules/bluetooth/widgets/scan_store.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'home_store.dart';

class HomePage extends StatefulWidget {
  final String title;
  HomePage({Key? key, this.title = "Home"}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ModularState<HomePage, BluetoothStore> {
  ScanStore scan = Modular.get();

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
      floatingActionButton: TripleBuilder<ScanStore, Exception, bool>(
        store: scan,
        builder: (_, triple) {
          return scan.state
              ? FloatingActionButton(
                  onPressed: () {
                    store.stopScan();
                    scan.update(!scan.state);
                  },
                  backgroundColor: Colors.red,
                  child: const Icon(Icons.stop),
                )
              : FloatingActionButton(
                  onPressed: () {
                    store.scanStart([]);
                    scan.update(!scan.state);
                  },
                  backgroundColor: Colors.blue,
                  child: const Icon(Icons.search),
                );
        },
      ),
    );
  }
}
