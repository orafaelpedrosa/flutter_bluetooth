import 'package:flutter_bluetooth/app/modules/bluetooth/bluetooth_store.dart';
import 'package:flutter_bluetooth/app/modules/bluetooth/device_details_page.dart';
import 'package:flutter_bluetooth/app/modules/bluetooth/widgets/scan_store.dart';
import 'package:flutter_bluetooth/app/modules/home/home_store.dart';
import 'package:flutter_modular/flutter_modular.dart';


import 'modules/home/home_module.dart';

class AppModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => HomeStore()),
    Bind.lazySingleton((i) => BluetoothStore()),
    Bind.lazySingleton((i) => ScanStore()),

  ];

  @override
  final List<ModularRoute> routes = [
    ModuleRoute(Modular.initialRoute, module: HomeModule()),
    ChildRoute("/device_details", child: (_, args) => DeviceDetailsPage(
      device: args.data,
    )),
  ];
}
