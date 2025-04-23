import 'driver.dart';

// UC8253 commands/registers,
// define in the epaper display controller (UC8253) reference manual
class Uc8253 extends Driver {
  @override
  int get refresh => 0x12;
  @override
  get driverName => 'UC8253';
  @override
  List<int> get transmissionLines => [0x10, 0x13];
}
