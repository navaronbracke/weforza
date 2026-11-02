import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weforza/database/riders.dart';
import 'package:weforza/exceptions/rider_name_validation_exception.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/validation/rider_validator.dart';

void main() {
  group('isValidRiderName', () {
    test('returns true for valid names with and without alias', () {
      expect(RiderValidator.isValidRiderName(firstName: 'John', lastName: 'Doe', alias: null), isTrue);
      expect(RiderValidator.isValidRiderName(firstName: 'John', lastName: 'Doe', alias: ''), isTrue);
      expect(RiderValidator.isValidRiderName(firstName: 'John', lastName: 'Doe', alias: 'JD'), isTrue);
    });

    test('returns false if any part is invalid', () {
      expect(RiderValidator.isValidRiderName(firstName: '', lastName: 'Doe', alias: null), isFalse);
      expect(RiderValidator.isValidRiderName(firstName: 'John', lastName: null, alias: null), isFalse);
      expect(RiderValidator.isValidRiderName(firstName: 'John', lastName: 'Doe', alias: ' '), isFalse);
    });
  });

  group('validateAlias', () {
    test('returns null for null', () {
      expect(RiderValidator.validateAlias(null), isNull);
    });

    test('returns null for the empty string', () {
      expect(RiderValidator.validateAlias(''), isNull);
    });

    test('returns RiderNameIsBlankException for whitespace', () {
      expect(RiderValidator.validateAlias(' '), isA<RiderNameIsBlankException>());
    });

    test('returns RiderNameTooLongException for a too long alias', () {
      expect(RiderValidator.validateAlias('a' * (Riders.nameAndAliasLength.max + 1)), isA<RiderNameTooLongException>());
    });

    test('returns RiderNameContainsIllegalCharacterException for illegal characters', () {
      expect(RiderValidator.validateAlias('Rider 1'), isA<RiderNameContainsIllegalCharacterException>());
    });

    test('returns null for a valid alias', () {
      expect(RiderValidator.validateAlias('Speedy'), isNull);
    });
  });

  group('validateFirstOrLastName', () {
    test('returns RiderNameRequiredException for null', () {
      expect(RiderValidator.validateFirstOrLastName(null), isA<RiderNameRequiredException>());
    });

    test('returns RiderNameRequiredException for the empty string', () {
      expect(RiderValidator.validateFirstOrLastName(''), isA<RiderNameRequiredException>());
    });

    test('returns RiderNameIsBlankException for whitespace', () {
      expect(RiderValidator.validateFirstOrLastName(' '), isA<RiderNameIsBlankException>());
    });

    test('returns RiderNameTooLongException for a too long name', () {
      expect(
        RiderValidator.validateFirstOrLastName('a' * (Riders.nameAndAliasLength.max + 1)),
        isA<RiderNameTooLongException>(),
      );
    });

    test('returns RiderNameContainsIllegalCharacterException for illegal characters', () {
      expect(RiderValidator.validateFirstOrLastName('John1'), isA<RiderNameContainsIllegalCharacterException>());
      expect(RiderValidator.validateFirstOrLastName('John,'), isA<RiderNameContainsIllegalCharacterException>());
    });

    test('returns null for valid names', () {
      expect(RiderValidator.validateFirstOrLastName('John'), isNull);
      expect(RiderValidator.validateFirstOrLastName('Jean-Luc O\u2019Neil'), isNull);
      expect(RiderValidator.validateFirstOrLastName('a' * Riders.nameAndAliasLength.max), isNull);
    });
  });

  group('validateAliasWithErrorMessage', () {
    testWidgets('returns illegal characters message', (tester) async {
      final translator = await buildTestWidgetWithTranslator(tester);

      expect(RiderValidator.validateAliasWithErrorMessage(translator, 'Rider 1'), translator.aliasIllegalCharacters);
    });

    testWidgets('returns null for a valid alias', (tester) async {
      final translator = await buildTestWidgetWithTranslator(tester);

      expect(RiderValidator.validateAliasWithErrorMessage(translator, 'Speedy'), isNull);
    });

    testWidgets('returns null for an empty alias', (tester) async {
      final translator = await buildTestWidgetWithTranslator(tester);

      expect(RiderValidator.validateAliasWithErrorMessage(translator, ''), isNull);
      expect(RiderValidator.validateAliasWithErrorMessage(translator, null), isNull);
    });

    testWidgets('returns blank message for whitespace alias', (tester) async {
      final translator = await buildTestWidgetWithTranslator(tester);

      expect(RiderValidator.validateAliasWithErrorMessage(translator, ' '), translator.aliasBlank);
    });

    testWidgets('returns max length message for too long alias', (tester) async {
      final translator = await buildTestWidgetWithTranslator(tester);

      expect(
        RiderValidator.validateAliasWithErrorMessage(translator, 'a' * (Riders.nameAndAliasLength.max + 1)),
        translator.aliasMaxLength(Riders.nameAndAliasLength.max),
      );
    });
  });

  group('validateFirstNameWithErrorMessage', () {
    testWidgets('returns null for a valid first name', (tester) async {
      final translator = await buildTestWidgetWithTranslator(tester);

      expect(RiderValidator.validateFirstNameWithErrorMessage(translator, 'John'), isNull);
    });

    testWidgets('returns required message for empty first name', (tester) async {
      final translator = await buildTestWidgetWithTranslator(tester);

      expect(RiderValidator.validateFirstNameWithErrorMessage(translator, null), translator.firstNameRequired);
      expect(RiderValidator.validateFirstNameWithErrorMessage(translator, ''), translator.firstNameRequired);
    });

    testWidgets('returns blank message for whitespace first name', (tester) async {
      final translator = await buildTestWidgetWithTranslator(tester);

      expect(RiderValidator.validateFirstNameWithErrorMessage(translator, ' '), translator.firstNameBlank);
    });

    testWidgets('returns max length message for too long first name', (tester) async {
      final translator = await buildTestWidgetWithTranslator(tester);

      expect(
        RiderValidator.validateFirstNameWithErrorMessage(translator, 'a' * (Riders.nameAndAliasLength.max + 1)),
        translator.firstNameMaxLength(Riders.nameAndAliasLength.max),
      );
    });

    testWidgets('returns illegal characters message for invalid first name', (tester) async {
      final translator = await buildTestWidgetWithTranslator(tester);

      expect(
        RiderValidator.validateFirstNameWithErrorMessage(translator, 'john1'),
        translator.firstNameIllegalCharacters,
      );
    });
  });

  group('validateLastNameWithErrorMessage', () {
    testWidgets('returns null for a valid last name', (tester) async {
      final translator = await buildTestWidgetWithTranslator(tester);

      expect(RiderValidator.validateLastNameWithErrorMessage(translator, 'Doe'), isNull);
    });

    testWidgets('returns required message for empty last name', (tester) async {
      final translator = await buildTestWidgetWithTranslator(tester);

      expect(RiderValidator.validateLastNameWithErrorMessage(translator, null), translator.lastNameRequired);
      expect(RiderValidator.validateLastNameWithErrorMessage(translator, ''), translator.lastNameRequired);
    });

    testWidgets('returns blank message for whitespace last name', (tester) async {
      final translator = await buildTestWidgetWithTranslator(tester);

      expect(RiderValidator.validateLastNameWithErrorMessage(translator, ' '), translator.lastNameBlank);
    });

    testWidgets('returns max length message for too long last name', (tester) async {
      final translator = await buildTestWidgetWithTranslator(tester);

      expect(
        RiderValidator.validateLastNameWithErrorMessage(translator, 'a' * (Riders.nameAndAliasLength.max + 1)),
        translator.lastNameMaxLength(Riders.nameAndAliasLength.max),
      );
    });

    testWidgets('returns illegal characters message for invalid last name', (tester) async {
      final translator = await buildTestWidgetWithTranslator(tester);

      expect(
        RiderValidator.validateLastNameWithErrorMessage(translator, 'john1'),
        translator.lastNameIllegalCharacters,
      );
    });
  });
}

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
