import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weforza/database/devices.dart';
import 'package:weforza/exceptions/device_name_validation_exception.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/validation/device_validator.dart';

void main() {
  group('validateDeviceName', () {
    test('returns DeviceNameRequiredException for null', () {
      expect(DeviceValidator.validateDeviceName(null), isA<DeviceNameRequiredException>());
    });

    test('returns DeviceNameRequiredException for the empty string', () {
      expect(DeviceValidator.validateDeviceName(''), isA<DeviceNameRequiredException>());
    });

    test('returns DeviceNameIsBlankException for whitespace', () {
      expect(DeviceValidator.validateDeviceName('   '), isA<DeviceNameIsBlankException>());
    });

    test('returns DeviceNameTooLongException for a too long name', () {
      final name = 'a' * (Devices.nameLength.max + 1);

      expect(DeviceValidator.validateDeviceName(name), isA<DeviceNameTooLongException>());
    });

    test('returns DeviceNameContainsIllegalCharacterException for a name with a comma', () {
      expect(DeviceValidator.validateDeviceName('My, Device'), isA<DeviceNameContainsIllegalCharacterException>());
    });

    test('returns null for a valid name', () {
      expect(DeviceValidator.validateDeviceName('My Device'), isNull);
    });

    test('returns null for a name with the maximum length', () {
      expect(DeviceValidator.validateDeviceName('a' * Devices.nameLength.max), isNull);
    });
  });

  group('validateDeviceNameWithErrorMessage', () {
    Future<S> buildTestWidgetWithTranslator(WidgetTester tester) async {
      final Key key = UniqueKey();

      await tester.pumpWidget(
        WidgetsApp(
          color: const Color(0xFFFFFFFF),
          pageRouteBuilder: <T>(settings, builder) {
            return PageRouteBuilder<T>(settings: settings, pageBuilder: (context, _, _) => builder(context));
          },
          localizationsDelegates: S.localizationsDelegates,
          supportedLocales: S.supportedLocales,
          home: SizedBox.shrink(key: key),
        ),
      );

      return S.of(tester.element(find.byKey(key)));
    }

    testWidgets('returns device name required message', (WidgetTester tester) async {
      final translator = await buildTestWidgetWithTranslator(tester);

      expect(DeviceValidator.validateDeviceNameWithErrorMessage(translator, null), translator.deviceNameRequired);
      expect(DeviceValidator.validateDeviceNameWithErrorMessage(translator, ''), translator.deviceNameRequired);
    });

    testWidgets('returns device name blank message', (WidgetTester tester) async {
      final translator = await buildTestWidgetWithTranslator(tester);

      expect(DeviceValidator.validateDeviceNameWithErrorMessage(translator, ' '), translator.deviceNameBlank);
    });

    testWidgets('returns device name too long message', (WidgetTester tester) async {
      final translator = await buildTestWidgetWithTranslator(tester);

      expect(
        DeviceValidator.validateDeviceNameWithErrorMessage(translator, 'a' * (Devices.nameLength.max + 1)),
        translator.deviceNameMaxLength(Devices.nameLength.max),
      );
    });

    testWidgets('returns device name cannot contain comma message', (WidgetTester tester) async {
      final translator = await buildTestWidgetWithTranslator(tester);

      expect(
        DeviceValidator.validateDeviceNameWithErrorMessage(translator, 'a,b'),
        translator.deviceNameCannotContainComma,
      );
    });

    testWidgets('returns null for valid device name', (WidgetTester tester) async {
      final translator = await buildTestWidgetWithTranslator(tester);

      expect(DeviceValidator.validateDeviceNameWithErrorMessage(translator, 'My Device'), isNull);
    });
  });
}
