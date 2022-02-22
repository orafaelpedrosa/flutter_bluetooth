import 'package:flutter_bluetooth/app/modules/bluetooth/bluetooth_store.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../home/home_store.dart';

import 'home_page.dart';

class HomeModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => HomeStore()),
    Bind.lazySingleton((i) => BluetoothStore()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(
      Modular.initialRoute,
      child: (_, args) => HomePage(),
    ),
  ];
}
