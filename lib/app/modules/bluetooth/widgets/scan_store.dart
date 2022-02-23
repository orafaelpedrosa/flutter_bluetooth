import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';

import 'package:flutter_bluetooth/app/modules/bluetooth/bluetooth_store.dart';

class ScanStore extends NotifierStore<Exception, bool> {
  BluetoothStore store = Modular.get();
  ScanStore() : super(true);

  bool getStateScan() {
    return store.scanStarted;
  }
}
