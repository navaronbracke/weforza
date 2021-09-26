import 'package:flutter_test/flutter_test.dart';
import 'package:weforza/cipher/cipher.dart';
import 'package:weforza/model/device.dart';

import 'test_cipher.dart';

void main(){
  group("Device encryption tests", (){
    final Cipher cipher = TestCipher();

    test("Device encrypt test", (){
      final today = DateTime.now();

      final device = Device(
        ownerId: "1",
        name: "Test Device",
        creationDate: today,
      );

      final encrypted = device.encrypt(cipher);

      expect(encrypted["deviceName"], cipher.encrypt(device.name));
      expect(encrypted["owner"], device.ownerId);
      expect(encrypted["type"], device.type.index);
    });

    test("Device decrypt test", (){
      final today = DateTime.now();
      final ownerId = "1";
      final type = 0;
      final deviceName = "TestDevice";

      final device = Device.decrypt(today.toIso8601String(), {
        "deviceName": cipher.encrypt(deviceName),
        "type": type,
        "owner": ownerId,
      }, cipher);

      expect(device.name, deviceName);
      expect(device.ownerId, ownerId);
      expect(device.type.index, type);
      expect(device.creationDate, today);
    });
  });
}