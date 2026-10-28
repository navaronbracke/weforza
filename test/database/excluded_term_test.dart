import 'package:drift/drift.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weforza/database/database.dart';
import 'package:weforza/repository/excluded_terms_repository.dart';

void main() {
  late WeForzaDatabase database;
  late ExcludedTermsRepository repository;

  setUp(() {
    database = WeForzaDatabase.memory();
    repository = ExcludedTermsRepository(database);
  });

  tearDown(() => database.close());

  group('read', () {
    test('returns nothing if there are no excluded terms', () async {
      expect(await repository.read(), isEmpty);
    });

    test('returns the excluded terms that are present', () async {
      await database.excludedTerms.insertAll([
        ExcludedTermsCompanion.insert(term: 'term1'),
        ExcludedTermsCompanion.insert(term: 'term2'),
      ]);
      final result = await repository.read();

      expect(result, {const ExcludedTerm(term: 'term1'), const ExcludedTerm(term: 'term2')});
    });
  });

  group('write', () {
    test('adds excluded terms', () async {
      await repository.write({const ExcludedTerm(term: 'term1'), const ExcludedTerm(term: 'term2')});

      expect(await repository.read(), {const ExcludedTerm(term: 'term1'), const ExcludedTerm(term: 'term2')});
    });

    test('removes excluded terms', () async {
      await repository.write({const ExcludedTerm(term: 'term1'), const ExcludedTerm(term: 'term2')});
      await repository.write({const ExcludedTerm(term: 'term1')});

      expect(await repository.read(), {const ExcludedTerm(term: 'term1')});
    });

    test('can remove all excluded terms', () async {
      await repository.write({const ExcludedTerm(term: 'term1'), const ExcludedTerm(term: 'term2')});
      await repository.write({});

      expect(await repository.read(), isEmpty);
    });

    test('does nothing if given an empty set', () async {
      await repository.write({});

      expect(await repository.read(), isEmpty);
    });

    test('writing to an existing excluded term is idempotent', () async {
      await repository.write({const ExcludedTerm(term: 'term1')});
      await repository.write({const ExcludedTerm(term: 'term1')});

      final terms = await repository.read().then((value) => value.toSet());

      expect(terms, {const ExcludedTerm(term: 'term1')});
    });
  });
}
