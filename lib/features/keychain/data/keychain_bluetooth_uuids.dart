/// UUIDs of the MyPanic BLE service published by the ESP32 keychain.
/// Mirrors `firmware/src/ble_service.h` in the mypanic-keychain repo. Do
/// not change without coordinating with the firmware repo — devices in
/// the field will not be discoverable after a UUID change.
class KeychainUuids {
  static const String service      = '5d6e3a2f-1234-4abc-9def-0123456789ab';
  static const String hardwareId   = '5d6e3a2f-1234-4abc-9def-0123456789ac';
  static const String pairData     = '5d6e3a2f-1234-4abc-9def-0123456789ad';
  static const String panicTrigger = '5d6e3a2f-1234-4abc-9def-0123456789ae';
  static const String panicAck     = '5d6e3a2f-1234-4abc-9def-0123456789af';

  KeychainUuids._();
}
